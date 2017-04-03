#!/bin/bash

# Goal #####
# Customize shell 'prompt' to allow quick view of the server's info (role, location, etc).
# Use colored prompt when root privilege is gained.

# Moving parts #####
# Script creates or updates 2 files
# /etc/profile.d/custom-prompt.sh    # File name can be changed to fit your need.
# /root/.bashrc

# Tetesd on #####
# CentOS 6, CentOS 7


# Variables
declare _environ
declare _yes_no
_prompt_folder="etc/profile.d"
_prompt_file="custom-prompt.sh"
_now=`date +%Y%m%d_%H%M_%Z`
# END Variables

# Function to exit script if user enters nothing and hits Enter key.
function _func_environ_check(){
  if [ -n "$_environ" ]; then
    echo "Proceeding with update."
    else
    echo "No value was entered. Exiting script."
    kill -s TERM $TOP_PID   # exits the script completely
  fi
}


# Create/update /$_prompt_folder/$_prompt_file
function _func_platform_indicator(){
  if [ -e /$_prompt_folder/$_prompt_file ]; then
    echo -e "\n#####\n# File /$_prompt_folder/$_prompt_file already exists and below is content of 2nd line:\n"
    sed -n 2p /$_prompt_folder/$_prompt_file
    echo -e "\n#####"
    echo ""
      read -p "Do you want to update it? (y or n) " -n 1 -r
      echo    # (optional) move to a new line
      if [[ $REPLY =~ ^[Yy]$ ]]; then
          mv /$_prompt_folder/$_prompt_file /$_prompt_folder/${_prompt_file}_${_now} && echo -e "\nFile $_prompt_file backed up to /$_prompt_folder/${_prompt_file}_${_now} "

          echo -e "\nEnter your response below (ex: aws  or  VirtualBox)"
          read -e -p "Your value: " _environ

          _func_environ_check


cat >/$_prompt_folder/$_prompt_file <<'EOM'
if [ "$PS1" ]; then
  PS1="\n[\u@\h  HOLDER  \W]\\$ "
fi
EOM
          sed -i -e "s%HOLDER%$_environ%" /$_prompt_folder/$_prompt_file

      else
        echo -e "\n#####\n# Not updating /$_prompt_folder/$_prompt_file \n#####\n"
        kill -s TERM $TOP_PID  # exits the script completely
      fi

    else
      echo -e "\n#####\n# File /$_prompt_folder/$_prompt_file does not exist and needs to be created.\n#####"

      echo -e "\nEnter the value below (ex: aws  or  VirtualBox)"
      read -e -p "Your value: " _environ

      _func_environ_check


cat >/$_prompt_folder/$_prompt_file <<'EOM'
if [ "$PS1" ]; then
  PS1="\n[\u@\h  HOLDER  \W]\\$ "
fi
EOM
      sed -i -e "s%HOLDER%$_environ%" /$_prompt_folder/$_prompt_file

  fi
}


# Create/update /root/.bashrc
function _func_root(){
    echo -e "\n#####\n# Backed up /root/.bashrc >> /root/.bashrc_${_now}\n#####"
    cp /root/.bashrc /root/.bashrc_${_now}

  if ! grep --quiet "export PS1" /root/.bashrc; then
    echo -e "\n#####\n# Updating file /root/.bashrc so that color of prompt will be green when root privilege is gained.\n#####"
    echo -e "\n# Changing color or prompt when user has root privilege"  >> /root/.bashrc
    echo "export PS1='\n\[\e[1;32m\][\u@\h  $_environ  \W]#\[\e[0m\] '" >> /root/.bashrc
    echo
  else
    sed -i "/export PS1=/d" /root/.bashrc
    echo "export PS1='\n\[\e[1;32m\][\u@\h  $_environ  \W]#\[\e[0m\] '" >> /root/.bashrc
    echo -e "\n#####\n# Updated /root/.bashrc so that color of prompt will be green when root privilege is gained.\n#####"
  fi
}


# Informs user how to activte the changes.
function _func_activate(){
  echo -e "\n#####\nYou have 3 options for activating the changes. If you have multiple users logged in and want to make sure all see same prompt, best option is to reboot.\n"
  echo -e "1. Run following command\nsource /$_prompt_folder/$_prompt_file && source /root/.bashrc\n"
  echo -e "2. Log out completely and log back in."
  echo -e "3. Reboot OS instance.\n#####"
}


# Calling the functions
_func_platform_indicator
_func_root
_func_activate
