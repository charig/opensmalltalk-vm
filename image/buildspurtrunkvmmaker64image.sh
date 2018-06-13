#!/usr/bin/env bash
set -e
. ./envvars.sh

if [ "$1" = "-headless" ]
then
 ARGS="$1"
else
 ARGS=""
fi

./updatespur64image.sh "$@"

source get64VMName.sh

echo $VM $BASE64.image BuildSqueakSpurTrunkVMMakerImage.st
$VM $ARGS $BASE64.image BuildSqueakSpurTrunkVMMakerImage.st
