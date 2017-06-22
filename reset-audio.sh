#!/bin/bash

# credits: https://stackoverflow.com/a/246128/4649594
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

pulseaudio --check &>/dev/null
[ $? -eq 0 ] && WAS_PULSE_ON=true || WAS_PULSE_ON=false

systemctl --user status pulseaudio.service &>/dev/null
[ $? -eq 0 ] && WAS_ON_SYSTEMD=true || WAS_ON_SYSTEMD=false

function reconfig {
    sudo bash -c "cp $1/user_pin_configs /sys/class/sound/hwC0D0/user_pin_configs"
    sudo bash -c 'echo 1 | tee /sys/class/sound/hwC0D0/reconfig' &>/dev/null
}

function stop_pulse {
    if [ "$1" = true ]; then
        systemctl --user stop pulseaudio.service
        systemctl --user stop pulseaudio.socket

    else
        PULSE_CONFIG=$HOME/.config/pulse/client.conf
        mv $PULSE_CONFIG $PULSE_CONFIG.backup
        echo autospawn = no > $PULSE_CONFIG
        pulseaudio --kill
        rm $PULSE_CONFIG
        mv $PULSE_CONFIG.backup $PULSE_CONFIG
    fi
}

function start_pulse {
    if [ "$1" = true ]; then
        systemctl --user start pulseaudio
    else
        pulseaudio --start
    fi
}

if [ "$WAS_PULSE_ON" = true ]; then
    stop_pulse $WAS_ON_SYSTEMD
    reconfig $DIR
    start_pulse $WAS_ON_SYSTEMD
else
    reconfig $DIR
fi
