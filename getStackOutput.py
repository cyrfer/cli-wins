#!/usr/bin/python
import sys
import json

# this script's purpose is to return the value of one key within the stack's Outputs

if len(sys.argv) != 2:
    print('args needs to be 2, len(sys.argv) provided: {l}'.format(l=len(sys.argv)))
    sys.exit(1)

# the key to identify the Value of interest
OutputKey = sys.argv[1]

data = ''.join(sys.stdin.readlines())
# print('read from stdin: {d}'.format(d=data))

# parse the data
try:
    stackInfo=json.loads(data)
except Exception as e:
    print('error parsing: {e}'.format(e=e))
    sys.exit(2)

# navigate the data
try:
    outputs = stackInfo["Stacks"][0]["Outputs"]
except Exception as e:
    print('error navigating: {e}'.format(e=e))
    sys.exit(3)

# find the key by OutputKey
try:
    OutputOfInterest = next(i for i in outputs if i["OutputKey"] == OutputKey)
except Exception as e:
    print('error finding match: {e}'.format(e=e))
    sys.exit(4)

print(OutputOfInterest["OutputValue"])
# sys.exit(0)
