#!/bin/bash
#
#
#.USAGE
# To start, run:
# wget https://raw.githubusercontent.com/vijujames/sierra-wireless-modems/master/enable-external-sim-slot.sh && sudo bash enable-external-sim-slot.sh

CYAN='\033[0;36m'
NC='\033[0m' # No Color
ttyUSB=ttyUSB2

function script_prechecks() {
    printf "${CYAN}---${NC}\n"
    echo 'Searching for EM7455/MC7455 USB modems...'
    modemcount=$(lsusb | grep -c -i -E '1199:9071|1199:9079|413C:81B6')
    while [ "$modemcount" -eq 0 ]
    do
        printf "${CYAN}---${NC}\n"
        echo "Could not find any EM7455/MC7455 USB modems"
        echo 'Unplug and reinsert the EM7455/MC7455 USB connector...'
        modemcount=$(lsusb | grep -c -i -E '1199:9071|1199:9079|413C:81B6')
        sleep 3
    done

    printf "${CYAN}---${NC}\n"
    echo "Found EM7455/MC7455:
    $(lsusb | grep -i -E '1199:9071|1199:9079|413C:81B6')
    "

    if [ "$modemcount" -gt 1 ]
    then
        printf "${CYAN}---${NC}\n"
        echo "Found more than one EM7455/MC7455, remove the one you dont want to flash and try again."
        exit
    fi

    printf "${CYAN}---${NC}\n"
    echo "Installing all needed prerequisites..."
    apt-get install curl minicom -y
}

function enable_external_sim() {
    # cat the serial port to monitor output and commands. cat will exit when AT!RESET kicks off.
    sudo cat /dev/"$ttyUSB" 2>&1 | tee -a modem.log &

    # Set Generic Sierra Wireless VIDs/PIDs
    cat <<EOF > script.txt
send AT
send ATE1
sleep 1
send ATI
sleep 1
send AT!ENTERCND=\"A710\"
sleep 1
send AT!USBCOMP=1,1,100D
sleep 1
send AT!CUSTOM=\"UIM2ENABLE\",1
sleep 1
send AT!UIMS=1
sleep 1
send AT!RESET
! pkill minicom
EOF
    sudo minicom -b 115200 -D /dev/"$ttyUSB" -S script.txt &>/dev/null
}


script_prechecks
enable_external_sim
