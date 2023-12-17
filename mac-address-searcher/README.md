# MAC Address Searcher

This little script takes a file that contains a list of MAC addresses,
and will search all files in a directory for those MAC addresses.

If a MAC address is found, the searcher will simply continue with the next
one in the list. If none of the files in the specified directory contain the MAC address,
it will be flagged and printed out on the console.

The purpose here is to use the DHCP configuration file, and obtain all allowed MAC addresses,
and then scour the logs to see if they actually reach the DHCP server for an IP address.
If the logs do not contain the entry, something in the Network/System is preventing them from reaching the
DHCP server.
