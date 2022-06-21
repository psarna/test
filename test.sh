#!/bin/bash

function echo_color() {
    local color=$1
    shift
    echo -e "\e[${color}m$@\e[0m"
}

function run_case() {
    local input=$1
    local output="$input.out"
    local smp=$2
    local mem=$3
    local time_limit=$4
    echo_color '1;34' "Test case $input --smp $smp -m $mem [timeout: ${time_limit}s]"
    /usr/bin/time -f '%E' timeout -skill $time_limit ./run.sh $input $output $smp $mem
    status=$?
    if [ $status -eq 0 ]; then
        if diff $output ${output}.ref; then
            echo_color 32 "[OK]"
        else
            echo_color 31 "[INCORRECT OUTPUT]"
        fi
    elif [ $status -eq 137 ]; then
        echo_color 31 "[TIMEOUT]"
    else
        echo_color 31 "[ERROR] code: $status"
    fi
}

for smp in 2 4; do
    for mem in 1G 4G; do
        for test_case in 2 4 8 16; do
            run_case $test_case $smp $mem $(bc -l <<< "t = 20*($test_case*l($test_case))/1; scale = 0; t/1")
        done
    done
done
