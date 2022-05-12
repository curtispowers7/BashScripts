#!/bin/bash
#---------------------------------------------------------------------------------------------------------------------

#DEFINE THE GLOBAL VARIABLES

#---------------------------------------------------------------------------------------------------------------------
ruby_version=$(ruby --version | grep --extended-regexp --only-matching "[0-9]\.[0-9]\.[0-9]{1,2}")


#---------------------------------------------------------------------------------------------------------------------

#DEFINE THE FUNCTIONS NEEDED

#---------------------------------------------------------------------------------------------------------------------
#Checks the ruby version to make sure it supports Rails
rubyVersionMet () {

    #set's the ruby_version variable to what was passed to the function
    local ruby_version="${1}"
    #regular expression to match 2.7.0+ of Ruby as rails is only supported on 2.7.0+
    local rails_supported_version="(^2\.[7-9]\.[0-9]{1,2}$|^3\.[0-9]\.[0-9]{1,2}$)" 
    
    #if the ruby version is supported, then return 0 for True, else return 1 for False
    if [[ "${ruby_version}" =~ $rails_supported_version ]]
    then
        echo 0
    else
        echo 1
    fi
}

#Checks to see if rails is installed locally
checkRailsInstalled () {

    #sets rails_installed to False by default
    local rails_installed=1
    #a regular expression to make sure only the rails base package is matched
    local rails_package="\<rails\> "
    
    rails_version=$(gem list | grep --extended-regexp --only-matching "${rails_package}")
    #if the rails_version doesn't return any results, then don't change rails_installed and return it as False
    if [ -z "${rails_version}" ]
    then
        echo "${rails_installed}"
    #if the rails_version does return results, then sets rails_installed to 0 for True and returns it
    else
        rails_installed=0
        echo "${rails_installed}"
    fi
    
}


#---------------------------------------------------------------------------------------------------------------------

#DEFINE THE MAIN FUNCTION

#---------------------------------------------------------------------------------------------------------------------
main () {

    #check to see if the rails version is supported
    ruby_version_supported=$(rubyVersionMet "${ruby_version}")
    
    #if the rails version is supported
    if [ "${ruby_version_supported}" = 0 ]
    then
        #check gem to see if rails is installed
        rails_installed=$(checkRailsInstalled)
        #if rails is installed
        if [ "${rails_installed}" = 0 ]
        then
            echo "$(hostname):Rails Installed:True"
        else
            echo "$(hostname):Rails Installed:False"
        fi
    else
        echo "$(hostname):Ruby Supports Rails:False"
    fi

}

#---------------------------------------------------------------------------------------------------------------------

#THE BODY OF THE SCRIPT

#---------------------------------------------------------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
