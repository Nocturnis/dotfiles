#!/usr/bin/python
# coding=utf-8

from datetime import datetime
from termcolor import colored
from time import sleep

import re
import subprocess 
import sys

def volume_string():
    sound_status = subprocess.check_output(['amixer', 'sget', 'Master'])
    match = re.search('Playback [0-9]+ \\[([0-9]+)%\\] \\[(?:.+?)\\] \\[(.+?)\\]', sound_status)
    volume_percent = float(match.group(1)) / 100
    muted = match.group(2).find('off') >= 0

    result = ''
    if muted:
        result = result + 'Muted'
    else:
        for i in range(0, 10):
            if i < volume_percent * 10:
                #result = result + u'█'
                result = result + '\\u2588'
            else:
                result = result + ' '
        result = result + ' ' + str(int(volume_percent * 100)).rjust(3) + '%'
    return result

def battery_level_string():
    with open('/sys/class/power_supply/BAT0/charge_now', 'r') as charge_current_file:
        charge_current = int(charge_current_file.read())
    with open('/sys/class/power_supply/BAT0/charge_full', 'r') as charge_full_file:
        charge_full = int(charge_full_file.read())
    with open('/sys/class/power_supply/BAT0/status', 'r') as status_file:
        charging = status_file.read().rstrip('\n') != 'Discharging'
    charge_percent = charge_current * 1.0 / charge_full

    color = 'green'
    if charge_percent < 0.2:
        color = 'red'
    elif charge_percent < 0.6:
        color = 'yellow'

    result = ''
    for i in range(0, 10):
        if i < charge_percent * 10:
            #result = result + colored(u'█', color)
            #result = result + u'█'
            result = result + '\\u2588'
        else:
            #result = result + u'░'
            result = result + ' '
    if charging:
        #result = result + u'⚡'
        result = result + ' \\u26a1'
    else:
        result = result + '  '
    result = result + ' ' + str(charge_current * 100 / charge_full).rjust(3) + '%'

    return result

def date_string():
    return datetime.now().strftime('%-m/%-d/%y %I:%M%p').lower()

sys.stdout.write("{\"version\":1}")
sys.stdout.write("[")
i = 0
while True:
    sys.stdout.write("[")
    # TODO: better JSON encoding than just string concat
    sys.stdout.write("{\"full_text\": \"" + volume_string() + "\"},")
    sys.stdout.write("{\"full_text\": \"" + battery_level_string() + "\"},")
    sys.stdout.write("{\"full_text\": \"" + date_string() + "\"}")
    sys.stdout.write("],")
    sys.stdout.flush()
    i = i + 1
    sleep(0.2)
