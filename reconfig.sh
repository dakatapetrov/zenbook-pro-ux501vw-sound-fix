#!/bin/bash

USER_PIN_PATH=$1


cp $USER_PIN_PATH /sys/class/sound/hwC0D0/user_pin_configs
echo 1 | tee /sys/class/sound/hwC0D0/reconfig &>/dev/null
