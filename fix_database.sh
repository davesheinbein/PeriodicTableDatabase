#!/bin/bash

# Connect to PostgreSQL and set the PSQL variable for easier querying
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Rename the 'weight' column to 'atomic_mass' in the properties table
$PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;"
echo "Renamed 'weight' column to 'atomic_mass'."

# Rename the melting_point and boiling_point columns for clarity
$PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;"
$PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;"
echo "Renamed 'melting_point' to 'melting_point_celsius' and 'boiling_point' to 'boiling_point_celsius'."

# Ensure melting_point_celsius and boiling_point_celsius do not accept null values
$PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;"
$PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;"
echo "Set 'melting_point_celsius' and 'boiling_point_celsius' to NOT NULL."

# Ensure atomic_number in properties is NOT NULL
$PSQL "ALTER TABLE properties ALTER COLUMN atomic_number SET NOT NULL;"
echo "Set 'atomic_number' in properties to NOT NULL."

# Set atomic_number in properties as a foreign key referencing elements
$PSQL "ALTER TABLE properties ADD CONSTRAINT fk_atomic_number FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);"
echo "Set 'atomic_number' in properties as a foreign key referencing 'atomic_number' in elements."

# Add UNIQUE constraint to symbol and name columns in the elements table
$PSQL "ALTER TABLE elements ADD CONSTRAINT unique_symbol UNIQUE (symbol);"
$PSQL "ALTER TABLE elements ADD CONSTRAINT unique_name UNIQUE (name);"
echo "Added UNIQUE constraints to 'symbol' and 'name' columns in elements."

# Ensure symbol and name columns are NOT NULL
$PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;"
$PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;"
echo "Set 'symbol' and 'name' columns to NOT NULL."

# Create a new 'types' table to categorize elements
$PSQL "CREATE TABLE types (type_id SERIAL PRIMARY KEY, type VARCHAR(20) NOT NULL);"
echo "Created 'types' table with 'type_id' as primary key and 'type' as NOT NULL."

# Insert unique types into the types table from existing properties
$PSQL "INSERT INTO types(type) SELECT DISTINCT type FROM properties;"
echo "Inserted unique types into the 'types' table."

# Add type_id column to properties table with NOT NULL constraint
$PSQL "ALTER TABLE properties ADD COLUMN type_id INT NOT NULL;"
echo "Added 'type_id' column to properties table with NOT NULL constraint."

# Set type_id as a foreign key referencing types table
$PSQL "ALTER TABLE properties ADD CONSTRAINT fk_type FOREIGN KEY (type_id) REFERENCES types(type_id);"
echo "Set 'type_id' in properties as a foreign key referencing 'type_id' in types."

# Update properties with correct type_id values from the types table
$PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);"
echo "Updated properties with correct 'type_id' values from types."

# Capitalize the first letter of all symbol values in the elements table
$PSQL "UPDATE elements SET symbol = INITCAP(symbol);"
echo "Capitalized the first letter of all 'symbol' values in elements."

# Remove trailing zeros from atomic_mass by casting to DECIMAL
$PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL(10, 6);"
$PSQL "UPDATE properties SET atomic_mass = TRIM(TRAILING '0' FROM atomic_mass::TEXT)::DECIMAL;"
echo "Removed trailing zeros from 'atomic_mass' values."

# Add Fluorine and Neon to the database
$PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine');"
$PSQL "INSERT INTO properties(atomic_number, type_id, melting_point_celsius, boiling_point_celsius, atomic_mass) VALUES(9, (SELECT type_id FROM types WHERE type = 'nonmetal'), -220, -188.1, 18.998);"
echo "Added Fluorine (atomic number 9) to the database."

$PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon');"
$PSQL "INSERT INTO properties(atomic_number, type_id, melting_point_celsius, boiling_point_celsius, atomic_mass) VALUES(10, (SELECT type_id FROM types WHERE type = 'nonmetal'), -248.6, -246.1, 20.18);"
echo "Added Neon (atomic number 10) to the database."

# Delete non-existent element with atomic_number 1000
$PSQL "DELETE FROM properties WHERE atomic_number = 1000;"
$PSQL "DELETE FROM elements WHERE atomic_number = 1000;"
echo "Deleted non-existent element with atomic_number 1000."

# Drop the type column from properties table after populating type_id
$PSQL "ALTER TABLE properties DROP COLUMN type;"
echo "Dropped 'type' column from properties table."

# Print success message
echo "Database has been updated successfully!"

#