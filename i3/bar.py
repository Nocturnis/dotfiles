#!/usr/bin/python
# coding=utf-8

from datetime import datetime
from math import floor, log, pow
from time import sleep

import json
import os.path
import re
import select
import subprocess
import sys

class BarPart:
    def render(self, frame):
        return []

################################################################################
# CPU
class CpuPart(BarPart):
    def __init__(self):
        self._mpstat = subprocess.Popen(['mpstat', '5'], stdout=subprocess.PIPE)
        self._mpstat.stdout.readline()
        self._last_value = 0

    def __mpstat_has_available(self):
        return len(select.select([self._mpstat.stdout], [], [], 0)[0]) > 0

    def __status(self):
        last_line = None
        while self.__mpstat_has_available():
            last_line = self._mpstat.stdout.readline()
        if not last_line is None:
            idle = float(re.search('all +' + ('[\.0-9]+ +' * 9) + '([\.0-9]+)', last_line).group(1)) / 100
            value = 1 - idle
            self._last_value = value
            return value
        return self._last_value

    def render(self, frame):
        cpu_usage = self.__status()

        bar_color = Colors.green
        if cpu_usage > 0.8:
            bar_color = Colors.red
        elif cpu_usage > 0.5:
            bar_color = Colors.yellow

        return [{
            'name': 'cpu:title',
            'full_text': 'CPU ',
            'color': Colors.gray,
            'separator': False,
            'separator_block_width': 0
        }] + horizontal_bar(cpu_usage, bar_color = bar_color) + [{
            'name': 'cpu:value',
            'full_text': ' ' + str(int(cpu_usage * 100)).rjust(3) + '%'
        }]

################################################################################
# Memory
class MemoryPart(BarPart):
    def __status(self):
        with open('/proc/meminfo', 'r') as meminfo_file:
            meminfo = meminfo_file.read()

        used = int(re.search('Active: +([0-9]+)', meminfo).group(1)) * 1000
        total = int(re.search('MemTotal: +([0-9]+)', meminfo).group(1)) * 1000

        return (used, total)

    def render(self, frame):
        mem_used, mem_total = self.__status()
        mem_usage = mem_used * 1.0 / mem_total

        bar_color = Colors.green
        if mem_usage > 0.8:
            bar_color = Colors.red
        elif mem_usage > 0.5:
            bar_color = Colors.yellow

        return [{
            'name': 'mem:title',
            'full_text': 'Mem ',
            'color': Colors.gray,
            'separator': False,
            'separator_block_width': 0
        }] + horizontal_bar(mem_usage, bar_color = bar_color) + [{
            'full_text': ' ' + bytes_string(mem_used, 1),
            'separator': False,
            'separator_block_width': 0
        }, {
            'name': 'mem:value',
            'full_text': '/' + bytes_string(mem_total, 1),
            'color': Colors.dark_gray
        }]

################################################################################
# Volume
class VolumePart(BarPart):
    def __amixer_status(self):
        try:
            sound_status = subprocess.check_output(['amixer', 'sget', 'Master'])
            match = re.search('Playback [0-9]+ \\[([0-9]+)%\\] \\[(?:.+?)\\] \\[(.+?)\\]', sound_status)
            volume_percent = float(match.group(1)) / 100
            muted = match.group(2).find('off') >= 0

            return (volume_percent, muted, False)
        except subprocess.CalledProcessError:
            return (0, False, True)

    def __pacmd_status(self):
        try:
            sound_status = subprocess.check_output(['pacmd', 'list-sinks'])
            start_match = re.search('\* index: [0-9]+', sound_status)
            start_pos = start_match.end()
            end_match = re.compile('index: [0-9]+').search(sound_status, start_pos)
            end_pos = len(sound_status)
            if end_match is not None:
                end_pos = end_match.start()
            volume_match = re.compile('volume: front-left: [0-9]+ / +([0-9]+)%').search(sound_status, start_pos, end_pos)
            if volume_match is None:
                return (0, False, True)
            volume_percent = float(volume_match.group(1)) / 100
            muted_match = re.compile('muted: (yes|no)').search(sound_status, start_pos, end_pos)
            muted = muted_match.group(1) == 'yes'
            return (volume_percent, muted, False)
        except subprocess.CalledProcessError:
            return (0, False, True)

    def __status(self):
        result = self.__amixer_status()
        err = result[2]
        if not err:
            return result
        else:
            return self.__pacmd_status()

    def render(self, frame):
        volume_percent, muted, err = self.__status()

        title_part = {
            'name': 'vol:title',
            'full_text': 'Vol ',
            'color': Colors.gray,
            'separator': False,
            'separator_block_width': 0
        }

        if err:
            return [title_part, {
                'name': 'vol:err',
                'full_text': '?'
            }]

        if muted:
            return [title_part, {
                'name': 'vol:muted',
                'full_text': 'Muted'
            }]

        return [title_part] + horizontal_bar(volume_percent) + [{
            'name': 'vol:value',
            'full_text': ' ' + str(int(volume_percent * 100)).rjust(3) + '%'
        }]

################################################################################
# Brightness
class BrightnessPart(BarPart):
    def __status(self):
        try:
            backlight_status = subprocess.check_output(['xbacklight'])
            brightness_percent = float(backlight_status) / 100

            return (brightness_percent, False)
        except (subprocess.CalledProcessError, OSError):
            return (0, True)

    def render(self, frame):
        brightness_percent, err = self.__status()

        title_part = {
            'name': 'brt:title',
            'full_text': 'Brt ',
            'color': Colors.gray,
            'separator': False,
            'separator_block_width': 0
        }

        if err:
            return [title_part, {
                'name': 'brt:err',
                'full_text': '?'
            }]

        return [title_part] + horizontal_bar(brightness_percent) + [{
            'name': 'brt:value',
            'full_text': ' ' + str(int(brightness_percent * 100)).rjust(3) + '%'
        }]

################################################################################
# Battery
class BatteryPart(BarPart):
    def __has_battery(self):
        return os.path.exists('/sys/class/power_supply/BAT0')

    def __status(self):
        with open('/sys/class/power_supply/BAT0/charge_now', 'r') as charge_current_file:
            charge_current = int(charge_current_file.read())
        with open('/sys/class/power_supply/BAT0/charge_full', 'r') as charge_full_file:
            charge_full = int(charge_full_file.read())
        with open('/sys/class/power_supply/BAT0/status', 'r') as status_file:
            charging = status_file.read().rstrip('\n') != 'Discharging'
        charge_percent = charge_current * 1.0 / charge_full
        charge_percent = min(1, charge_percent)

        return (charge_percent, charging)

    def render(self, frame):
        if not self.__has_battery():
            return []

        charge_percent, charging = self.__status()

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

        filler_text = (u'◯' * (frame % 8)) \
                + u'◉' \
                + (u'◯' * (7 - (frame % 8)))

        return [{
            'name': 'bat:title',
            'full_text': 'Bat ',
            'color': Colors.gray,
            'separator': False,
            'separator_block_width': 0
        }] + horizontal_bar(charge_percent, bar_color = bar_color, filler_char = filler_text if charging else u'◯') + [{
            'name': 'bat:value',
            'full_text': charge_text
        }]

################################################################################
# Date/Time
class DateTimePart(BarPart):
    def render(self, frame):
        now = datetime.now()
        return [{
            'name': 'datetime:day_of_week',
            'full_text': now.strftime('%A '),
            'separator': False,
            'separator_block_width': 0
        }, {
            'name': 'datetime:month',
            'full_text': now.strftime('%-m'),
            'separator': False,
            'separator_block_width': 0
        }, {
            'full_text': '/',
            'color': Colors.dark_gray,
            'separator': False,
            'separator_block_width': 0
        }, {
            'name': 'datetime:day',
            'full_text': now.strftime('%-d '),
            'separator': False,
            'separator_block_width': 0
        #}, {
        #    'full_text': '/',
        #    'color': Colors.dark_gray,
        #    'separator': False,
        #    'separator_block_width': 0
        #}, {
        #    'name': 'datetime:year',
        #    'full_text': now.strftime('%y '),
        #    'separator': False,
        #    'separator_block_width': 0
        }, {
            'name': 'datetime:hour',
            'full_text': now.strftime('%I').lstrip('0'),
            'separator': False,
            'separator_block_width': 0
        }, {
            'full_text': ':',
            'color': Colors.dark_gray,
            'separator': False,
            'separator_block_width': 0
        }, {
            'name': 'datetime:minute',
            'full_text': now.strftime('%M'),
            'separator': False,
            'separator_block_width': 0
        }, {
            'name': 'datetime:half',
            'full_text': now.strftime('%p').lower(),
            'color': Colors.gray
        }]


################################################################################
# Util
class Colors:
    red = '#cb4c16'
    bright_red = '#f18354'
    yellow = '#b58900'
    green = '#859900'
    gray = '#8aa1ac'
    dark_gray = '#586e75'

def horizontal_bar(value, width = 10, bar_color = None, filler_color = Colors.dark_gray, filler_char = u'◯'):
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
sys.stdout.write('{\"version\":1}\n')
sys.stdout.write('[')
frame = 0
parts = [CpuPart(), MemoryPart(), VolumePart(), BatteryPart(), BrightnessPart(), DateTimePart()]
while True:
    parts_rendered = []
    for part in parts:
        for subpart in part.render(frame):
            parts_rendered.append(subpart)
    for part in parts_rendered:
        if not 'separator_block_width' in part:
            part['separator_block_width'] = 25
        if not 'separator' in part:
            part['separator'] = False
    sys.stdout.write(json.dumps(parts_rendered))
    sys.stdout.write(',\n')
    sys.stdout.flush()
    sleep(0.2)
    frame = frame + 1
