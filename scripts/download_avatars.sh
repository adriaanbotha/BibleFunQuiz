#!/bin/bash

# Create avatars directory if it doesn't exist
mkdir -p assets/images/avatars

# Biblical characters
avatars=("noah" "moses" "david" "daniel" "esther" "ruth" "abraham" "joshua" "solomon" "samson" "deborah" "miriam")

# Download placeholder avatars
for avatar in "${avatars[@]}"
do
  echo "Downloading placeholder for $avatar"
  # Using DiceBear Avatars API to generate biblical-themed avatars
  # The 'bottts' style gives a good placeholder until real biblical images are added
  curl -o "assets/images/avatars/$avatar.png" "https://avatars.dicebear.com/api/bottts/$avatar.png?size=200&background=%23ffffff"
done

echo "All avatars downloaded!" 