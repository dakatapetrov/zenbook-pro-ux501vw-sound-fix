#!/bin/bash

# credits: https://stackoverflow.com/a/246128/4649594
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
TMP_DIR=$DIR/tmp
SERVICE_DIR=$DIR/systemd
SYSTEMD_SERVICE_PATH=/etc/systemd/system/

mkdir $TMP_DIR
cp $SERVICE_DIR/* $TMP_DIR/


sed -i "7i\Environment=DIR=$DIR" $TMP_DIR/reset-user-pins@.service
sed -i "9i\Environment=DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" $TMP_DIR/stop-pulse@.service
sed -i "6i\Environment=DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" $TMP_DIR/start-pulse@.service

sudo cp $TMP_DIR/* $SYSTEMD_SERVICE_PATH

sudo systemctl daemon-reload
sudo systemctl enable stop-pulse@$USER.service
sudo systemctl enable reset-user-pins@$USER.service
sudo systemctl enable start-pulse@$USER.service

rm -r $TMP_DIR
