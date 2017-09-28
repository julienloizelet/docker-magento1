#!/bin/bash

function setApacheVhost(){
    substitute-env-vars.sh /etc /etc/magento1.conf.tmpl;
    cp -v /etc/magento1.conf /etc/apache2/sites-enabled/magento1.conf;
}

function runApache(){
if /etc/init.d/apache2 status > /dev/null;
then
echo "Apache already running";
else
echo "Apache is not already running";
exec /usr/sbin/apache2ctl -D FOREGROUND;
fi
}

setApacheVhost
runApache



