#!/bin/bash -e
TODAY=$(date +%Y%m%d)
MODULE=$1
SRC_DIR="/var/log/$MODULE"
DEST_DIR="/var/log/backup"

test -n "$MODULE" || { echo "USAGE: $0 MODULE"; exit; }
test -d "$SRC_DIR" || { echo "log dir $SRC_DIR does not exist."; exit; }
mkdir -p "$DEST_DIR"
ln -s "$DEST_DIR" "${SRC_DIR}/OLD"
cd "$SRC_DIR"

# gzip java logs
find . -maxdepth 1 -type f -name '*.log.*' -not -name '*.gz' -not -name '*.current' -print0 | xargs -0 gzip

# move old zipped log to backup dir
find . -maxdepth 1 -type f -name '*.gz' -mtime +7 -print0 | xargs -0 -I{} mv {} ${DEST_DIR}/${MODULE}-{}
