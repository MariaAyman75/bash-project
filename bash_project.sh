#! /usr/bin/bash
#create folder for database
if [ -d database ]
  then
   cd database
  else
   mkdir database
   cd database
  fi
  # Function to create a database
create_database() {
  echo "Please enter database name: "
  read dbname
  if [[ ! "$dbname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
   then
    echo "Invalid database name! It must start with a letter or underscore and contain only alphanumeric characters and underscores."
  elif [ -d "$dbname" ]
   then
    echo "Database already exists!"
  else
    mkdir "$dbname"
    echo "Database created!"
  fi
}
# Function to list databases
list_databases() {
  echo "Databases:"
  ls 
}
# Function to connect to a database
connect_database() {
  echo "Enter database name: "
  read dbname
  if [[ ! "$dbname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
   then
    echo "Please enter a valid database name."
  elif [ -d "$dbname" ]
   then
    cd "$dbname"
    database_menu
  else
    echo "Database does not exist!"
  fi
}
# Function to drop a database
drop_database() {
  echo "Please enter database name: "
  read dbname
  if [[ ! "$dbname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
   then
    echo "Please enter a valid database name."
  elif [ -d "$dbname" ]
   then
    rm -r "$dbname"
    echo "Database $dbname dropped!"
  else
    echo "Database does not exist!"
  fi
}
# Function to create a table
create_table() {
  echo "Enter table name: "
  read tablename
  if [[ ! "$tablename" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
    echo "Invalid table name! It must start with a letter or underscore and contain only alphanumeric characters and underscores."
  elif [ -f "$tablename" ]; then
    echo "Table already exists!"
  else
    echo "Enter number of columns: "
    read colnum
    columnsname=()
    datatype=()
    for (( i=1; i<=colnum; i++ ))
    do
      echo "Enter column $i name: "
      read colname
      echo "Enter column $i data type int or string: "
      read coltype
      columnsname+=("$colname")
      datatype+=("$coltype")
    done
    IFS=':' 
    echo "${columnsname[*]}" >> "$tablename"
    echo "${datatype[*]}" >> "$tablename"
   
    echo "Table created!"
  fi
}
# Function to list tables
list_tables() {
  echo "Tables:"
  ls
}

