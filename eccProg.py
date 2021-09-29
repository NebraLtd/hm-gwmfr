#!/usr/bin/env python3

from pathlib import Path
from time import sleep
import logging
import os
import subprocess

print("Nebra ECC Tool")

preTestFail = 0
afterTestFail = 0

ECC_SUCCESSFUL_TOUCH_FILEPATH = "/var/data/gwmfr_ecc_provisioned"
logging.basicConfig(level=os.environ.get("LOGLEVEL", "DEBUG"))


# https://stackoverflow.com/questions/1158076/implement-touch-using-python
def record_successful_provision():
    logging.debug("ECC provisioning complete")
    Path(ECC_SUCCESSFUL_TOUCH_FILEPATH).touch()
    logging.debug("ECC provisioning recorded. Touched to %s" % ECC_SUCCESSFUL_TOUCH_FILEPATH)


while preTestFail < 10:
    preTest = subprocess.run(["/opt/gateway_mfr/bin/gateway_mfr", "ecc", "onboarding"], capture_output=True)
    preTestResult = str(preTest.stdout.decode('ascii')).rstrip()
    if "not responding to pings" not in preTestResult:
        break
    else:
        print("Can't load provisioning tool, retrying")
        preTestFail += 1
        sleep(2)

if "ecc_response_exec_error" in preTestResult:
    print("Provisioning")

    while afterTestFail < 5:
        subprocess.run(["/opt/gateway_mfr/bin/gateway_mfr", "ecc", "provision"])

        print("Testing")

        afterTest = subprocess.run(["/opt/gateway_mfr/bin/gateway_mfr", "ecc", "onboarding"], capture_output=True).stdout
        afterTestResult = str(afterTest.decode('ascii')).rstrip()
        print(afterTestResult)

        if "ecc_response_exec_error" in afterTestResult:
            print("\033[91mProgramming FAILED\033[0m")
            print("Retrying provisioning")
            afterTestFail += 1
            sleep(2)
        elif (len(afterTestResult) == 51 or len(afterTestResult) == 52):
            print("\033[92mProgramming Success!\033[0m")
            record_successful_provision()
            break
        else:
            print("\033[91mAn Unknown Error Occured\033[0m")
            print("Retrying provisioning")
            afterTestFail += 1
            sleep(2)

elif (len(preTestResult) == 51 or len(preTestResult) == 52):
    print("\033[93mKey Already Programmed\033[0m")
    print(preTestResult)
    record_successful_provision()

else:
    print("An Unknown Error Occured")
    print(preTestResult)

# This next bit of mank is so we can run the gwmfr container for longer
# by providing the OVERRIDE_GWMFR_EXIT environment variable for trouble
# shooting purposes.
if os.getenv('OVERRIDE_GWMFR_EXIT', None):
    while(True):
        print("GWMFR Utility Exit Overriden")
        sleep(300)
