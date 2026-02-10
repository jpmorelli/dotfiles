#!/bin/sh

# Fondo
swaybg -i /home/juan/Nextcloud/wallpapers/Landscape_jjforestbird_switzerLand.jpg -m fill &

# Notificaciones
dunst &

# Portapapeles
wl-paste --watch cliphist store &

# Compositor extra
# (Qtile WL ya maneja composición, pero esto ayuda a estabilidad)
gammastep -O 6500 &

