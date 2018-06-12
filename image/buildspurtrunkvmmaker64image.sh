#!/usr/bin/env bash
set -e
. ./envvars.sh

./updatespur64image.sh "$@"

. ./getGoodSpur64VM.sh

echo $VM $BASE64.image BuildSqueakSpurTrunkVMMakerImage.st
$VM $BASE64.image BuildSqueakSpurTrunkVMMakerImage.st
