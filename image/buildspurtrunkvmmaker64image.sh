#!/usr/bin/env bash
set -e
. ./envvars.sh

if [ "$1" = "-headless" ]
then
 ARGS="$1"
else
 ARGS=""
fi

./updatespur64image.sh "$ARGS"

source get64VMName.sh

echo $VM $BASE.image BuildSqueakSpurTrunkVMMakerImage.st
$VM $ARGS $BASE.image BuildSqueakSpurTrunkVMMakerImage.st
