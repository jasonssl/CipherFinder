#!/bin/bash
#
# A script to search for the cipher in openssl.
# Usage = ./cipher_finder.sh <file>
#
# Jason Lim (@JasonSSL)

# Variable
target="$1"
output="$2"
password="$3"

# Functions
usage() {
	echo " Usage : ./cipher_finder.sh <file> <out_file_name> <password>"
	echo " Example : ./cipher_finder.sh encryptedfile.csv.enc output.csv key123" 
	echo " "
	exit 1
	}

search() {
	ciphers=`openssl list-cipher-commands`
	for cipher in $ciphers; do
		openssl enc -d -$cipher -in $target -k $password > /dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			echo " [+] Cipher found: $cipher"
			echo " [+] Attempt to decrypt..."
			echo " [*] Exec: openssl enc -d -$cipher -in $target -out $output -k $password"
			openssl enc -d -$cipher -in $target -out $output -k $password
			exit
		fi
	done
	}

# Start script
if [ $# -eq 0 ] || [ -d $target ] || [ -z $password ];then
        usage
elif [ -f $target ];then
        search
else
        usage
fi
