#!/bin/bash
#
#golemsp-systemd-updater.sh
#v1.0
#installs or updates golemsp.service file in systemd to allow for prefered golemsp state to persist across system reboots
#alternatively by selecting no in the updater, it will give you the option of removing the systemd golemsp.service
#
if command -v "$HOME/.local/bin/golemsp" >/dev/null; then
  if command -v "$systemctl" >/dev/null; then
    echo " "
    echo -e "\033[0;91mSystemd not found, GolemSP service not installed.\033[0m"
    echo " "
  exit
  else
   echo " "
   echo " "
   echo "Install or Update GolemSP systemd service? [y|n]"
   echo " "
   read -rsn1 yn
    if [[ ${yn} = [Yy]* ]]; then
      sudo bash -c "cat << 'EOF' > /etc/systemd/system/golemsp.service

[Unit]
 Description=Start GolemSP
 After=network.target
 StartLimitIntervalSec=0

[Service]
 Type=simple
 Restart=on-abnormal
 User=$USER
 ExecStart=$HOME/.local/bin/golemsp run
 Environment=PATH=$HOME/.local/bin/
 #KillSignal=SIGINT sends keyboard ctrl+c to active golemsp session for a graceful shutdown.
 KillSignal=SIGINT

[Install]
  WantedBy=multi-user.target
EOF"

                 sudo systemctl daemon-reload
                 sudo systemctl enable golemsp
                   echo " "
                   echo -e "\033[0;32mSystemd Service successfuly installed for GolemSP.\033[0m"
                   echo "You can now enable or disable GolemSP on system startup using command."
                   echo " "
                   echo "       systemctl [enable|disable] golemsp"
                   echo " "
                   echo " "
                   echo "Start or stop the golemsp service for the current session using command."
                   echo " "
                   echo "       systemctl [start|stop] golemsp"
                   echo " "
                   echo " "
                   echo "For more information."
                   echo " "
                   echo "       systemctl --help"
                   echo " "
                   echo " "
                   echo "Golem Service Provider."
                   echo " "
                   echo "       golemsp --help"
                   echo " "
                   echo " "
    else
      if [[ -f /etc/systemd/system/golemsp.service ]]; then
        echo " "
        echo "Found existing GolemSP systemd service would you like to remove it? [y|n]"
        echo " "
        echo " "
        read -rsn1 yn
        if [[ ${yn} = [Yy]* ]]; then

          sudo systemctl disable golemsp.service
          sudo rm -f /etc/systemd/system/golemsp.service
          echo " "
          echo "GolemSP systemd service removed."
          echo " "
        fi
      fi
    fi
  fi
  else
     echo " "
     echo -e "\033[0;91mError -  GolemSP binary not found\033[0m"
     echo -e "\003[0;91mError -  Failed Install\033[0m"
     echo " "
     echo " "
fi