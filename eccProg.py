#!/usr/bin/env python3

import subprocess
from time import sleep

print("Nebra ECC Tool")

preTestFail = 0
afterTestFail = 0

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
            break
        else:
            print("\033[91mAn Unknown Error Occured\033[0m")
            print("Retrying provisioning")
            afterTestFail += 1
            sleep(2)

elif (len(preTestResult) == 51 or len(preTestResult) == 52):
    print("\033[93mKey Already Programmed\033[0m")
    print(preTestResult)

else:
    print("An Unknown Error Occured")
    print(preTestResult)
