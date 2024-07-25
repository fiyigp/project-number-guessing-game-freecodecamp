#!/bin/bash

RANDOM_GUESS=$((1 + RANDOM % 1000))

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"