#!/bin/bash
# [battery charge indicator](http://aaronlasseigne.com/2012/10/15/battery-life-in-the-land-of-tmux/)

NUMBER_SIGN='#'
UNDER_SCORE='_'

#if [[ `uname` == 'Linux' ]]; then
  #current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  #total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
#else
  #battery_info=`ioreg -rc AppleSmartBattery`
  #current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  #total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
#fi

#charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
charged_slots=$(echo "`cat /sys/class/power_supply/BAT0/capacity`/10" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt 10 ]]; then
  charged_slots=10
fi

echo -n '#[fg=red]'
for i in `seq 1 $charged_slots`; do echo -n "$NUMBER_SIGN"; done

if [[ $charged_slots -lt 10 ]]; then
  echo -n '#[fg=white]'
  for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$UNDER_SCORE"; done
fi
