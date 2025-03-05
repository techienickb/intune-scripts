#!/usr/bin/env bash
#set -x

############################################################################################
##
## Script to create Local Admin Account
##
###########################################################################################
#Source: https://github.com/techienickb/intune-scripts
#Modified from: https://github.com/microsoft/shell-intune-samples/blob/master/macOS/Config/Manage%20Accounts/createLocalAdminAccount.sh

# Creates an emergecy local admin account and stores that in keyvault

secret="" #app secret
keyvaultname="" #keyvault name
appid="" #application registration for accessing the keyvault (see bios password for more)
tenantid="" #tenant id to connect using (see Biospassword for more)
adminaccountname="localadmin" # This is the accountname of the new admin
adminaccountfullname="Local admin" # This is the full name of the new admin user
scriptname="Create Local Admin Account"
logandmetadir="/Library/Logs/Microsoft/IntuneScripts/createLocalAdminAccount"
log="$logandmetadir/createLocalAdminAccount.log"

# function to delay until the user has finished setup assistant.
waitforSetupAssistant () {
  until [[ -f /var/db/.AppleSetupDone ]]; do
    delay=$(( $RANDOM % 50 + 10 ))
    echo "$(date) |  + Setup Assistant not done, waiting [$delay] seconds"
    sleep $delay
  done
  echo "$(date) | Setup Assistant is done, lets carry on"
}

## Check if the log directory has been created and start logging
if [ -d $logandmetadir ]; then
    ## Already created
    echo "# $(date) | Log directory already exists - $logandmetadir"
else
    ## Creating Metadirectory
    echo "# $(date) | creating log directory - $logandmetadir"
    mkdir -p $logandmetadir
fi

# wipe log & start logging
> $log
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
curl -X PUT -H "Authorization: Bearer $token" -H "Content-Type: application/json" "https://$keyvaultname.vault.azure.net/secrets/$adminaccountname-$serial?api-version=7.4" -d "$data" &> /dev/null 2>&1

echo ""

echo "Creating new Local admin account [$adminaccountname]"
echo "Adding $adminaccountname to hidden users list"
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add "$adminaccountname"
sudo sysadminctl -deleteUser "$adminaccountname" # Remove existing admin account if it exists
sudo sysadminctl -adminUser "$adminaccountname" -adminPassword "$p" -addUser "$adminaccountname" -fullName "$adminaccountfullname" -password "$p" -admin

echo "Local Admin Account Created"