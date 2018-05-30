#!/usr/bin/env bash
set -e
. ./envvars.sh

./updatespur64image.sh "$@"

. ./getGoodSpur64VM.sh

echo $VM $BASE.image BuildSqueakSpurTrunkVMMakerImage.st
$VM -headless $BASE.image BuildSqueakSpurTrunkVMMakerImage.st
