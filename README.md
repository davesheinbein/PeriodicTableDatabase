# Periodic Table Database Project

This project consists of a PostgreSQL database for a periodic table, along with a shell script to query element data. The repository includes SQL database queries, scripts for database initialization and querying, and documentation for setup and usage.

This project is part of the [FreeCodeCamp Relational Database Certification](https://www.freecodecamp.org/learn/relational-database) and the [Periodic Table Database project](https://www.freecodecamp.org/learn/relational-database/build-a-periodic-table-database-project/build-a-periodic-table-database).

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

## Setup

To set up the project, ensure you have PostgreSQL and Git installed on your machine. Clone this repository to your local machine and navigate to the project directory.

```bash
git clone https://github.com/davesheinbein/PeriodicTableDatabase.git
cd PeriodicTableDatabase
```

## Connecting to the Database

To connect to the PostgreSQL database, use the following command in your terminal:

```bash
psql --username=freecodecamp --dbname=periodic_table
```

Then connect to the database:

```sql
\c periodic_table
```

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

## SQL Database Queries

To compact SQL database queries into a single file, run the following command:

```bash
pg_dump -cC --inserts -U freecodecamp periodic_table > periodic_table.sql
```

## Git Repository Preparation

Prepare your Git directory by creating a new folder, initializing the repository, and committing the initial state:

```bash
mkdir periodic_table
cd periodic_table
git init
git checkout -b main
git commit -m "Initial commit"
```

## Shell Script Preparation

Create the necessary shell script files and grant executable permissions:

```bash
touch element.sh
touch fix_database.sh
chmod +x element.sh
chmod +x fix_database.sh
git commit -m "refactor: create & give executable permissions on element.sh"
```

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

## Additional Testing

You can also perform testing on the program with the following command:

```bash
git commit -m "chore: testing the program"
```

## Commit History

This project maintains a clear commit history to track changes and updates made to the scripts and database structure.

- **Initial commit**: Set up the Git repository.
- **refactor**: Created shell scripts and granted executable permissions.
- **fix**: Updated the database structure.
- **chore**: Added main program functionality and testing.

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
|        Script      |
+--------------------+
           |
           v
+--------------------+
|     Testing        |
+--------------------+
           |
           v
+--------------------+
|   Commit Changes    |
+--------------------+
           |
           v
+--------------------+
|        End         |
+--------------------+
```

## Entity-Relationship Diagram (ERD)

```plaintext
+------------------+      +-------------------+
|     Elements     |      |     Properties    |
+------------------+      +-------------------+
| id (PK)          |<-----| id (PK)           |
| symbol           |      | element_id (FK)   |
| name             |      | atomic_weight      |
| atomic_number    |      | density           |
+------------------+      | melting_point      |
                          | boiling_point      |
                          +-------------------+

         +------------------+
         |      Types       |
         +------------------+
         | id (PK)          |
         | type_name        |
         | color            |
         +------------------+
```

## Acknowledgments

Special thanks to FreeCodeCamp for providing the resources and guidance for this project.
