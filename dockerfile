# Author: Meyverick
# Contact: https://beacons.ai/meyverick
# .
# Created Date: 2022-08-17 21:28:48+02:00
# Last Modified: 2022-09-20 18:18:00+02:00
# .
# Copyright (c) 2022 Meyverick
# All rights reserved.
# This file is released under the MIT License.
# https://opensource.org/licenses/MIT



FROM alpine:latest

LABEL author="Meyverick" website="https://beacons.ai/meyverick" funding="https://ko-fi.com/meyverick" license="mit"

RUN apk add --no-cache iproute2 libstdc++ \
 && wget https://aka.ms/download-jdk/microsoft-jdk-17.0.4.1-alpine-x64.tar.gz -O /tmp/java.tar.gz \
 && mkdir -p /mnt/server \
 && mkdir -p /opt/java \
 && tar -zxvf /tmp/java.tar.gz -C /opt/java --strip-components 1 \
 && rm /tmp/java.tar.gz \

# Create user.
 && adduser --home /home/container --disabled-password container

# Set user.
ENV USER=container HOME=/home/container
USER $USER
WORKDIR $HOME

# Copy entrypoint.
COPY ./entrypoint.sh /

CMD ["/bin/sh", "/entrypoint.sh"]