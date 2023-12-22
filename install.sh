#!/bin/bash

unpack_iso() {
  KOMPAS_ISO="$1"
  MD5SUM="$(md5sum "$KOMPAS_ISO" | awk '{ print $1 }')"
  KOSMPAS_DIR="$WINEPREFIX/.source/$MD5SUM"
  if [ ! -f "$KOSMPAS_DIR/Setup.exe" ]; then
    rm -rf "$KOSMPAS_DIR"
    mkdir -p "$KOSMPAS_DIR"
    7z x "$KOMPAS_ISO" "-o$KOSMPAS_DIR"
  fi
}

install_kompas() {
  set -e

  WINEPREFIX="$1"
  KOMPAS_ISO="$2"
  CLEAR="$3"
  LEFT_UNPACK="$4"

  if [ "$CLEAR" -eq 1 ]; then
    eval rm -rf "$WINEPREFIX/*"
    rm -f "$WINEPREFIX/.update-timestamp"
  fi

  if [ -d "$KOMPAS_ISO" ]; then
    KOSMPAS_DIR="$KOMPAS_ISO"
  elif [ -f "$KOMPAS_ISO" ]; then
    unpack_iso "$KOMPAS_ISO"
  else
    echo "Invalid kompas installation source path '$KOMPAS_ISO'"
    return 1
  fi

  export WINEPREFIX
  export WINEARCH=win64
  export WINEDLLOVERRIDES=winemenubuilder.exe=d

  echo "Installing from $KOSMPAS_DIR to wineprefix $WINEPREFIX"

  if [ ! -e "$WINEPREFIX"/.update-timestamp ]; then
    echo "Prepareing prefix"
    sleep 2

    mkdir -p "$WINEPREFIX"

    winetricks -q dotnet48
    winetricks -q d3dcompiler_47
    winetricks -q msxml3 msxml4 msxml6
    winetricks -q corefonts
    winetricks -q vcrun2019 riched20

    echo "Prefix is ready. Launching Kompas3D installer"
  else
    echo "Prefix exists. Assume kompas was installed. Running setup to update existing installation"
  fi

  echo "You're better not to enable Ascon services. They consumes much cpu. Remove tick from 'participate in the support program' option"
  echo -n "You're better not to enable 'Materials and sortaments'. "
  echo "The kompas will not work at all. Remove corresponding tick in selective installation"
  sleep 2

  wine64 "$KOSMPAS_DIR/Setup.exe"

  echo "Congrats! Now you can use Kompas3D"

  if [ ! -d "$KOMPAS_ISO" ] && [ "$LEFT_UNPACK" -ne 1 ]; then
    rm -r "$KOSMPAS_DIR"
  fi
}
