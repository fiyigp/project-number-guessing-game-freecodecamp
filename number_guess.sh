#!/bin/bash

RANDOM_NUMBER=$((1 + RANDOM % 1000))

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo "Enter your username:"

read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")

if [[ -z $USER_ID ]]
  then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME');")
  
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME';")
  
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  else

  GAMES_USER=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(counter) FROM games WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_USER games, and your best game took $BEST_GAME guesses." | sed "s/      / /" | sed "s/    / /"
fi

echo "Guess the secret number between 1 and 1000: ($RANDOM_NUMBER)"

read NUMBER_GUESS

COUNTER=1

while [[ ! $NUMBER_GUESS =~ ^[0-9]+$ || $NUMBER_GUESS < $RANDOM_NUMBER || $NUMBER_GUESS > $RANDOM_NUMBER ]]
do
  if [[ $NUMBER_GUESS < $RANDOM_NUMBER && $NUMBER_GUESS =~ ^^[0-9]+$ ]]
  then
  echo "It's lower than that, guess again:"
  elif [[ $NUMBER_GUESS > $RANDOM_NUMBER && $NUMBER_GUESS =~ ^^[0-9]+$ ]]
  then
  echo "It's higher than that, guess again:"
  else 
  echo "That is not an integer, guess again:" 
  fi
  COUNTER=$((COUNTER+1))
  read NUMBER_GUESS
done

INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(counter, user_id) VALUES($COUNTER, $USER_ID)")

echo "You guessed it in $COUNTER tries. The secret number was $RANDOM_NUMBER. Nice job!"