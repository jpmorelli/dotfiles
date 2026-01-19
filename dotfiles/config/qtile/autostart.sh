#!/bin/sh

# Fondo
swaybg -i /usr/share/backgrounds/nord.jpg -m fill &

# Notificaciones
dunst &

# Portapapeles
wl-paste --watch cliphist store &

# Compositor extra
# (Qtile WL ya maneja composición, pero esto ayuda a estabilidad)
gammastep -O 6500 &

