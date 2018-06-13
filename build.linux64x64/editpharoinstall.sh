#!/usr/bin/env bash
set -e
# Edit the installed directory tree to rename squeak to pharo and install source
INSTALLDIR="$1"

shift
cd $INSTALLDIR

if [ "$1" = -source ]; then
	SourceFile="$2"
	shift; shift
else
	SourceFile="PharoV60"
fi

#  try to use curl if possible
if [[ `which curl 2> /dev/null` ]]; then
	DOWNLOAD="curl --silent --location --compressed ";
	DOWNLOAD_TO="$DOWNLOAD --output ";
elif [[ `which wget 2> /dev/null` ]]; then
	DOWNLOAD_TO="wget --quiet --output-document=";
	DOWNLOAD="$DOWNLOAD_TO-";
else
	echo "Please install curl or wget on your machine";
	exit 1
fi

VERSION="61"
FILES_URL="http://files.pharo.org/get-files/${VERSION}"
SourceFile=PharoV60
if [ ! -f $SourceFile.sources ]
then
	$DOWNLOAD_TO sources.zip $FILES_URL/sources.zip
	unzip -q sources.zip
	rm -rf sources.zip
fi

SOURCE=$SourceFile.sources

if [ -f squeak ]; then
	mv squeak pharo
	sed -i 's/squeak/pharo/g' pharo
fi
if [ -f bin/squeak ]; then
	mv bin/squeak bin/pharo
	sed -i 's/squeak/pharo/g' bin/pharo
fi
rm -rf man doc
LIBDIR="`echo lib/squeak/[0-9.-]*`"
test -f $LIBDIR/squeak && mv $LIBDIR/squeak $LIBDIR/pharo
test -d lib/squeak && mv lib/squeak lib/pharo
LIBDIR="`echo lib/pharo/[0-9.-]*`"
if [ "$1" = -copysource ]; then
	cp $SOURCE $LIBDIR
elif [ -h $SOURCE ]; then
	ln "`readlink $SOURCE`" $LIBDIR
elif [ -f $SOURCE ]; then
	ln $SOURCE $LIBDIR
else
	echo "can't find `basename $SOURCE`" 1>&2
fi
