#!/bin/bash

# credits: https://stackoverflow.com/a/246128/4649594
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

PATH=$DIR:$PATH
USER_PIN_PATH=$DIR/user_pin_configs

function stop_pulse {
    if [ "$1" = true ]; then
        systemctl --user stop pulseaudio.s*
    else
        CONFIG_FILE=$HOME/.config/pulse/client.conf
        BACKUP_FILE=$CONFIG_FILE.ux501vw.backup
        if [ -f $CONFIG_FILE ]; then
            mv $CONFIG_FILE $BACKUP_FILE
        fi
        echo autospawn = no > $CONFIG_FILE
        pulseaudio --kill
        rm $CONFIG_FILE
        if [ -f $BACKUP_FILE ]; then
            mv $BACKUP_FILE $CONFIG_FILE
        fi
    fi
}

function start_pulse {
    if [ "$1" = true ]; then
        systemctl --user start pulseaudio
    else
        pulseaudio --start
    fi
}

pulseaudio --check &>/dev/null
[ $? -eq 0 ] && WAS_PULSE_ON=true || WAS_PULSE_ON=false

systemctl --user status pulseaudio.service &>/dev/null
[ $? -eq 0 ] && WAS_ON_SYSTEMD=true || WAS_ON_SYSTEMD=false


if [ "$WAS_PULSE_ON" = true ]; then
    stop_pulse $WAS_ON_SYSTEMD
    sudo bash -c "reconfig.sh $USER_PIN_PATH"
    start_pulse $WAS_ON_SYSTEMD
else
    sudo bash -c "reconfig.sh $USER_PIN_PATH"
fi
