#!/bin/bash

# Install Q100 Receiver on Raspberry Pi 4
# Orignal design by Michael, EA7KIR

# updated to GO 1.22 on March 2 2024

GOVERSION=1.22.2

echo Installing Go $GOVERSION
GOFILE=go$GOVERSION.linux-arm64.tar.gz
cd /usr/local
sudo wget https://go.dev/dl/$GOFILE
sudo tar -C /usr/local -xzf $GOFILE
cd

