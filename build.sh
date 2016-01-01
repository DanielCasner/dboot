#!/usr/bin/env bash
export PATH=/opt/xtensa-lx106-elf/bin:$PATH
SDK_BASE=

function genVersionFile {
  VersionFile=$1

  # build version file name
  if [ -z $VersionFile ]; then
    echo Need to specify version file name to generate.
    exit 1
  fi

  # Remove file if it exists
  if [ -f $VersionFile ]; then
    rm -f $VersionFile
  fi

  # find git
  GIT=`which git`
  if [ -z $GIT ]
  then
    echo git not found
    exit 1
  fi

  # Get git SHA-1
  Commit=`$GIT rev-parse --short HEAD`
  DasUser=`whoami`
  Date=`date +%Y-%m-%d..%H:%M`

  # Get just the name of the file
  fileName=$(basename $VersionFile)

  echo "static const unsigned int VERSION_COMMIT = 0x$Commit;" >> $VersionFile
  echo "static const char* USER = \"$DasUser\";"               >> $VersionFile
  echo "static const char* BUILD_DATE = \"$Date\";"            >> $VersionFile
}


if test ! -d build; then mkdir build; fi
genVersionFile build/version.h
make SDK_BASE=$SDK_BASE COMPILE=gcc
