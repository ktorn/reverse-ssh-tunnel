#!/bin/bash
# Establishes a persistent outgoing SSH connection with reverse port forwarding.
# This allows remote connections to a host behind local network's NAT.
# Disconnections will be gracefully handled by autossh, reconnecting as required.
# Requires: autossh
#
# It establishes an SSH connection to REMOTE_HOST, binding REMOTE_HOST_TUNNEL_PORT to
# LOCAL_HOST's LOCAL_HOST_TUNNEL_PORT.
#
# Note: In order to bind the reverse port to all interfaces in REMOTE_HOST,
#       you may need to add 'GatewayPorts yes' to the sshd configuration of REMOTE_HOST.
#       Also, LOCAL_HOST is the target host as seen by the host you run this script from,
#       and can either be localhost itself, or any other host accessible by it.
#
# Default configuration forwards REMOTE_HOST port 2222 to LOCAL_HOST port 22.
#
# Copyright (C) 2015-2016 Filipe Farinha - All Rights Reserved
# Permission to copy and modify is granted under the GPLv3 license
# Last revised 14/02/2018

LOCAL_HOST=localhost
LOCAL_HOST_TUNNEL_PORT=22

REMOTE_HOST=remotehost.example.net
REMOTE_HOST_SSH_PORT=22
REMOTE_HOST_SSH_USER=myusername

REMOTE_HOST_TUNNEL_PORT=2222

# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 0.0.0.0:$REMOTE_HOST_TUNNEL_PORT:$LOCAL_HOST:$LOCAL_HOST_TUNNEL_PORT -p$REMOTE_HOST_SSH_PORT $REMOTE_HOST_SSH_USER@$REMOTE_HOST
