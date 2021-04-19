#!/bin/bash
#
#
#.USAGE
# To start, run:
# wget https://raw.githubusercontent.com/vijujames/sierra-wireless-modems/master/flash-additional-firmware.sh && sudo bash flash-additional-firmware.sh <CARRIER>
# Last installed firmware will be set as the Active one in EM7455


CARRIER="$1"
if [ -z "$CARRIER" ]
then
	echo "Please provide the CARRIER name. Valid values are rogers/att/sprint/verizon/vodafone (e.g., flash-additional-firmware.sh verizon)"
 	exit 1
fi

sudo add-apt-repository universe
sudo apt update
sudo apt-get install curl putty minicom libqmi-glib5 libqmi-proxy libqmi-utils -y

systemctl stop ModemManager
deviceid=`lsusb | grep -i -E '1199:9071|1199:9079|413C:81B6' | awk '{print $6}'`

shopt -s nocasematch

# Rogers
if [[ ${CARRIER} == 'rogers' ]]; then
    echo "Installing firmware for Rogers..."
    curl -o SWI9X30C_02.32.11.00_Rogers_001.040_000.zip -L https://source.sierrawireless.com/-/media/support_downloads/airprime/74xx/fw/7455/swi9x30c_02.32.11.00_rogers_001.040_000.ashx
    unzip SWI9X30C_02.32.11.00_Rogers_001.040_000.zip
    sudo qmi-firmware-update --update -d "$deviceid" SWI9X30C_02.32.11.00.cwe SWI9X30C_02.32.11.00_ROGERS_001.040_000.nvu
fi

# AT&T
if [[ ${CARRIER} == 'att' ]]; then
    echo "Installing firmware for AT&T..."
    curl -o SWI9X30C_02.32.11.00_ATT_002.070_002.zip -L https://source.sierrawireless.com/-/media/support_downloads/airprime/74xx/fw/7455/swi9x30c_02.32.11.00_att_002.070_002.ashx
    unzip SWI9X30C_02.32.11.00_ATT_002.070_002.zip
    sudo qmi-firmware-update --update -d "$deviceid" SWI9X30C_02.32.11.00.cwe SWI9X30C_02.32.11.00_ATT_002.070_002.nvu
fi

# Sprint
if [[ ${CARRIER} == 'sprint' ]]; then
    echo "Installing firmware for Sprint..."
    curl -o SWI9X30C_02.32.11.00_Sprint_002.062_001.zip -L https://source.sierrawireless.com/-/media/support_downloads/airprime/74xx/fw/7455/swi9x30c_02.32.11.00_sprint_002.062_001.ashx
    unzip SWI9X30C_02.32.11.00_Sprint_002.062_001.zip
    sudo qmi-firmware-update --update -d "$deviceid" SWI9X30C_02.32.11.00.cwe SWI9X30C_02.32.11.00_SPRINT_002.062_001.nvu
fi

# Verizon
if [[ ${CARRIER} == 'verizon' ]]; then
    echo "Installing firmware for Verizon..."
    curl -o SWI9X30C_02.33.03.00_Verizon_002.079_001.zip -L https://source.sierrawireless.com/-/media/support_downloads/airprime/74xx/fw/7455/swi9x30c_02.33.03.00_verizon_002.079_001.ashx
    unzip SWI9X30C_02.33.03.00_Verizon_002.079_001.zip
    sudo qmi-firmware-update --update -d "$deviceid" SWI9X30C_02.33.03.00.cwe SWI9X30C_02.33.03.00_VERIZON_002.079_001.nvu
fi

# Vodafone
if [[ ${CARRIER} == 'vodafone' ]]; then
    echo "Installing firmware for Vodafone..."
    curl -o SWI9X30C_02.24.03.00_Vodafone_001.001_000.zip -L https://source.sierrawireless.com/-/media/support_downloads/airprime/74xx/fw/7455/7455_2_24/swi9x30c_02.24.03.00_vodafone_001.001_000.ashx
    unzip SWI9X30C_02.24.03.00_Vodafone_001.001_000.zip
    sudo qmi-firmware-update --update -d "$deviceid" SWI9X30C_02.24.03.00.cwe SWI9X30C_02.24.03.00_VODAFONE_001.001_000.nvu
fi
