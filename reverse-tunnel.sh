#!/bin/bash
# Establish a persistent reverse SSH tunnel to a remote host.
# This allows remote SSH connections to a host behind a NAT router.
# Disconnections will be gracefully handled by autossh, reconnecting as required.
# Requires: autossh
# Copyright (C) 2015 Filipe Farinha - All Rights Reserved
# Permission to copy and modify is granted under the GPLv3 license
# Last revised 05/05/2015

LOCAL_SSH_HOST=localhost
LOCAL_SSH_PORT=22

REMOTE_SSH_HOST=remotehost.example.net
REMOTE_SSH_HOST_PORT=22
REMOTE_SSH_HOST_USER=myusername

REMOTE_REVERSE_PORT=2222

# Ignore early failed connections at boot
export AUTOSSH_GATETIME=0

autossh -4 -M 0 -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -R 0.0.0.0:$REMOTE_REVERSE_PORT:$LOCAL_SSH_HOST:$LOCAL_SSH_PORT -p$REMOTE_SSH_HOST_PORT $REMOTE_SSH_HOST_USER@$REMOTE_SSH_HOST

