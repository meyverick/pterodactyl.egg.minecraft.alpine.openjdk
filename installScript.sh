# Author: Meyverick
# Contact: https://beacons.ai/meyverick
# .
# Created Date: 2022-08-17 21:28:48+02:00
# Last Modified: 2022-09-13 18:14:01+02:00
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

# Install requirements.
apk add --no-cache curl jq

# Wipe user folder.
cd /mnt/server
rm -fr *
rm -fr .*

# Create .pteroignore.
>.pteroignore
chown container .pteroignore

curl -s $(curl -s "https://launchermeta.mojang.com/mc/game/version_manifest.json" | jq -r ".latest.release as \$v | .versions[] | select(.id == \$v) | .url") | jq -r ".downloads.server.url" | xargs wget -O server.jar
chown container server.jar
 
print "Server installed and ready to be started."