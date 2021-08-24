#!/usr/bin/env bash

wait_for_status(){
    local status=$1
    local query=$2
    local nbTries=$3
    local maxTries=$((120))
    local sleepTime=$((2))

    if [ -z "$nbTries" ]; then nbTries=0 ; fi

    if [ $nbTries -gt $maxTries ]
    then
        echo Tried $maxTries to get see if the status is $status, exiting...
        exit -1
    fi

    pod_status=$($query)
    echo Status is $pod_status, expecting $status ...

    if [ "$pod_status" = "$status" ]
    then
        echo "OK"
    else
        nbTries=$(($nbTries + 1))
        sleep $sleepTime
        wait_for_status "$status" $query $nbTries
    fi
}
