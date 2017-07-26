################################ IMPORTANT NOTE ####################################
# This script's purpose is to increment and update build version
####################################################################################
#!/bin/ksh

buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${PROJECT_DIR}/${INFOPLIST_FILE}")  
buildNumber=$(($buildNumber + 1))  
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${PROJECT_DIR}/${INFOPLIST_FILE}"
