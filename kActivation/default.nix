{
  stdenvNoCC,
  fetchzip,
  wine,
  autoPatchelfHook,
}:
stdenvNoCC.mkDerivation rec {
  pname = "kActivation";
  version = "4.1.3.50";
  src = fetchzip {
    url = "https://sd7.ascon.ru/Public/Utils/Guardant_SLK/kActivation/kActivation_${version}_API3.17.zip";
    hash = "sha256-WzikZ52ypoIDSRsDVDyQ0PaUY9fEqQoQZ0CQLlFvkQg=";
  };
  inherit wine;

  nativeBuildInputs = [autoPatchelfHook];

  dontBuild = true;
  installPhase = ''
    mkdir -p "$out/bin"
    install -m 755 "$src/kActivation.exe" "$out/bin"
    install -m 755 "$src/grdlic.dll" "$out/bin"

    substituteAll ${./kActivation.sh} kActivation
    install -m 755 kActivation $out/bin
  '';
}
