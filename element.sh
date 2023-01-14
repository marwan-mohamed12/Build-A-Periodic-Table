#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then 
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    ATOMIC_NUMBER_RESULT=$($PSQL "select atomic_number from properties where atomic_number = $1")
    ELEMENT_NAME=$($PSQL "select name from elements where atomic_number = $ATOMIC_NUMBER")
    ELEMENT_SYMBOL=$($PSQL "select symbol from elements where atomic_number = '$ATOMIC_NUMBER'")
  else
    ELEMENT_SYMBOL=$(echo $1 | grep -i -o '^[A-Z]')
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$ELEMENT_SYMBOL'")
    ATOMIC_NUMBER_RESULT=$($PSQL "select atomic_number from elements where symbol = '$ELEMENT_SYMBOL'")
    ELEMENT_NAME=$($PSQL "select name from elements where symbol = '$ELEMENT_SYMBOL'")
 fi
  # If atomic_number doesn't exist in db
  if [[ -z $ATOMIC_NUMBER_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_TYPE_ID=$($PSQL "select type_id from properties where atomic_number = $ATOMIC_NUMBER")
    ELEMENT_TYPE=$($PSQL "select type from types where type_id = $ELEMENT_TYPE_ID")
    ELEMENT_MASS=$($PSQL "select atomic_mass from properties where atomic_number = $ATOMIC_NUMBER")
    ELEMENT_MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number = $ATOMIC_NUMBER")
    ELEMENT_BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number = $ATOMIC_NUMBER")
    echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^   *|   *$//g' ) is $(echo $ELEMENT_NAME | sed -r 's/^   *|   *$//g' ) ($(echo $ELEMENT_SYMBOL | sed -r 's/^   *|   *$//g' )). It's a $(echo $ELEMENT_TYPE | sed -r 's/^   *|   *$//g' ), with a mass of $(echo $ELEMENT_MASS | sed -r 's/^   *|   *$//g' ) amu. $(echo $ELEMENT_NAME | sed -r 's/^   *|   *$//g' ) has a melting point of $(echo $ELEMENT_MELTING_POINT | sed -r 's/^   *|   *$//g' ) celsius and a boiling point of $(echo $ELEMENT_BOILING_POINT | sed -r 's/^   *|   *$//g' ) celsius."
  fi
fi

# if [[ -z $1 ]]
# then
#   echo "Please provide an element as an argument."
#   exit
# fi

# #if argument is atomic number
# if [[ $1 =~ ^[1-9]+$ ]]
# then
#   element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
# else
# #if argument is string
#   element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
# fi

# #element not in db
# if [[ -z $element ]]
# then
#   echo "I could not find that element in the database."
#   exit
# fi

# echo $element | while IFS=" |" read an name symbol type mass mp bp 
# do
#   echo "The element with atomic number $an is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $mp celsius and a boiling point of $bp celsius."
# done
