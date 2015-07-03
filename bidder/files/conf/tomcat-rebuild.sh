#!/bin/bash

######
# This is equivalent to the bigass update script 
# for Apollo tomcat servers
# 

if [ $UID != 0 ]; then
    echo $HOSTNAME "ERROR - MUST be run as root"
    exit 1
fi


###
# Import our environment setting script
[ -f "/usr/local/tomcat/bin/setenv.sh" ] && export ENV_SCRIPT="/usr/local/tomcat/bin/setenv.sh"
[ -f "$ENV_SCRIPT" ]  && . $ENV_SCRIPT
[ -f "$ENV_SCRIPT" ]  || echo $HOSTNAME "$ENV_SCRIPT not found, required for operation!"
[ -f "$ENV_SCRIPT" ]  || exit 1


###
# Script Specific Vars
export WEBAPP_ROOT="/var/rsi/tomcat/webapps"
export PUPPET_AGENT_SCRIPT="/usr/local/sbin/puppet-agent-run.sh"

#Global Error function for missing deps
function error_on_missing_req_variable {
    echo $HOSTNAME "Unable to contiune you are missing the $1 variable. (using $ENV_SCRIPT for enviornment)"
    exit -1
}

# APP_NAME  example: export APP_UID=`id -u $APP_NAME`
[ -z "$APP_NAME" ] && error_on_missing_req_variable APP_NAME
# TOMCAT_DIR example: export TOMCAT_DIR=/usr/local/tomcat
[ -z "$TOMCAT_DIR" ] && error_on_missing_req_variable TOMCAT_DIR
# INIT_SCRIPT: example: export INIT_SCRIPT="/etc/init.d/tomcat"
[ -z "$INIT_SCRIPT" ] && error_on_missing_req_variable INIT_SCRIPT
# WEBAPP_ROOT: example: export WEBAPP_ROOT="/var/rsi/tomcat/webapps"
[ -z "$WEBAPP_ROOT" ] && error_on_missing_req_variable WEBAPP_ROOT
# PUPPET_AGENT_SCRIPT: example: export PUPPET_AGENT_SCRIPT="/etc/cron.hourly/puppet-agent-run.sh"
[ -z "$PUPPET_AGENT_SCRIPT" ] && error_on_missing_req_variable PUPPET_AGENT_SCRIPT

    
###
# Run puppet to update builds
echo $HOSTNAME "Running Pupppet to update prod configs."
${PUPPET_AGENT_SCRIPT}
RETVAL=$?
if [ $RETVAL != 0 ]; then
    echo $HOSTNAME "ERROR Puppet client did not run successfully... Aborting"
    exit 1
fi

###
# Check tomcat status - do we need to stop?
$INIT_SCRIPT status
RETVAL=$?
if [ $RETVAL == 0 ]; then 
    $INIT_SCRIPT stop 60
    RETVAL=$?
    if [ $RETVAL != 0 ]; then
        echo $HOSTNAME "ERROR Could not stop tomcat... Aborting"
        exit 1
    fi
else
    echo $HOSTNAME "Tomcat was not running - updating"
fi

###
# Find all wars and remove thier exploded directories
# added 7-16-2013
# checks for all symlinks under the "webapps dir" currently defined in the script as /var/rsi/tomcat/webaps.
for x in `/usr/bin/find ${WEBAPP_ROOT} -type l |cut -d '.' -f1`;
    do
        # rolls through all links and check to see if they are directories
        if [ -d ${x} ]; then
            echo $HOSTNAME "Deleteing extracted webapp $x"
            #echo $HOSTNAME ${x}
            rm -rf ${x}
        else
            echo $HOSTNAME "No Extracted Wars found"
        fi
    done


####
# So the timestamp of the sym link and folder differ so we know it updated
#echo $HOSTNAME "Sleeping for 61 seconds to offset timestamps"
#sleep 61   
#ls -lh ${WEBAPP_ROOT}/${APP_NAME}

 
###
# Finally start tomcat back up
$INIT_SCRIPT start 1
RETVAL=$?
if [ $RETVAL != 0 ]; then
    echo $HOSTNAME "ERROR I could not start tomcat... SERVER DOWN"
    exit 1  
fi
