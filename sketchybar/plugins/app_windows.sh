#!/bin/sh

# Remove existing dynamic app items before rebuilding
sketchybar --remove '/app\..*/'

# Query yabai for all visible windows, deduplicate by app name
yabai -m query --windows 2>/dev/null | python3 -c "
import sys, json, subprocess

windows = json.load(sys.stdin)

apps = {}
for w in windows:
    app = w.get('app', '')
    if not app or w.get('is-minimized', False) or w.get('is-hidden', False):
        continue
    if app not in apps:
        apps[app] = {'focused': False}
    if w.get('has-focus', False):
        apps[app]['focused'] = True

args = []
for app_name, info in apps.items():
    safe = app_name.lower().replace(' ', '-').replace('.', '-')
    color  = '0xffffffff' if info['focused'] else '0x88ffffff'
    weight = 'Semibold'  if info['focused'] else 'Regular'
    args += [
        '--add', 'item', f'app.{safe}', 'center',
        '--set', f'app.{safe}',
          f'label={app_name}',
          f'label.font=.SF NS:{weight}:13.0',
          f'label.color={color}',
          'icon.drawing=off',
          'padding_left=6',
          'padding_right=6',
          f'click_script=open -a \"{app_name}\"',
    ]

if args:
    subprocess.run(['sketchybar'] + args)
" 2>/dev/null
