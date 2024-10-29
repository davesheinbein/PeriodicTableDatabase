# Rename the column 'weight' to 'atomic_mass' in the 'properties' table
RENAME_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
# Output the result of the rename operation
echo "Renamed weight to atomic_mass: $RENAME_WEIGHT"

# Rename the column 'melting_point' to 'melting_point_celsius' in the 'properties' table
RENAME_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
# Rename the column 'boiling_point' to 'boiling_point_celsius' in the 'properties' table
RENAME_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
# Output the result of the rename operation for 'melting_point'
echo "Renamed melting_point to melting_point_celsius: $RENAME_MELTING_POINT"
# Output the result of the rename operation for 'boiling_point'
echo "Renamed boiling_point to boiling_point_celsius: $RENAME_BOILING_POINT"

# Set the 'melting_point_celsius' column to NOT NULL in the 'properties' table
SET_MELTING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
# Set the 'boiling_point_celsius' column to NOT NULL in the 'properties' table
SET_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
# Output the result of setting 'melting_point_celsius' to NOT NULL
echo "Set melting_point_celsius to NOT NULL: $SET_MELTING_POINT_NOT_NULL"
# Output the result of setting 'boiling_point_celsius' to NOT NULL
echo "Set boiling_point_celsius to NOT NULL: $SET_BOILING_POINT_NOT_NULL"

# Add a unique constraint to the 'symbol' column in the 'elements' table
ADD_UNIQUE_SYMBOL=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
# Add a unique constraint to the 'name' column in the 'elements' table
ADD_UNIQUE_NAME=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
# Output the result of adding a unique constraint to 'symbol'
echo "Added unique constraint to symbol: $ADD_UNIQUE_SYMBOL"
# Output the result of adding a unique constraint to 'name'
echo "Added unique constraint to name: $ADD_UNIQUE_NAME"

# Set the 'symbol' column to NOT NULL in the 'elements' table
SET_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
# Set the 'name' column to NOT NULL in the 'elements' table
SET_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
# Output the result of setting 'symbol' to NOT NULL
echo "Set symbol to NOT NULL: $SET_SYMBOL_NOT_NULL"
# Output the result of setting 'name' to NOT NULL
echo "Set name to NOT NULL: $SET_NAME_NOT_NULL"

# Add a foreign key constraint to the 'atomic_number' column in the 'properties' table referencing 'atomic_number' in the 'elements' table
ADD_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
# Output the result of adding the foreign key constraint
echo "Added foreign key for atomic_number: $ADD_FOREIGN_KEY"

# Create a new table 'types'
CREATE_TYPES_TABLE=$($PSQL "CREATE TABLE types();")
# Output the result of creating the 'types' table
echo "Created types table: $CREATE_TYPES_TABLE"

# Add a 'type_id' column with SERIAL PRIMARY KEY to the 'types' table
ADD_TYPE_ID_COLUMN=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;")
# Output the result of adding the 'type_id' column
echo "Added type_id column to types: $ADD_TYPE_ID_COLUMN"

# Add a 'type' column with VARCHAR(20) NOT NULL to the 'types' table
ADD_TYPE_COLUMN=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;")
# Output the result of adding the 'type' column
echo "Added type column to types: $ADD_TYPE_COLUMN"

# Insert distinct 'type' values from the 'properties' table into the 'types' table
INSERT_DISTINCT_TYPES=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;")
# Output the result of inserting distinct types
echo "Inserted distinct types into types table: $INSERT_DISTINCT_TYPES"

# Add a 'type_id' column to the 'properties' table
ADD_PROPERTY_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
# Add a foreign key constraint to the 'type_id' column in the 'properties' table referencing 'type_id' in the 'types' table
ADD_PROPERTY_TYPE_ID_FK=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);")
# Output the result of adding the 'type_id' column
echo "Added type_id column to properties: $ADD_PROPERTY_TYPE_ID"
# Output the result of adding the foreign key constraint for 'type_id'
echo "Added foreign key for type_id in properties: $ADD_PROPERTY_TYPE_ID_FK"

# Update the 'type_id' column in the 'properties' table based on the 'type' column matching the 'type' column in the 'types' table
UPDATE_PROPERTY_TYPE_ID=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);")
# Set the 'type_id' column to NOT NULL in the 'properties' table
SET_PROPERTY_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
# Output the result of updating the 'type_id' column
echo "Updated type_id in properties: $UPDATE_PROPERTY_TYPE_ID"
# Output the result of setting 'type_id' to NOT NULL
echo "Set type_id to NOT NULL in properties: $SET_PROPERTY_TYPE_ID_NOT_NULL"

# Update the 'symbol' column in the 'elements' table to be capitalized
UPDATE_ELEMENT_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol);")
# Output the result of updating the 'symbol' column
echo "Updated element symbols to capitalized: $UPDATE_ELEMENT_SYMBOL"

# Change the data type of the 'atomic_mass' column to VARCHAR(9) in the 'properties' table
CHANGE_ATOMIC_MASS_TYPE=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(9);")
# Convert the 'atomic_mass' column values to FLOAT in the 'properties' table
CAST_ATOMIC_MASS_TO_FLOAT=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT);")
# Output the result of changing the data type of 'atomic_mass'
echo "Changed atomic_mass column type to VARCHAR(9): $CHANGE_ATOMIC_MASS_TYPE"
# Output the result of converting 'atomic_mass' to FLOAT
echo "Converted atomic_mass to FLOAT: $CAST_ATOMIC_MASS_TO_FLOAT"

# Insert a new element 'Fluorine' with atomic number 9 into the 'elements' table
INSERT_FLUORINE=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine');")
# Insert properties for 'Fluorine' into the 'properties' table
INSERT_FLUORINE_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(9,'nonmetal',-220,-188.1,3,'18.998');")
# Output the result of inserting 'Fluorine' into the 'elements' table
echo "Inserted Fluorine into elements: $INSERT_FLUORINE"
# Output the result of inserting 'Fluorine' properties into the 'properties' table
echo "Inserted Fluorine properties : $INSERT_FLUORINE_PROPERTIES"

# Insert a new element 'Neon' with atomic number 10 into the 'elements' table
INSERT_NEON=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon');")
# Insert properties for 'Neon' into the 'properties' table
INSERT_NEON_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(10,'nonmetal',-248.6,-246.1,3,'20.18');")
# Output the result of inserting 'Neon' into the 'elements' table
echo "Inserted Neon into elements: $INSERT_NEON"
# Output the result of inserting 'Neon' properties into the 'properties' table
echo "Inserted Neon properties : $INSERT_NEON_PROPERTIES"

# Delete the property with atomic number 1000 from the 'properties' table
DELETE_PROPERTY_1000=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
# Delete the element with atomic number 1000 from the 'elements' table
DELETE_ELEMENT_1000=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
# Output the result of deleting the property with atomic number 1000
echo "Deleted property with atomic_number 1000: $DELETE_PROPERTY_1000"
# Output the result of deleting the element with atomic number 1000
echo "Deleted element with atomic_number 1000: $DELETE_ELEMENT_1000"

# Drop the 'type' column from the 'properties' table
DROP_PROPERTY_TYPE_COLUMN=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
# Output the result of dropping the 'type' column
echo "Dropped type column from properties: $DROP_PROPERTY_TYPE_COLUMN"