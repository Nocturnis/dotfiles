#!/usr/bin/python
# coding=utf-8

from datetime import datetime
from time import sleep

import json
import os.path
import re
import subprocess
import sys

################################################################################
# Volume
def volume_status():
    sound_status = subprocess.check_output(['amixer', 'sget', 'Master'])
    match = re.search('Playback [0-9]+ \\[([0-9]+)%\\] \\[(?:.+?)\\] \\[(.+?)\\]', sound_status)
    volume_percent = float(match.group(1)) / 100
    muted = match.group(2).find('off') >= 0

    return (volume_percent, muted)

def volume_part():
    volume_percent, muted = volume_status()

    result = ''
    if muted:
        result = result + 'Muted'
    else:
        result = result + horizontal_bar(10, volume_percent) + u'▏'
        result = result + str(int(volume_percent * 100)).rjust(3) + '%'
    return [{
        'full_text': 'Vol ',
        'color': Colors.gray,
        'separator': False,
        'separator_block_width': 0
    }, {
        'full_text': result
    }]

################################################################################
# Battery
def has_battery():
    return os.path.exists('/sys/class/power_supply/BAT0')

def battery_status():
    with open('/sys/class/power_supply/BAT0/charge_now', 'r') as charge_current_file:
        charge_current = int(charge_current_file.read())
    with open('/sys/class/power_supply/BAT0/charge_full', 'r') as charge_full_file:
        charge_full = int(charge_full_file.read())
    with open('/sys/class/power_supply/BAT0/status', 'r') as status_file:
        charging = status_file.read().rstrip('\n') != 'Discharging'
    charge_percent = charge_current * 1.0 / charge_full

    return (charge_percent, charging)

def battery_part():
    if not has_battery():
        return []

    charge_percent, charging = battery_status()

    bar_color = Colors.green # green
    if charge_percent < 0.2:
        bar_color = Colors.red # red
    elif charge_percent < 0.6:
        bar_color = Colors.yellow # yellow

    bar = horizontal_bar(10, charge_percent) + u'▏'

    charge_text = ''
    if charging:
        charge_text = charge_text + u'⚡'
    else:
        charge_text = charge_text + ' '
    charge_text = charge_text + ' ' + str(int(charge_percent * 100)).rjust(3) + '%'

    return [{
        'full_text': 'Bat ',
        'color': Colors.gray,
        'separator': False,
        'separator_block_width': 0
    }, {
        'full_text': bar,
        'color': bar_color,
        'separator': False,
        'separator_block_width': 0
    }, {
        'full_text': charge_text
    }]

################################################################################
# Date/Time
def datetime_part():
    now = datetime.now()
    return [{
        'full_text': now.strftime('%A ') + now.strftime('%-m/%-d/%y %I:%M%p').lower()
    }]


################################################################################
# Util
class Colors:
    red = '#cb4c16'
    yellow = '#b58900'
    green = '#859900'
    gray = '#586e75'

def horizontal_bar(width, value):
    result = ''
    for i in range(0, width):
        if i == int(value * width):
            partial = (value * width - i) * 10 / 8
            partials = [u'▏', u'▎', u'▍', u'▌', u'▋', u'▊', u'▉']
            for j in range(7):
                if partial <= (j + 1) * 1.0 / 8:
                    result = result + partials[j]
                    break
            else:
                result = result + u'█'
        elif i < int(value * width):
            result = result + u'█'
        else:
            result = result + ' '
    return result

################################################################################
# Output
sys.stdout.write("{\"version\":1}")
sys.stdout.write("[")
while True:
    parts = volume_part() + battery_part() + datetime_part()
    for part in parts:
        if not 'separator_block_width' in part:
            part['separator_block_width'] = 35
        if not 'separator' in part:
            part['separator'] = False
    sys.stdout.write(json.dumps(parts))
    sys.stdout.write(",\n")
    sys.stdout.flush()
    sleep(0.2)
