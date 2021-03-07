#!/bin/bash
echo "Starting ECC Tool"
/opt/gateway_mfr/bin/gateway_mfr start

sleep 5

echo "Running ECC Python Program"

python3 /opt/gateway_mfr/eccProg.py

echo "Python program finished, shutting down"

/opt/gateway_mfr/bin/gateway_mfr stop

echo "Shutting down ECC container"
