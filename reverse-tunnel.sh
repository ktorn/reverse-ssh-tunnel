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
# 2) binds REMOTE_HOST_TUNNEL_PORT in REMOTE_HOST;
# 3) forwards incoming connections to REMOTE_HOST_TUNNEL_PORT to
#    LOCAL_HOST_TUNNEL_PORT in LOCAL_HOST.
#
# Note: In order to bind REMOTE_HOST_TUNNEL_PORT to all interfaces in REMOTE_HOST,
#       you may need to add 'GatewayPorts yes' to the sshd configuration of REMOTE_HOST.
#       Failing to do this may result in the tunnel refusing external connections.
#       Also, LOCAL_HOST is relative to the host where you run this script from,
#       and can either be `localhost` itself, or any other host accessible by it.
#
# Copyright (C) 2015-2016 Filipe Farinha - All Rights Reserved
# Permission to copy and modify is granted under the GPLv3 license
# Last revised 14/02/2018

# Default configuration forwards REMOTE_HOST port 8888 to LOCAL_HOST port 80.

# The remote host that we connect to via SSH, and establish the listening remote port
REMOTE_HOST=remotehost.example.net
REMOTE_HOST_SSH_PORT=22
REMOTE_HOST_SSH_USER=myusername
REMOTE_HOST_TUNNEL_PORT=8888

# The local host is the destination of traffic received by the remote port
LOCAL_HOST=localhost
LOCAL_HOST_TUNNEL_PORT=80

# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 0.0.0.0:$REMOTE_HOST_TUNNEL_PORT:$LOCAL_HOST:$LOCAL_HOST_TUNNEL_PORT -p$REMOTE_HOST_SSH_PORT $REMOTE_HOST_SSH_USER@$REMOTE_HOST
