#!/usr/bin/env bash
#set -x

############################################################################################
##
## Script to downgrade all users to Standard Users
##
############################################################################################
##
## Created by Jisc (Nick Brown)
##
## Notes
## 
## Modified from https://github.com/microsoft/shell-intune-samples/blob/master/macOS/Config/Manage%20Accounts/downgradeUsertoStandard.sh
##
## This script can set all existing Admin accounts to be standard user accounts. The account specified in adminaccountname will not be downgraded if it is found
##
## WARNING: This script could leave your Mac will no Admin accounts configured at all
#Source: https://github.com/Eduserv/intune-scripts

# Define variables

scriptname="Downgrade Admin Users to Standard"
abmcheck=true   # Only downgrade users if this device is ABM managed
downgrade=true  # If set to false, script will not do anything
itadminaccount="it" #set to match user account in ./createITAdminAccount.sh
localadmin="localadmin" #set to match user account in ./createLocalAdminAccount.sh
logandmetadir="/Library/Logs/Microsoft/IntuneScripts/downgradeAdminUsers"
log="$logandmetadir/downgradeAdminUsers.log"

## Check if the log directory has been created and start logging
if [ -d $logandmetadir ]; then
    ## Already created
    echo "# $(date) | Log directory already exists - $logandmetadir"
else
    ## Creating Metadirectory
    echo "# $(date) | creating log directory - $logandmetadir"
    mkdir -p $logandmetadir
fi

# start logging

exec 1>> $log 2>&1

# Begin Script Body

echo ""
echo "##############################################################"
echo "# $(date) | Starting $scriptname"
echo "############################################################"
echo ""

# Is this a ABM DEP device?
if [ "$abmcheck" = true ]; then
  downgrade=false
  echo "Checking MDM Profile Type"
  profiles status -type enrollment | grep "Enrolled via DEP: Yes"
  if [ ! $? == 0 ]; then
    echo "This device is not ABM managed"
    exit 0;
  else
    echo "Device is ABM Managed"
    downgrade=true
  fi
fi

if [ $downgrade = true ]; then
  while read useraccount; do
    if [[ "$useraccount" == "$itadminaccount" || "$useraccount" == "$localadmin" || "$useraccount" == lda* || "$useraccount" == ca* ]]; then
        echo "Leaving $useraccount account as Admin"
    else
        echo "Making $useraccount a normal user"
        /usr/sbin/dseditgroup -o edit -d "$useraccount" -t user admin
    fi
  done < <(dscl . list /Users UniqueID | awk '$2 >= 501 {print $1}')
fi

echo "Finished running"