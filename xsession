#!/bin/bash

xrdb -merge ~/.Xresourecs

xmodmap ~/.xmodmap
gnome-screensaver &

exec /usr/bin/xmonad

