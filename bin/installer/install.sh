#!/bin/bash

set -e


#####################################
# Print URLs and Logon Information
# Arguments:
#   None
# Returns:
#   None
#####################################
function printLogonInformation() {
	baseUrl="http://$DOMAIN"
	frontendUrl="$baseUrl/"

	echo ""
	echo "phpMyAdmin: $baseUrl:8081"
	echo " - Username: ${MYSQL_USER}"
	echo " - Password: ${MYSQL_PASSWORD}"
	echo ""
	echo "Mail dev: $baseUrl:8282"
	echo ""
	echo "Frontend: $frontendUrl"
}

#####################################
# Fix the filesystem permissions for the magento root.
# Arguments:
#   None
# Returns:
#   None
#####################################
function fixFilesystemPermissions() {
	chmod -R go+rw $MAGENTO_ROOT
}

#####################################
# A never-ending while loop (which keeps the installer container alive)
# Arguments:
#   None
# Returns:
#   None
#####################################
function runForever() {
	while :
	do
		sleep 1
	done
}

# Fix the www-folder permissions
chgrp -R 33 /var/www/html
chgrp -R 33 /bin

# Check if the MAGENTO_ROOT direcotry has been specified
if [ -z "$MAGENTO_ROOT" ]
then
	echo "Please specify the root directory of Magento via the environment variable: MAGENTO_ROOT"
	exit 1
fi

# Check if the specified MAGENTO_ROOT direcotry exists
if [ ! -d "$MAGENTO_ROOT" ]
then
	mkdir -p $MAGENTO_ROOT
fi


chgrp -R 33 $MAGENTO_ROOT


echo "Fixing filesystem permissions"
fixFilesystemPermissions

echo "Installation fininished"
printLogonInformation

runForever
exit 0
