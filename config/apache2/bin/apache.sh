#!/bin/bash

set -e

function setApacheVhost(){
    substitute-env-vars.sh /etc /etc/magento1.conf.tmpl;
    cp -v /etc/magento1.conf /etc/apache2/sites-enabled/magento1.conf;
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

setApacheVhost
runForever
exit 0


