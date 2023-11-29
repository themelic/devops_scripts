#!/bin/bash
# -*- coding: utf-8 -*-
##############################################################################
#
#    Melih Melik SÖNMEZ
#    Copyright (C) 2023-TODAY melic.com
#    you can modify it under the terms of the GNU LESSER
#    GENERAL PUBLIC LICENSE (AGPL v3), Version 3.
#    This script is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU LESSER GENERAL PUBLIC LICENSE (AGPL v3) for more details.
#
#    You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
#    GENERAL PUBLIC LICENSE (AGPL v3) along with this script.
#    If not, see <http://www.gnu.org/licenses/>.
#
##############################################################################

##Script requires 2 entries ; first one is for the action command  and second and third ones are paramaters required for action

ACTION=$1
PARAMETER1=$2
PARAMETER2=$3

case "${ACTION}" in
usage)

## System Load and Resource Usage Monitoring
    clear
    echo "System Load: $(uptime)"
    echo "Free Memory: $(free -h | grep Mem | awk '{print $4}')"
    echo "Free Disk Space: $(df -h / | grep / | awk '{print $4}')"
    ;;

## Check var\log errors
varlog)
    clear
    # Define the log file
    LOG_FILE="/var/log/syslog"
    # Search for errors in the log file
    ERRORS=$(grep "error" "$LOG_FILE")
    # Filter out irrelevant data
    ERRORS=$(echo "$ERRORS" | sed -e "s/.*error: //" -e "s/ at .*$//")
    # Count the number of errors
    ERROR_COUNT=$(echo "$ERRORS" | wc -l)
    # Display the results
    echo "Found $ERROR_COUNT errors:"
    echo "$ERRORS" > errors.txt ;;

##User Account Management
usercreate)
    sudo useradd "${PARAMETER1}"  ;;
userdelete)
    sudo userdel -r "${PARAMETER1}" ;;
userupdate)
    sudo passwd "${PARAMETER1}" ;;

## Check system apt updates and  upgrades 
update)
      sudo apt-get update && apt-get upgrade -y ;;

##AUTOMATED BACKUP WITH TIMESTAMP
backup)
    ## SOURCE="/path/to/your/important/files"
    ## DESTINATION="/path/to/your/backup/directory"
    
    clear
    SOURCE="${PARAMETER1}"
    DESTINATION="${PARAMETER2}"
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    
    tar czf "${DESTINATION}/backup_${TIMESTAMP}.tar.gz" "${SOURCE}"
;;

## No action is used so this is the end of the script
*)
    echo "Opps ! You mistype it ; you have to add missing action." 
    echo "Usage: ./daily_task.sh [usage|varlog|backup|usercreate|userdelete|userupdate] [parameter1|username] [parameter2]"
    echo "Please use your daily action and use necessary parameters"
    ;;
esac
