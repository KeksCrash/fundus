#!/bin/bash
sudo x11vnc -display :0 -auth /var/run/lightdm/root/:0 -rfbauth /home/kali/.vnc/passwd -forever -loop -noxdamage -repeat -bg -o /home/kali/x11vnc.log -rfbport 5900 
