#!/bin/bash

# A shell script designed to be executed by qBittorrent's "Run external program on torrent completion"
# This script will send a webhook notification
#
# An example how to fill in qBittorrent's "Run external program on torrent completion" to execute this script
# /bin/bash -c "chmod +x /path/to/qbittorrent-webhook-notify.sh; /path/to/qbittorrent-webhook-notify.sh '%N' 'Started' 'https://hooks.slack.com/services/XXXXXXXXX/YYYYYYYYY/ZZZZZZZZZZZZZZZZZZZZZZZZ'"
#
# Supported parameters (case sensitive):
# - %N: Torrent name
# - %L: Category
# - %G: Tags (separated by comma)
# - %F: Content path (same as root path for multifile torrent)
# - %R: Root path (first torrent subdirectory path)
# - %D: Save path
# - %C: Number of files
# - %Z: Torrent size (bytes)
# - %T: Current tracker
# - %I: Info hash

name="$1"
if [ -z "$name" ]; then 
    echo "ERROR: Expected <name> as the 1st argument but none given, <name> should be the Torrent name (\"%N\") from qBittorrent"
    exit 1
fi

status="$2"
if [ -z "$status" ]; then 
    echo "ERROR: Expected <status> as the 2nd argument but none given"
    exit 1
fi

webhook="$3"
if [ -z "$webhook" ]; then 
    echo "ERROR: Expected <webhook> as the 3rd argument but none given, <webhook> should be the incoming webhook"
    exit 1
fi

ts=`date "+%s"`

echo "Name:" $name
echo "status:" $status

/usr/bin/curl -sS \
    -X POST \
    -H 'Content-type: application/json' \
    -d "{ \"Name\":\"$name\", \"status\":\"$status\" }" \
    $webhook

