#!/usr/bin/python
# coding=utf-8

from datetime import datetime
from math import floor
from math import log
from math import pow
from time import sleep

import json
import os.path
import re
import subprocess
import sys

################################################################################
# Memory
def memory_status():
    with open('/proc/meminfo', 'r') as meminfo_file:
        meminfo = meminfo_file.read()

    used = int(re.search('Active: +([0-9]+)', meminfo).group(1)) * 1000
    total = int(re.search('MemTotal: +([0-9]+)', meminfo).group(1)) * 1000

    return (used, total)

def memory_part():
    mem_used, mem_total = memory_status()

    return [{
        'full_text': 'Mem ',
        'color': Colors.gray,
        'separator': False,
        'separator_block_width': 0
    }] + horizontal_bar(mem_used * 1.0 / mem_total, 10) + [{
        'full_text': ' ' + bytes_string(mem_used, 1),
        'separator': False,
        'separator_block_width': 0
    }, {
        'full_text': '/' + bytes_string(mem_total, 1),
        'color': Colors.dark_gray
    }]

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

    title_part = {
        'full_text': 'Vol ',
        'color': Colors.gray,
        'separator': False,
        'separator_block_width': 0
    }

    if muted:
        return [title_part, {
            'full_text': 'Muted'
        }]

    return [title_part] + horizontal_bar(volume_percent, 10) + [{
        'full_text': ' ' + str(int(volume_percent * 100)).rjust(3) + '%'
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

    bar_color = Colors.green
    if charge_percent < 0.2:
        if not charging and frame % 6 < 1:
            bar_color = Colors.bright_red
        else:
            bar_color = Colors.red
    elif charge_percent < 0.6:
        bar_color = Colors.yellow

    charge_text = ''
    if charging:
        charge_text = charge_text + u' ⚡'
    charge_text = charge_text + ' ' + str(int(charge_percent * 100)).rjust(3) + '%'

    filler_text = (u'◯' * (frame % 4)) + u'◉' + (u'◯' * (3 - (frame % 4)))
    return [{
        'full_text': 'Bat ',
        'color': Colors.gray,
        'separator': False,
        'separator_block_width': 0
    }] + horizontal_bar(charge_percent, 10, bar_color = bar_color, filler_char = filler_text if charging else u'◯') + [{
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
    bright_red = "#f18354"
    yellow = '#b58900'
    green = '#859900'
    gray = '#8aa1ac'
    dark_gray = '#586e75'

def horizontal_bar(value, width, bar_color = None, filler_color = Colors.dark_gray, filler_char = u'◯'):
    partials = [u'◐', u'●']

    bar = u'●' * int(value * width)
    if value == 0:
        bar = filler_char
    elif value < 1.0:
        bar = bar + partials[int(floor((value * width % 1) * len(partials)))]
    filler_chars_needed = (width - int(value * width) - 1)
    filler = (filler_char * filler_chars_needed)[0:filler_chars_needed]

    return [{
        'full_text': bar,
        'color': bar_color,
        'separator': False,
        'separator_block_width': 0
    }, {
        'full_text': filler,
        'color': filler_color,
        'separator': False,
        'separator_block_width': 0
    }]

def bytes_string(num_bytes, decimal_places = 0):
    units = ['b', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb', 'Zb', 'Yb']
    order = int(floor(log(num_bytes, 1000)))
    return (('%.' + str(decimal_places) + 'f') % (num_bytes / pow(1000, order))) \
            + units[order]

################################################################################
# Output
sys.stdout.write("{\"version\":1}")
sys.stdout.write("[")
frame = 0
while True:
    parts = memory_part() + volume_part() + battery_part() + datetime_part()
    for part in parts:
        if not 'separator_block_width' in part:
            part['separator_block_width'] = 35
        if not 'separator' in part:
            part['separator'] = False
    sys.stdout.write(json.dumps(parts))
    sys.stdout.write(",\n")
    sys.stdout.flush()
    sleep(0.2)
    frame = frame + 1
