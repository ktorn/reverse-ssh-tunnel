#!/bin/bash
#
# Requires: autossh
#
# Establishes a persistent outgoing SSH connection with reverse port forwarding.
# This allows connections to a remote (public) host to be forwarded to a host
# behind a NAT in the local network.
# Disconnections and re-connections will be gracefully handled by autossh. For this
# to work you should setup automatic authentication using SSH keys.
#
# It does the following:
# 1) Establishes an SSH connection to REMOTE_HOST;
# 2) binds one or more REMOTE_PORTs in REMOTE_HOST;
# 3) forwards incoming connections to LOCAL_PORTs in LOCAL_HOSTs
#
#
# Note: In order to bind REMOTE_PORTs to all interfaces in REMOTE_HOST,
#       you may need to add 'GatewayPorts yes' to the sshd configuration of REMOTE_HOST.
#       Failing to do this may result in the tunnel refusing external connections.
#       Also, LOCAL_HOST is relative to the host where you run this script from,
#       and can either be `localhost` itself, or any other host accessible by it.
#
# Default configuration forwards REMOTE_HOST port 8880 to LOCAL_HOST port 80 and
# REMOTE_HOST port 8443 to LOCAL_HOST port 443.
#
# Copyright (C) 2015-2019 Filipe Farinha - All Rights Reserved
# Permission to copy and modify is granted under the GPLv3 license
# Last revised 17/10/2019

# The remote host that we connect to via SSH, and establish the listening remote port(s)
REMOTE_HOST=remotehost.example.net
REMOTE_HOST_SSH_PORT=22
REMOTE_HOST_SSH_USER=myusername


# Define reverse port forwards
# Format: 'REMOTE_PORT:LOCAL_HOST:LOCAL_PORT' (where LOCAL_HOST can be actual localhost or any host acessible by localhost)
PORTS=(
     "8880:localhost:80"    # 8880 -> 80
     "8443:localhost:443"   # 8443 -> 443
    )


for PORT in ${PORTS[@]}
do   
  PORT_STR="$PORT_STR -R 0.0.0.0:$PORT"
done


# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes $PORT_STR -p$REMOTE_HOST_SSH_PORT $REMOTE_HOST_SSH_USER@$REMOTE_HOST
