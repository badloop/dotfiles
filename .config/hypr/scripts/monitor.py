#!/usr/bin/env python

import argparse
import subprocess

source_map = {"dp1": "0f", "dp2": "10", "hdmi1": "11", "hdmi2": "12"}
power_map = {"on": "01", "off": "04"}
arg_map = {"source": "60", "power": "D6"}

parser = argparse.ArgumentParser(
    prog="monitor", description="Controls settings on a connected display"
)
parser.add_argument("-d", "--display")
action = parser.add_mutually_exclusive_group()
action.add_argument("-s", "--source", choices=source_map.keys())
action.add_argument("-p", "--power", choices=power_map.keys())


args = parser.parse_args()

ACTION_KEY = ""
if args.source:
    ACTION_KEY = arg_map["source"]
elif args.power:
    ACTION_KEY = arg_map["power"]

ACTION_VAL = ""
if args.source:
    ACTION_VAL = source_map[args.source]
elif args.power:
    ACTION_VAL = power_map[args.power]


print(f"{ACTION_KEY}: {ACTION_VAL}")
subprocess.Popen(
    f"/usr/bin/ddcutil -d {args.display or 1} setvcp {ACTION_KEY} 0x{ACTION_VAL}".split(
        " "
    )
)
