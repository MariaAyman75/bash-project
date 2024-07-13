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
