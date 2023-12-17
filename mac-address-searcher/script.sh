#!/usr/bin/env bash

# The script assumes that the list with mac-addresses is in a file called "mac-addresses.txt" in the same directory
# as the script and that the log files are located somewhere on the server.
# We most likely will not have permission to the log directory to write, so we will write all output to a file in
# the user's home directory called "mac-searcher-results.txt".
# Ask where the log files are located.
echo "Please enter the full path to the directory where the log files are located:"
read -r log_directory
files_to_search=$(find "${log_directory}" -regextype posix-extended -regex '.*(\b[1-9]\b|\b[12][0-9]\b|30)')

# First step is reading the contents of the file "mac-addresses.txt" and storing it in an array.
# An array allows us to just hold the data as a single collection so we can loop through it afterwards.
# We also need to remove windows special characters
readarray -t lines < mac-addresses.txt

# Provide some feedback to the caller about how many mac addresses we are going to search for.
echo "Loaded ${#lines[@]} mac addresses to search for."

# Loop through each mac address in the array, and search for the entry in the files located in the directory.
for key in "${!lines[@]}"
do
  echo "Processing ${key} of ${#lines[@]}"

  # Remove special characters from Windows such as the carriage return.
  # Otherwise the search will fail as the input gets messed up.
  mac_address=${lines[$key]}
  cleaned_entry=${mac_address//$'\r'}
  entry_found=false

  # Loop through each file we have selected from the provided directory.
  for file in $files_to_search
  do
    # Use grep to search for our clean mac-address, and return on the first match.
    # Match returns 1, otherwise we will get 0
    search_result=$(grep -m1 -i -c "$cleaned_entry" "$file")

    # If we found a match, break the loop and set our flag so we don't print out the mac-address.
    # otherwise, proceed with the loop to the next file.
    if [ "${search_result}" -gt 0 ];
    then
      entry_found=true
      break
    else
      true
    fi
  done

  # If we looped over all entries (or aborted the inner loop cause we found a hit),
  # we need to check if managed to find the entry and print it out or not.
  if [ "${entry_found}" = false ];
  then
    echo "${cleaned_entry}" >> "output.txt"
  fi
done
