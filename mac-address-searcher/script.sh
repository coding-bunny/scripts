#!/usr/bin/env bash

# The script assumes that the list with mac-addresses is in a file called "mac-addresses.txt" in the same directory
# as the script and that the log files are located somewhere on the server.
# We most likely will not have permission to the log directory to write, so we will write all output to a file in
# the user's home directory called "mac-searcher-results.txt".
# Ask where the log files are located.
echo "Please enter the full path to the directory where the log files are located:"
read -r log_directory

# First step is reading the contents of the file "mac-addresses.txt" and storing it in an array.
# An array allows us to just hold the data as a single collection so we can loop through it afterwards.
# We also need to remove windows special characters
readarray -t lines < mac-addresses.txt

# Provide some feedback to the caller about how many mac addresses we are going to search for.
echo "Loaded ${#lines[@]} mac addresses to search for."

# Loop through each mac address in the array, and search for the entry in the files located in the directory.
for mac_address in "${lines[@]}"
do
  # Remove special characters from Windows such as the carriage return.
  # Otherwise the search will fail as the input gets messed up.
  cleaned_entry=${mac_address//$'\r'}

  # Search for the mac address in the log files using find to select all the files we want
  # and then grep to search for the mac address in those files.
  search_result=$(find "$log_directory" -name 'dhcpd.log.[1-30]' -exec grep "$cleaned_entry" {} + | wc -l)

  # If the search result is greater than 0, then we found the mac address in the log files.
  # If not, then we echo the mac address to the user.
  if [ "$search_result" -gt 0 ];
  then
    true
  else
    echo "$cleaned_entry"
  fi
done
