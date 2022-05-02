if xrandr | grep 'HDMI-A-0 connected'
then
    xrandr --output eDP --primary --auto --output HDMI-A-0 --auto --dpi 96 --right-of eDP
fi