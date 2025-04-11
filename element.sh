#!/bin/bash

if [[ -z $1 ]]
then 
  echo Please provide an element as an argument. 
  exit
fi

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 =~ ^[0-9]+$ ]]
then
  CONDITION="atomic_number=$1"
elif [[ $1 =~ ^[A-Z][a-z]?$ ]]; then
  CONDITION="symbol='$1'"
else
  CONDITION="name='$1'"
fi


RESULT=$($PSQL "SELECT * FROM elements WHERE $CONDITION;")

IFS="|" read -r ID SYMBOL NAME <<< "$RESULT"

if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit
fi

RESULT=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ID;")
IFS="|" read -r ID MASS MELT BOIL TYPE_ID <<< "$RESULT"

TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")

echo "The element with atomic number $ID is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."