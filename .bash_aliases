#
# ~/.bash_aliases
#

# General

## git
alias gs='git status -uno'

## bins
alias sc='~/bin/screencap'

## Chromecast Firewalls 
alias ccfwopen='sudo firewall-cmd --add-port=32768-61000/udp --add-port=5556/tcp --add-port=5558/tcp'
alias ccfwclose='sudo firewall-cmd --remove-port=32768-61000/udp --remove-port=5556/tcp --remove-port=5558/tcp'

## 4NEC2 in Wine
alias 4nec2='wine ~/.wine/drive_c/4nec2/exe/4nec2.exe'


# K4K

## Screen brightness

alias screendim='sudo tee /sys/class/backlight/intel_backlight/brightness <<< 150'
alias screenbright='sudo tee /sys/class/backlight/intel_backlight/brightness <<< 344'

