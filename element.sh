#!/bin/bash

# Define the PostgreSQL command for easier querying
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument (atomic number, symbol, or name) is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Query the database using atomic number, symbol, or name
RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, types.type_id, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
                FROM elements 
                INNER JOIN properties ON elements.atomic_number = properties.atomic_number 
                INNER JOIN types ON properties.type_id = types.type_id 
                WHERE elements.atomic_number = '$1' OR symbol ILIKE '$1' OR name ILIKE '$1';")

# Output the result or a not found message
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse the result to create a table format
  IFS="|" read -r atomic_number name symbol type_id type atomic_mass melting_point boiling_point <<< "$RESULT"
  
  echo -e "Element Information:\n"
  echo -e "-----------------------------------------"
  echo -e "| Atomic Number | $atomic_number"
  echo -e "| Name          | $name"
  echo -e "| Symbol        | $symbol"
  echo -e "| Type ID       | $type_id"
  echo -e "| Type          | $type"
  echo -e "| Atomic Mass   | $atomic_mass"
  echo -e "| Melting Point | $melting_point °C"
  echo -e "| Boiling Point | $boiling_point °C"
  echo -e "-----------------------------------------"
fi

# Print the entire elements table
psql --username=freecodecamp --dbname=periodic_table -c "SELECT * FROM elements;"

# Print the entire properties table
psql --username=freecodecamp --dbname=periodic_table -c "SELECT * FROM properties;"

#