#!/bin/bash

# Define the PSQL command with necessary options
# -X: Disable reading of the ~/.psqlrc file
# --username=freecodecamp: Connect as the user 'freecodecamp'
# --dbname=periodic_table: Connect to the 'periodic_table' database
# --tuples-only: Output only the data, without headers or row count
# -c: Execute the following command
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Main function to handle the program logic
MAIN_PROGRAM() {
  # Check if an argument is provided
  if [[ -z $1 ]]
  then
    # If no argument is provided, prompt the user to provide an element
    echo "Please provide an element as an argument."
  else
    # If an argument is provided, call the PRINT_ELEMENT function with the argument
    PRINT_ELEMENT $1
  fi
}

# Function to print the details of the element
PRINT_ELEMENT() {
  # Store the input argument
  INPUT=$1
  # Check if the input is not a number (i.e., it's a symbol or name)
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    # Query the database to get the atomic number using the symbol or name
    # Use sed to remove spaces from the output
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';") | sed 's/ //g')
  else
    # Query the database to get the atomic number using the atomic number directly
    # Use sed to remove spaces from the output
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;") | sed 's/ //g')
  fi
  
  # Check if the atomic number was found
  if [[ -z $ATOMIC_NUMBER ]]
  then
    # If not found, print an error message
    echo "I could not find that element in the database."
  else
    # Query the database to get the type_id using the atomic number
    # Use sed to remove spaces from the output
    TYPE_ID=$(echo $($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the name using the atomic number
    # Use sed to remove spaces from the output
    NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the symbol using the atomic number
    # Use sed to remove spaces from the output
    SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the atomic mass using the atomic number
    # Use sed to remove spaces from the output
    ATOMIC_MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the melting point in Celsius using the atomic number
    # Use sed to remove spaces from the output
    MELTING_POINT_CELSIUS=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the boiling point in Celsius using the atomic number
    # Use sed to remove spaces from the output
    BOILING_POINT_CELSIUS=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')
    # Query the database to get the type using the atomic number
    # Use sed to remove spaces from the output
    TYPE=$(echo $($PSQL "SELECT type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER;") | sed 's/ //g')

    # Print the details of the element
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}
# Function to fix the database schema and data
FIX_DB() {
  # Rename the weight column to atomic_mass in the properties table
  RENAME_PROPERTIES_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
  echo "RENAME_PROPERTIES_WEIGHT                    : $RENAME_PROPERTIES_WEIGHT"

  # Rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius in the properties table
  RENAME_PROPERTIES_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
  RENAME_PROPERTIES_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
  echo "RENAME_PROPERTIES_MELTING_POINT             : $RENAME_PROPERTIES_MELTING_POINT"
  echo "RENAME_PROPERTIES_BOILING_POINT             : $RENAME_PROPERTIES_BOILING_POINT"

  # Set the melting_point_celsius and boiling_point_celsius columns to NOT NULL in the properties table
  ALTER_PROPERTIES_MELTING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
  ALTER_PROPERTIES_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
  echo "ALTER_PROPERTIES_MELTING_POINT_NOT_NULL     : $ALTER_PROPERTIES_MELTING_POINT_NOT_NULL"
  echo "ALTER_PROPERTIES_BOILING_POINT_NOT_NULL     : $ALTER_PROPERTIES_BOILING_POINT_NOT_NULL"

  # Add UNIQUE constraints to the symbol and name columns in the elements table
  ALTER_ELEMENTS_SYMBOL_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
  ALTER_ELEMENTS_NAME_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
  echo "ALTER_ELEMENTS_SYMBOL_UNIQUE                : $ALTER_ELEMENTS_SYMBOL_UNIQUE"
  echo "ALTER_ELEMENTS_NAME_UNIQUE                  : $ALTER_ELEMENTS_NAME_UNIQUE"

  # Set the symbol and name columns to NOT NULL in the elements table
  ALTER_ELEMENTS_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
  ALTER_ELEMENTS_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
  echo "ALTER_ELEMENTS_SYMBOL_NOT_NULL              : $ALTER_ELEMENTS_SYMBOL_NOT_NULL"
  echo "ALTER_ELEMENTS_SYMBOL_NOT_NULL              : $ALTER_ELEMENTS_SYMBOL_NOT_NULL"

  # Add a foreign key constraint to the atomic_number column in the properties table referencing the atomic_number column in the elements table
  ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
  echo "ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY  : $ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY"

  # Create the types table
  CREATE_TBL_TYPES=$($PSQL "CREATE TABLE types();")
  echo "CREATE_TBL_TYPES                            : $CREATE_TBL_TYPES"

  # Add the type_id column as a SERIAL PRIMARY KEY to the types table
  ADD_COLUMN_TYPES_TYPE_ID=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;")
  echo "ADD_COLUMN_TYPES_TYPE_ID                    : $ADD_COLUMN_TYPES_TYPE_ID"

  # Add the type column as a VARCHAR(20) NOT NULL to the types table
  ADD_COLUMN_TYPES_TYPE=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;")
  echo "ADD_COLUMN_TYPES_TYPE                       : $ADD_COLUMN_TYPES_TYPE"

  # Insert distinct types from the properties table into the types table
  INSERT_COLUMN_TYPES_TYPE=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;")
  echo "INSERT_COLUMN_TYPES_TYPE                    : $INSERT_COLUMN_TYPES_TYPE"

  # Add the type_id column as an INT to the properties table and add a foreign key constraint referencing the type_id column in the types table
  ADD_COLUMN_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
  ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);")
  echo "ADD_COLUMN_PROPERTIES_TYPE_ID               : $ADD_COLUMN_PROPERTIES_TYPE_ID"
  echo "ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID          : $ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID"

  # Update the type_id column in the properties table based on the type column matching the type column in the types table and set the type_id column to NOT NULL
  UPDATE_PROPERTIES_TYPE_ID=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);")
  ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
  echo "UPDATE_PROPERTIES_TYPE_ID                   : $UPDATE_PROPERTIES_TYPE_ID"
  echo "ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL    : $ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL"

  # Capitalize the first letter of all symbol values in the elements table
  UPDATE_ELEMENTS_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol);")
  echo "UPDATE_ELEMENTS_SYMBOL                      : $UPDATE_ELEMENTS_SYMBOL"

  # Change the data type of the atomic_mass column to VARCHAR(9) in the properties table and remove trailing zeros by converting to FLOAT
  ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(9);")
  UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT);")
  echo "ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS        : $ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS"
  echo "UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS         : $UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS"

  # Insert the element Fluorine with atomic number 9 into the elements and properties tables
  INSERT_ELEMENT_F=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine');")
  INSERT_PROPERTIES_F=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(9,'nonmetal',-220,-188.1,3,'18.998');")
  echo "INSERT_ELEMENT_F                            : $INSERT_ELEMENT_F"
  echo "INSERT_PROPERTIES_F                         : $INSERT_PROPERTIES_F"

  # Insert the element Neon with atomic number 10 into the elements and properties tables
  INSERT_ELEMENT_NE=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon');")
  INSERT_PROPERTIES_NE=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(10,'nonmetal',-248.6,-246.1,3,'20.18');")
  echo "INSERT_ELEMENT_NE                           : $INSERT_ELEMENT_NE"
  echo "INSERT_PROPERTIES_NE                        : $INSERT_PROPERTIES_NE"

  # Delete the non-existent element with atomic number 1000 from the elements and properties tables
  DELETE_PROPERTIES_1000=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
  DELETE_ELEMENTS_1000=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
  echo "DELETE_PROPERTIES_1000                      : $DELETE_PROPERTIES_1000"
  echo "DELETE_ELEMENTS_1000                        : $DELETE_ELEMENTS_1000"
  
  # Drop the type column from the properties table
  DELETE_COLUMN_PROPERTIES_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
  echo "DELETE_COLUMN_PROPERTIES_TYPE               : $DELETE_COLUMN_PROPERTIES_TYPE"
}

# Function to start the program
START_PROGRAM() {
  # Check if the element with atomic number 1000 exists in the database
  CHECK=$($PSQL "SELECT COUNT(*) FROM elements WHERE atomic_number=1000;")
  # If the element exists, call the FIX_DB function and clear the screen
  if [[ $CHECK -gt 0 ]]
  then
    FIX_DB
    clear
  fi
  # Call the MAIN_PROGRAM function with the provided argument
  MAIN_PROGRAM $1
}

# Start the program with the provided argument
START_PROGRAM $1