# Periodic Table Database Project

This project consists of a PostgreSQL database for a periodic table, along with a shell script to query element data. The repository includes SQL database queries, scripts for database initialization and querying, and documentation for setup and usage.

This project is part of the [FreeCodeCamp Relational Database Certification](https://www.freecodecamp.org/learn/relational-database)
[Periodic Table Database project](https://www.freecodecamp.org/learn/relational-database/build-a-periodic-table-database-project/build-a-periodic-table-database).

---

## Table of Contents

1. [Setup](#setup)
2. [Connecting to the Database](#connecting-to-the-database)
3. [Printing the Tables](#printing-the-tables)
4. [SQL Database Queries](#sql-database-queries)
5. [Git Repository Preparation](#git-repository-preparation)
6. [Shell Script Preparation](#shell-script-preparation)
7. [Running Scripts](#running-scripts)
8. [Additional Testing](#additional-testing)
9. [Commit History](#commit-history)
10. [Flowchart](#flowchart)
11. [Entity-Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
12. [Acknowledgments](#acknowledgments)

---

## Setup

To set up the project, ensure you have PostgreSQL and Git installed on your machine. Clone this repository to your local machine and navigate to the project directory.

```bash
git clone https://github.com/davesheinbein/PeriodicTableDatabase.git

cd PeriodicTableDatabase
```

---

## Connecting to the Database

To connect to the PostgreSQL database, use the following command in your terminal:

```bash
psql --username=freecodecamp --dbname=periodic_table
```

Then connect to the database (it should already exist in this instance):

```sql
\c periodic_table
```

---

## Printing the Tables

Once connected to the database, you can print the list of tables using the following SQL command:

```sql
\dt
```

To see the contents of a specific table, use:

```sql
SELECT * FROM elements;
SELECT * FROM properties;
SELECT * FROM types;
```

---

## SQL Database Queries

To compact SQL database queries into a single file, run the following command:

```bash
pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql
```

---

## Git Repository Preparation

Prepare your Git directory by creating a new folder, initializing the repository, and committing the initial state:

```bash
mkdir periodic_table
cd periodic_table
git init
git checkout -b main
git commit -m "Initial commit"
```

---

## Shell Script Preparation

Create the necessary shell script files and grant executable permissions:

```bash
touch element.sh
touch fix_database.sh
chmod +x element.sh
chmod +x fix_database.sh
git commit -m "refactor: create & give executable permissions on element.sh"
```

---

## Running Scripts

Run the database fix script first to ensure that the database is properly set up:

```bash
./periodic_table/fix_database.sh
git commit -m "fix: periodic table"
```

Then, run the main element query script:

```bash
./periodic_table/element.sh
git commit -m "chore: create main program and printout the output"
```

---

## Additional Testing

You can also perform testing on the program with the following command:

```bash
git commit -m "chore: testing the program"
```

---

## Commit History

This project maintains a clear commit history to track changes and updates made to the scripts and database structure.

**Examples**

- **Initial commit**
  ```bash
  git commit -m "Initial commit: Set up the Git repository"
  ```
- **refactor**
  ```bash
  git commit -m "refactor: Created shell scripts"
  ```
- **fix**
  ```bash
  git commit -m "fix: Updated the database structure"
  ```
- **chore**
  ```bash
  git commit -m "chore: Added functionality and testing"
  ```

---

## Flowchart

```plaintext
+--------------------+
|       Start        |
+--------------------+
           |
           v
+--------------------+
|   Setup Project    |
+--------------------+
           |
           v
+--------------------+
| Connect to Database|
+--------------------+
           |
           v
+--------------------+
|   Print Tables     |
+--------------------+
           |
           v
+--------------------+
|   Run Fix Script   |
+--------------------+
           |
           v
+--------------------+
|Run Element Query   |
|      Script        |
+--------------------+
           |
           v
+--------------------+
|     Testing        |
+--------------------+
           |
           v
+--------------------+
|   Commit Changes   |
+--------------------+
           |
           v
+--------------------+
|        End         |
+--------------------+
```

---

## Entity-Relationship Diagram (ERD)

```plaintext
+------------------+      +-------------------+
|     Elements     |      |     Properties    |
+------------------+      +-------------------+
| id (PK)          |<-----| id (PK)           |
| symbol           |      | element_id (FK)   |
| name             |      | atomic_weight     |
| atomic_number    |      | density           |
+------------------+      | melting_point     |
                          | boiling_point     |
                          +-------------------+
                                ^
                                |
                                |
                          +-------------------+
                          |      Types        |
                          +-------------------+
                          | id (PK)           |
                          | type_name         |
                          | color             |
                          +-------------------+
```

**Primary Key (PK):**

**Definition:** A primary key is a unique identifier for a record in a table. It ensures that each record can be uniquely identified.
Purpose: The primary key enforces entity integrity by ensuring that each record in the table is unique and not null. It is used to establish and enforce relationships between tables.

**Usage in Tables:**

- **Elements Table:** The id column is the primary key. It uniquely identifies each element in the periodic table.
- **Properties Table:** The id column is the primary key. It uniquely identifies each set of properties associated with an element.
  Types Table: The id column is the primary key. It uniquely identifies each type of element (e.g., metal, non-metal).

**Foreign Key (FK):**

**Definition:** A foreign key is a field (or collection of fields) in one table that uniquely identifies a row of another table. It establishes a link between the data in the two tables.

**Purpose:** The foreign key enforces referential integrity by ensuring that the value in the foreign key column corresponds to a valid, existing value in the referenced primary key column. It is used to maintain the logical relationships between tables.

**Usage in Tables:**

- **Properties Table:** The element_id column is a foreign key that references the id column in the Elements table. This relationship ensures that each set of properties is associated with a valid element in the Elements table.

**Benefits of Using Primary and Foreign Keys:**

- **Data Integrity:** Ensures that the data is accurate and consistent across the database.
- **Uniqueness:** Guarantees that each record can be uniquely identified.
  Relationships: Establishes and maintains logical relationships between tables, enabling complex queries and data retrieval.
- **Referential Integrity:** Prevents orphaned records and maintains the consistency of relationships between tables.
- **Indexing:** Primary keys are automatically indexed, which improves the performance of queries involving the primary key.

---

## Script Descriptions

In the Periodic Table Database Project, the `element.sh` and `fix_database.sh` scripts serve distinct but complementary purposes:

**`element.sh`:**

- **Purpose:** This script is the main query tool for the database, designed to retrieve information about elements from the periodic table database. When executed, it typically prompts the user to input an element (by symbol, atomic number, or name) and then outputs relevant information (e.g., atomic weight, type, properties) based on the user’s query.
- **Functionality:** It uses SQL commands within a shell environment to query the database and retrieve specific data from tables like elements, properties, and types, displaying details about each element in a structured format.

**`fix_database.sh`:**

- **Purpose:** This script is intended to perform any initial setup or modifications needed to ensure the database structure and data align with expected standards or project requirements. It prepares the database by creating or updating tables, inserting missing records, and fixing data inconsistencies, which makes sure that `element.sh` can access and query the data without issues.
- **Functionality:** It often includes SQL statements to adjust the schema, fix table relationships, and populate missing data entries. Running this script before `element.sh` is essential, as it establishes a reliable and consistent database state.

---

## Acknowledgments

Special thanks to FreeCodeCamp for providing the resources and guidance for this project.
