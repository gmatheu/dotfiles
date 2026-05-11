#!/bin/bash

ramp_load_0=""
ramp_load_1=""
ramp_load_2=""
ramp_load_4=""
ramp_load_6=""

bar_used_foreground_3=#55aa55
bar_used_foreground_2=#ffffff
bar_used_foreground_1=#f5a70a
bar_used_foreground_0=#ff5555

show_numbers='false'
function toggle() {
	if [[ $show_numbers = 'true' ]]; then
		show_numbers='false'
	else
		show_numbers='true'
	fi
	if [ "$sleep_pid" -ne 0 ]; then
		kill $sleep_pid >/dev/null 2>&1
	fi
}

colorize_value() {
	value=$1
	text=$2
	int_value=$(printf '%.*f\n' 0 "$value")
	relative_value=${int_value}
	if [[ $relative_value -lt 15 ]]; then
		echo -n "%{F${bar_used_foreground_0}}${text}%{F-}"
	elif [[ $relative_value -lt 25 ]]; then
		echo -n "%{F${bar_used_foreground_1}}${text}%{F-}"
	elif [[ $relative_value -lt 60 ]]; then
		echo -n "%{F${bar_used_foreground_2}}${text}%{F-}"
	else
		echo -n "%{F${bar_used_foreground_3}}${text}%{F-}"
	fi
}

graph_load() {
	int_value=$(printf '%.*f\n' 0 "$1")
	# relative_value=$((int_value * 100 / cpus))
	value=${int_value}
	if [[ $value -ge 0 && $value -lt 15 ]]; then
		echo -n $ramp_load_0
	elif [[ $value -lt 30 ]]; then
		echo -n $ramp_load_1
	elif [[ $value -lt 40 ]]; then
		echo -n $ramp_load_2
	elif [[ $value -lt 60 ]]; then
		echo -n $ramp_load_4
	elif [[ $value -ge 80 ]]; then
		echo -n $ramp_load_6
	fi
}

trap "toggle" USR1

sleep_pid=0
while true; do
	battery_level=$(upower -i "$(upower -e | grep '/battery')" | grep percentage | tr -s ' ' | cut -d ' ' -f 3 | tr -d '%')
	battery_status=$(upower -i "$(upower -e | grep '/battery')" | grep state | tr -s ' ' | cut -d ' ' -f 3)
	icon=''
	if [[ $battery_status = 'discharging' ]]; then
		icon=🔋
	elif [[ $battery_status = 'charging' ]]; then
		icon=⚡
	fi

	if [[ $show_numbers = 'true' ]]; then
		value=$(colorize_value "$battery_level"% "${battery_level}% $(graph_load "$battery_level") ${battery_status}")
		echo "${value} "
	else
		value=$(colorize_value "$battery_level" "$(graph_load "$battery_level") ${icon}")
		echo "${value} "
	fi
	sleep 120 &
	sleep_pid=$!
	wait
done
