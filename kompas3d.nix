{
  lib,
  writeShellApplication,
  wineWowPackages,
  winetricks,
  p7zip,
  unzip,
  file,
  makeDesktopItem,
  symlinkJoin,
  kActivation,
  runCommand,
  version ? "22",
}: let
  script = writeShellApplication rec {
    name = "kompas3d";
    runtimeInputs = [
      winetricks
      wineWowPackages.stable
      p7zip
      unzip
      file
      (kActivation.override {wine = wineWowPackages.stable;})
    ];
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
      ACTIVATE=
      KOMPAS_UPDATER=

      usage() {
        echo "Usage: $(basename "$0") [-i KOMPAS_3D_ISO] [-w WINEPREFIX] [-acnh]"
        echo "  Calling without any flags will run previously installed instance"
        echo "  Calling with -i will run an installation first"
        echo
        echo "  -i  KOMPAS_3D_ISO   run installation with specified iso image"
        echo "  -u  KOMPAS_UPDATE   update kompas with zip file"
        echo "  -w  WINEPREFIX      change default wineprefix [$WINEPREFIX]"
        echo "  -a                  run licance activator instead of CAD"
        echo "  -c                  clear prefix before installation"
        echo "  -n                  do not remove unpacked image files after installation"
        echo "  -h                  show this and exit"
        exit
      }

      while getopts 'w:i:u:acnh' opt; do
        case $opt in
        w) WINEPREFIX="$OPTARG" ;;
        i) KOMPAS_ISO="$OPTARG" ;;
        u) KOMPAS_UPDATER="$OPTARG" ;;
        a) ACTIVATE=1 ;;
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
      if [ -n "$KOMPAS_UPDATER" ]; then
        update_kompas "$WINEPREFIX" "$KOMPAS_UPDATER" $LEFT_UNPACK
      fi

      export WINEPREFIX
      export WINEARCH=win64
      export WINEDLLOVERRIDES=winemenubuilder.exe=d

      if [ -n "$ACTIVATE" ]; then
        exec kActivation
      else
        exec wine64 "$KHOME"
      fi
    '';
  };
  icon = runCommand "kompas3d-icon" {} ''
    mkdir -p "$out/share/pixmaps/"
    install -Dm644  ${./6030_kHome.0.png} "$out/share/pixmaps/kHome.png"
  '';
  desktopItem = makeDesktopItem {
    name = "kompas3d";
    desktopName = "Kompas 3D";
    exec = "${script}/bin/kompas3d";
    terminal = false;
    icon = "kHome";
  };
in
  symlinkJoin {
    name = "kompas3d";
    paths = [script desktopItem icon];
  }
