#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
re='^[0-9]+$'

if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
  # capitalise the input
  ELEMENT_INPUT="${1^}"
  # check if input is a number or a string
  if [[ $1 =~ $re ]]
  then
   ELEMENT_CHOSEN=$($PSQL "SELECT properties.atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, name, symbol FROM properties INNER JOIN elements on properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number=$1")
  else
    ELEMENT_CHOSEN=$($PSQL "SELECT properties.atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type, name, symbol FROM properties INNER JOIN elements on properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE symbol='$ELEMENT_INPUT' OR name='$ELEMENT_INPUT'")
  fi
  # if not in database
  if [[ -z $ELEMENT_CHOSEN ]]
  then
    echo "I could not find that element in the database."
  else
    # parse the SQL output
    echo "$ELEMENT_CHOSEN" | sed -E -r 's/\|/ /g' | while read ATOMIC_NUMBER ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE NAME SYMBOL
    do
      # display the required sentence
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi 



