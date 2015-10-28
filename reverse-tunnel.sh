#!/bin/bash
# Establishes a persistent outgoing SSH connection with reverse port forwarding.
# This allows remote connections to localhost or another host behind our NAT.
# Disconnections will be gracefully handled by autossh, reconnecting as required.
# Requires: autossh
#
# Note: In order to bind the reverse port to all interfaces in the remote host,
#       you may need to add 'GatewayPorts yes' to your sshd configuration.
#       Also, DESTINATION_HOST is the target host as seen by localhost, and can either
        be localhost itself, or any other host accessible by it.
#
# Copyright (C) 2015 Filipe Farinha - All Rights Reserved
# Permission to copy and modify is granted under the GPLv3 license
# Last revised 28/10/2015

DESTINATION_HOST=localhost
DESTINATION_PORT=22

REMOTE_SSH_HOST=remotehost.example.net
REMOTE_SSH_HOST_PORT=22
REMOTE_SSH_HOST_USER=myusername

REMOTE_REVERSE_PORT=2222

# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 0.0.0.0:$REMOTE_REVERSE_PORT:$DESTINATION_HOST:$DESTINATION_PORT -p$REMOTE_SSH_HOST_PORT $REMOTE_SSH_HOST_USER@$REMOTE_SSH_HOST

