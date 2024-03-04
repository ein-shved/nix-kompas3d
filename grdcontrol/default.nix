{
  stdenvNoCC,
  fetchurl,
  system,
  autoPatchelfHook,
}:
stdenvNoCC.mkDerivation rec {
  pname = "grdcontrol";
  version = "3.25";
  src = fetchurl {
    url = "https://download.guardant.ru/Guardant_Control_Center/${version}/grdcontrol-${version}.tar.gz";
    hash = "sha256-2Xqvv3eij88lN7wmH606CrxR8JTsD5pi6jfUxwCWODY=";
  };
  inherit system;

  nativeBuildInputs = [autoPatchelfHook];

  dontBuild = true;
  installPhase = ''
    if [[ "$system" == *"x86_64"* ]]; then
        param="x86_64";
    elif [[ $processor == *"86"* ]]; then
        param="x86";
    else
        param="arm";
    fi

    mkdir -p "$out/opt/guardant/grdcontrol/"

    install -m 755 ./$param/grdcontrold $out/opt/guardant/grdcontrol

    #copy properties file
    install -m 644 ./grdcontrold.properties $out/opt/guardant/grdcontrol

    #copy www folder
    cp -r  ./www $out/opt/guardant/grdcontrol/

    # TODO(Shvedov): install udev rules
  '';
}
