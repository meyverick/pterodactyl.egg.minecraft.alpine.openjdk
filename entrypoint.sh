# Author: Meyverick
# Contact: https://beacons.ai/meyverick
# .
# Created Date: 2022-08-17 21:28:48+02:00
# Last Modified: 2022-09-20 18:46:11+02:00
# .
# Copyright (c) 2022 Meyverick
# All rights reserved.
# This file is released under the MIT License.
# https://opensource.org/licenses/MIT



#!/bin/sh

# Initialize function.
print() {
   echo -e "\e[1m\e[38;2;255;203;107mcontainer@pterodactyl~\e[0m $1"
}

cd /home/container

export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`
export PATH=$PATH:/opt/java/bin
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

## Ports
if [ -e server.properties ]; then
   sed -i "s/server-ip=.*/server-ip=0.0.0.0/g" server.properties
   sed -i "s/server-port=.*/server-port=$SERVER_PORT/g" server.properties
   sed -i "s/rcon.port=.*/rcon.port=$((SERVER_PORT + 1))/g" server.properties
   sed -i "s/query.port=.*/query.port=$((SERVER_PORT + 2))/g" server.properties
fi

## Run
if [ "$STARTUP_PARAMETERS" = "-suggested" ]; then
   RAM=$((SERVER_MEMORY-1536))
   NEW_SIZE_PERCENT=30
   MAX_NEW_SIZE_PERCENT=40
   HEAP_REGION_SIZE=8
   RESERVE_PERCENT=20
   INITIATING_HEAP_OCCUPANCY_PERCENT=15

   if [ $RAM -gt 12288 ]; then
      NEW_SIZE_PERCENT=40
      MAX_NEW_SIZE_PERCENT=50
      HEAP_REGION_SIZE=16
      RESERVE_PERCENT=15
      INITIATING_HEAP_OCCUPANCY_PERCENT=20
   fi

   print "Starting server with suggested startup parameters."
   java -Xms${RAM}M -Xmx${RAM}M -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=${NEW_SIZE_PERCENT} -XX:G1MaxNewSizePercent=${MAX_NEW_SIZE_PERCENT} -XX:G1HeapRegionSize=${HEAP_REGION_SIZE}M -XX:G1ReservePercent=${RESERVE_PERCENT} -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=${INITIATING_HEAP_OCCUPANCY_PERCENT} -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules jdk.incubator.vector -jar server.jar nogui
elif [ -z "$STARTUP_PARAMETERS" ]; then
   java -jar server.jar nogui
else
   java $STARTUP_PARAMETERS -jar server.jar nogui
fi