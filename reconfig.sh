#!/bin/bash

# credits: https://stackoverflow.com/a/246128/4649594
# SOURCE="${BASH_SOURCE[0]}"
# while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
#   DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#   SOURCE="$(readlink "$SOURCE")"
#   [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
# done
# DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

USER_PIN_PATH=$1


cp $USER_PIN_PATH /sys/class/sound/hwC0D0/user_pin_configs
echo 1 | tee /sys/class/sound/hwC0D0/reconfig &>/dev/null
