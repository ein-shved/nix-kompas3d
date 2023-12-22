{ lib
, writeShellApplication
, wineWowPackages
, winetricks
, p7zip
, makeDesktopItem
, symlinkJoin
, version ? "22"
}:
let
  script = writeShellApplication rec {
    name = "kompas3d";
    runtimeInputs = [ winetricks wineWowPackages.stable p7zip ];
    text = ''

    # shellcheck disable=SC1091
    source ${./install.sh}

    set -e
    VERSION=${version}
    WINEPREFIX="$HOME/.local/share/wine_kompas3d-$VERSION"
    KHOME="$WINEPREFIX/drive_c/Program Files/ASCON/KOMPAS-3D v$VERSION Home/Bin/kHome.exe"
    CLEAR=0
    LEFT_UNPACK=0
    KOMPAS_ISO=

    usage() {
      echo "Usage: $(basename "$0") [-i KOMPAS_3D_ISO] [-w WINEPREFIX] [-cnh]"
      echo "  Calling without any flags will run previously installed instance"
      echo "  Calling with -i will run an installation first"
      echo
      echo "  -i  KOMPAS_3D_ISO   run installation with specified iso image"
      echo "  -w  WINEPREFIX      change default wineprefix [$WINEPREFIX]"
      echo "  -c                  clear prefix before installation"
      echo "  -n                  do not remove unpacked image files after installation"
      echo "  -h                  show this and exit"
      exit
    }

    while getopts 'w:i:cnh' opt; do
      case $opt in
      w) WINEPREFIX="$OPTARG" ;;
      i) KOMPAS_ISO="$OPTARG" ;;
      c) CLEAR=1 ;;
      n) LEFT_UNPACK=1 ;;
      h) usage ;;
      ?) usage ;;
      esac
    done

    if [ -n "$KOMPAS_ISO" ]; then
      install_kompas "$WINEPREFIX" "$KOMPAS_ISO" $CLEAR $LEFT_UNPACK
    elif [ ! -f "$KHOME" ]; then
      echo "Please run $0 with '-i KOMPAS_3D_ISO' first for wineprefix '$WINEPREFIX'"
      exit 1;
    fi

    export WINEPREFIX
    export WINEARCH=win64
    export WINEDLLOVERRIDES=winemenubuilder.exe=d

    exec wine64 "$KHOME"
  '';
  };
  desktopItem = makeDesktopItem {
    name = "kompas3d";
    desktopName = "Kompas 3D";
    exec = "${script}/bin/kompas3d";
    terminal = false;
    icon = ./6030_kHome.0.png;
  };
in
symlinkJoin { name = "kompas3d"; paths = [ script desktopItem ]; }
