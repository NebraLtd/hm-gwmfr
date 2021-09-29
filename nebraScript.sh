#!/bin/bash

echo "Checking for I2C device"

mapfile -t data < <(i2cdetect -y 1)

for i in $(seq 1 ${#data[@]}); do
    # shellcheck disable=SC2206
    line=(${data[$i]})
    # shellcheck disable=SC2068
    if echo ${line[@]:1} | grep -q 60; then
        echo "ECC is present"
        echo "Starting ECC Tool"
        /opt/gateway_mfr/bin/gateway_mfr start

        sleep 5

        echo "Running ECC Python Program"

        python3 /opt/gateway_mfr/eccProg.py

        echo "Python program finished, shutting down"

        /opt/gateway_mfr/bin/gateway_mfr stop

        echo "Shutting down ECC container"
        exit 0
    fi
done

echo "No ECC found"
echo "Shutting down ECC container"
