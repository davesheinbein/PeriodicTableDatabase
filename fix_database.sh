RENAME_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
echo "Renamed weight to atomic_mass: $RENAME_WEIGHT"

RENAME_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
RENAME_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
echo "Renamed melting_point to melting_point_celsius: $RENAME_MELTING_POINT"
echo "Renamed boiling_point to boiling_point_celsius: $RENAME_BOILING_POINT"

SET_MELTING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
SET_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
echo "Set melting_point_celsius to NOT NULL: $SET_MELTING_POINT_NOT_NULL"
echo "Set boiling_point_celsius to NOT NULL: $SET_BOILING_POINT_NOT_NULL"

ADD_UNIQUE_SYMBOL=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
ADD_UNIQUE_NAME=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
echo "Added unique constraint to symbol: $ADD_UNIQUE_SYMBOL"
echo "Added unique constraint to name: $ADD_UNIQUE_NAME"

SET_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
SET_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
echo "Set symbol to NOT NULL: $SET_SYMBOL_NOT_NULL"
echo "Set name to NOT NULL: $SET_NAME_NOT_NULL"

ADD_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
echo "Added foreign key for atomic_number: $ADD_FOREIGN_KEY"

CREATE_TYPES_TABLE=$($PSQL "CREATE TABLE types();")
echo "Created types table: $CREATE_TYPES_TABLE"

ADD_TYPE_ID_COLUMN=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;")
echo "Added type_id column to types: $ADD_TYPE_ID_COLUMN"

ADD_TYPE_COLUMN=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;")
echo "Added type column to types: $ADD_TYPE_COLUMN"

INSERT_DISTINCT_TYPES=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;")
echo "Inserted distinct types into types table: $INSERT_DISTINCT_TYPES"

ADD_PROPERTY_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
ADD_PROPERTY_TYPE_ID_FK=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);")
echo "Added type_id column to properties: $ADD_PROPERTY_TYPE_ID"
echo "Added foreign key for type_id in properties: $ADD_PROPERTY_TYPE_ID_FK"

UPDATE_PROPERTY_TYPE_ID=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);")
SET_PROPERTY_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
echo "Updated type_id in properties: $UPDATE_PROPERTY_TYPE_ID"
echo "Set type_id to NOT NULL in properties: $SET_PROPERTY_TYPE_ID_NOT_NULL"

UPDATE_ELEMENT_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol);")
echo "Updated element symbols to capitalized: $UPDATE_ELEMENT_SYMBOL"

CHANGE_ATOMIC_MASS_TYPE=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(9);")
CAST_ATOMIC_MASS_TO_FLOAT=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT);")
echo "Changed atomic_mass column type to VARCHAR(9): $CHANGE_ATOMIC_MASS_TYPE"
echo "Converted atomic_mass to FLOAT: $CAST_ATOMIC_MASS_TO_FLOAT"

INSERT_FLUORINE=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(9,'F','Fluorine');")
INSERT_FLUORINE_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(9,'nonmetal',-220,-188.1,3,'18.998');")
echo "Inserted Fluorine into elements: $INSERT_FLUORINE"
echo "Inserted Fluorine properties : $INSERT_FLUORINE_PROPERTIES"

INSERT_NEON=$($PSQL "INSERT INTO elements(atomic_number,symbol,name) VALUES(10,'Ne','Neon');")
INSERT_NEON_PROPERTIES=$($PSQL "INSERT INTO properties(atomic_number,type,melting_point_celsius,boiling_point_celsius,type_id,atomic_mass) VALUES(10,'nonmetal',-248.6,-246.1,3,'20.18');")
echo "Inserted Neon into elements: $INSERT_NEON"
echo "Inserted Neon properties : $INSERT_NEON_PROPERTIES"

DELETE_PROPERTY_1000=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
DELETE_ELEMENT_1000=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
echo "Deleted property with atomic_number 1000: $DELETE_PROPERTY_1000"
echo "Deleted element with atomic_number 1000: $DELETE_ELEMENT_1000"

DROP_PROPERTY_TYPE_COLUMN=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
echo "Dropped type column from properties: $DROP_PROPERTY_TYPE_COLUMN"
