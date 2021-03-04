#!/usr/bin/env python3

from time import sleep
import os
import sys
import subprocess

print("Nebra ECC Tool")

preTest = subprocess.Popen("/opt/gateway_mfr/bin/gateway_mfr ecc onboarding", shell=True,  stdout=subprocess.PIPE).stdout
preTestResult = str(preTest.read().decode('ascii')).rstrip()

#print(preTestResult)

if("ecc_response_exec_error" in preTestResult):
    print("Provisioning")

    provisionEcc = subprocess.Popen("/opt/gateway_mfr/bin/gateway_mfr ecc provision", shell=True,  stdout=subprocess.PIPE).stdout
    provisionEccResult = provisionEcc.read()

    #print(provisionEccResult)
    print("Testing")

    afterTest = subprocess.Popen("/opt/gateway_mfr/bin/gateway_mfr ecc onboarding", shell=True,  stdout=subprocess.PIPE).stdout
    afterTestResult = str(afterTest.read().decode('ascii'))
    print(afterTestResult)
    if("ecc_response_exec_error" in afterTestResult):
        print("\033[91mProgramming FAILED\033[0m")
    else:
        print("\033[92mProgramming Success!\033[0m")

elif (len(preTestResult) == 51 or len(preTestResult) == 52):
    print("\033[93mKey Already Programmed\033[0m")

else:
    print("An Unknown Error Occured")
