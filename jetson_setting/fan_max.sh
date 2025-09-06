#!/bin/bash
# copy to /usr/local/bin/
# sudo chmod +x /usr/local/bin/fan_max.sh
# Xavier のファンを最大に設定

# hwmon の pwm デバイスを探す
for pwm in /sys/class/hwmon/hwmon*/pwm1; do
    if [ -f "$pwm" ]; then
        echo 255 > "$pwm"
    fi
done
