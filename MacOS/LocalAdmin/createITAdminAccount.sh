#!/usr/bin/env bash
#set -x

############################################################################################
##
## Script to create Local Admin Account for IT Use
##
############################################################################################
#Source: https://github.com/Eduserv/intune-scripts
# Creates an IT admin account and stores that in the kevault

secret="" #app secret
keyvaultname="" #keyvault name
appid="" #application registration for accessing the keyvault (see bios password for more)
tenantid="" #tenant id to connect using (see Biospassword for more)
adminaccountname="it" # This is the accountname of the new admin
adminaccountfullname="IT" # This is the full name of the new admin user
scriptname="Create IT Admin Account"
logandmetadir="/Library/Logs/Microsoft/IntuneScripts/createLocalAdminAccount"
log="$logandmetadir/createITAdminAccount.log"

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
echo "#########################################################################"
echo "# $(date) | Starting $scriptname"
echo "#########################################################################"
echo ""

#waitforSetupAssistant
#get AAD token for access to keyvault
token=$(curl -k -v -X POST -H 'Content-type: application/x-www-form-urlencoded' -d "client_id=${appid}&grant_type=client_credentials&scope=https://vault.azure.net/.default&client_secret=${secret}" "https://login.microsoftonline.com/${tenantid}/oauth2/v2.0/token" | awk -F '"' '{print $12}')

#generate random password
p=$(openssl rand -base64 10 | grep -o . | uniq | tr -d '\n')
#get serial
serial=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')
#generate data for keyvault
data="{\"value\":\"$p\"}"
#put password in keyvault
curl -X PUT -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://$keyvaultname.vault.azure.net/secrets/$serial?api-version=7.4" -d "$data"

echo ""

echo "Creating new IT admin account [$adminaccountname]"
echo "Adding $adminaccountname to hidden users list"
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add "$adminaccountname"
sudo sysadminctl -deleteUser "$adminaccountname" # Remove existing admin account if it exists
sudo sysadminctl -adminUser "$adminaccountname" -adminPassword "$p" -addUser "$adminaccountname" -fullName "$adminaccountfullname" -password "$p" -admin

echo "IT Admin Account Created"