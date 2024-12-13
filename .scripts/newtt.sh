#! /bin/bash

# Prompt for the ticket number
read -p "Enter the ticket number (example: TCTM-0000): " input_ticket

if [ -z "$input_ticket" ]; then
  echo "Ticket number is required, example: TCTM-0000"
  exit 1
fi

# Sanitize and uppercase the ticket number
ticket=$(echo "$input_ticket" | tr '[:lower:]' '[:upper:]')

# Prompt for a description and save it to a variable
read -p "Enter a short description (example: adds new feature): " input_description

if [ -z "$input_description" ]; then
  echo "Description is required, example: adds new feature"
  exit 1
fi

if [[ "$input_description" == *"fix"* ]]; then
  branch_prefix="fix"
elif [[ "$input_description" == *"hotfix"* ]]; then
  branch_prefix="hotfix"
else
  branch_prefix="feat"
fi

description=$(echo "$input_description" | tr ' ' '-')

cd ../reveal-types
git stash
git checkout master
git fetch
git pull

# Create a new branch with the ticket number and the description
git checkout -b $branch_prefix/$ticket/$description

cd ../reveal-utilities
git stash
git checkout master
git fetch
git pull

# Create a new branch with the ticket number and the description
git checkout -b $branch_prefix/$ticket/$description

cd ../backend
git stash
git checkout develop
git fetch
git pull

# Create a new branch with the ticket number and the description
git checkout -b $branch_prefix/$ticket/$description
