#!/bin/bash

# usage:
# ./load.sh NUM_THREADS TEST_DURATION
# NUM_THREADS = number of background threads each setting up/tearing down tunnels
# as fast as possible
#
# TEST_DURATION = how long to run the test for in seconds
#
# eg: ./load.sh 1000 300
# for 1000 background threads running for 5 min

set -e

tryrun () {
  end=$((SECONDS+$2))
  while [ $SECONDS -lt $end ]; do
    rm -f "/tmp/ngrok/$1"
    # run in background and redirect stdout and stderr to /tmp/ngrok/run_num
    ngrok service run --config "ngrok/ngrok$1.conf" > "/tmp/ngrok/$1" 2>&1 &
    pid=$!
    sleep 0.1
    # wait for stuff to be written to log file
    while [ ! -f "/tmp/ngrok/$1" ]; do
      sleep 0.1
    done
    # wait until tunnel created, timed out, or failed cuz port taken
    until grep "started tunnel\|DeadlineExceeded\|address already in use" "/tmp/ngrok/$1" > /dev/null;
    do
      sleep 0.1
    done
    # only kill if process still running
    if grep "started tunnel" "/tmp/ngrok/$1" > /dev/null;
    then
      kill $pid
    fi
  done
}

mkdir -p ngrok
mkdir -p /tmp/ngrok
# set up one unique ngrok.conf per each background thread
cat /etc/ngrok.conf | head -n 13 | grep -v ' addr\|subdomain' > ngrok.conf
for i in $(seq 1 $1)
do
        port=$(expr $i + 30000)
        cp ngrok.conf "ngrok/ngrok$port.conf"
        echo "    addr: $port" >> "ngrok/ngrok$port.conf"
        echo "    subdomain: test$port" >> "ngrok/ngrok$port.conf"
        echo "web_addr: localhost:$(expr $port + 1000)" >> "ngrok/ngrok$port.conf"
done
for i in $(seq 1 $1)
do
        port=$(expr $i + 30000)
        tryrun $port $2 &
done

