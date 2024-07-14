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
# Function to drop a table
drop_table() {
  echo "Enter table name: "
  read tablename
  if [[ ! "$dbname" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]
   then
    echo "Please enter a valid database name."
  elif [ -f "$tablename" ]
   then
    rm "$tablename"
    echo "Table dropped!"
  else
    echo "Table does not exist!"
  fi
}
# Function to insert into a table
insert_into_table() {
  echo "Enter table name: "
  read tablename
  if [ -f "$tablename" ]; then
    read -r name < "$tablename"
    IFS=':' read -r -a col_names <<< "$name"
    datatype=$(sed -n '2p' "$tablename")
    IFS=':' read -r -a col_datatype <<< "$datatype"
  
    rowdata=()
    for (( i=0; i<${#col_names[@]}; i++ )); do
      while true; do
        echo "Enter value for ${col_names[$i]} (type: ${col_datatype[$i]}):"
        read value

        # Check if value matches the expected data type
        if [[ "${col_datatype[$i]}" == "int" ]]; then
          if [[ ! "$value" =~ ^[0-9]+$ ]]; then
            echo "Invalid value! Please enter an integer."
            continue
          fi
        elif [[ "${col_datatype[$i]}" == "string" ]]; then
          if [[ ! "$value" =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo "Invalid value! Please enter a string."
            continue
          fi
        fi

        # For the first column, check if the value is unique
        if [[ $i -eq 0 ]]; then
          if grep -q "^$value:" "$tablename"; then
            echo "Value for the first column must be unique. Please enter a different value."
            continue
          fi
        fi

        rowdata+=("$value")
        break
      done
    done

    IFS=':' 
    echo "${rowdata[*]}" >> "$tablename"
    echo "Row inserted!"
  else
    echo "Table does not exist!"
  fi
}
# Function to select from a table
select_from_table() {
  echo "Enter table name: "
  read tablename
  if [ ! -f "$tablename" ]
   then
   echo "Table does not exist!"
   fi
      select option in all selection projection exit
      do 
      case $option in
"all")	
	sed -n '3,$p' "$tablename"
	;;
"selection")
	selection
	;;
"projection")
	projection
	;;
"exit")
break
;;

*)
	echo UNKNOWN
	break
	;;

esac
done
  
}

selection(){
    # Read the first line to get column names
read -r name < "$tablename"
IFS=':' read -r -a col_names <<< "$name"

# Prompt the user to select a column
echo "Select a column:"
select column in "${col_names[@]}"; do
  if [[ -n "$column" ]]; then
    # Get the column index
    col_index=0
    for i in "${!col_names[@]}"; do
      if [[ "${col_names[$i]}" == "$column" ]]; then
        col_index=$((i + 1))
        break
      fi
    done

    # Prompt the user to enter a value to search for
    echo "Please enter value: "
    read value

    # Search for the value in the selected column
    result=$(awk -F':' -v col="$col_index" -v val="$value" '$col ~ val {print}' "$tablename")

    if [[ -n "$result" ]]; then
      echo "$result"
    else
      echo "No matching rows"
    fi
    break
  else
    echo "Invalid selection. Please try again."
  fi
done
  }

projection(){
     # Read the first line to get column names
read -r name < "$tablename"
IFS=':' read -r -a col_names <<< "$name"

# Prompt the user to select a column
echo "Select a column:"
select column in "${col_names[@]}"; do
  if [[ -n "$column" ]]; then
    # Get the column index
    col_index=0
    for i in "${!col_names[@]}"; do
      if [[ "${col_names[$i]}" == "$column" ]]; then
        col_index=$((i + 1))
        break
      fi
    done

    
    # Search for the value in the selected column
    result=$(cut -d : -f "$col_index" "$tablename")

    if [[ -n "$result" ]]; then
      echo "$result"
    else
      echo "No matching rows"
    fi
    break
  else
    echo "Invalid selection. Please try again."
  fi
done
}
# Function to delete from a table
delete_from_table() {
  echo "Enter table name: "
  read tablename
  if [ -f "$tablename" ]; then
    echo "Select delete option: 1) Delete by ID, 2) Delete by column value, 3) Delete all rows"
    read delete_option
    
    case $delete_option in
      1)
        echo "Enter ID value: "
        read id_value
        sed -i "/^$id_value:/d" "$tablename"
        echo "Row with ID $id_value deleted!"
        ;;
      2)
        # Read the first line to get column names
        read -r name < "$tablename"
        IFS=':' read -r -a col_names <<< "$name"
        
        echo "Select column to delete by:"
        select column in "${col_names[@]}"; do
          if [[ -n "$column" ]]; then
            echo "Enter value to delete: "
            read value
            col_index=0
            for i in "${!col_names[@]}"; do
              if [[ "${col_names[$i]}" == "$column" ]]; then
                col_index=$((i + 1))
                break
              fi
            done
            
            awk -F':' -v col="$col_index" -v val="$value" '$col != val' "$tablename" > temp && mv temp "$tablename"
            echo "Rows where $column = $value deleted!"
            break
          else
            echo "Invalid selection. Please try again."
          fi
        done
        ;;
      3)
        sed -i '3,$d' "$tablename"
        echo "All rows deleted!"
        ;;
      *)
        echo "Invalid option!"
        ;;
    esac
  else
    echo "Table does not exist!"
  fi
}

