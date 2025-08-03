{ nixpkgs, src, ... }:
let
  pkgs = import nixpkgs { system = "x86_64-linux"; };
in
with pkgs;
stdenv.mkDerivation (finalAttrs: {
  pname = "freedownloadmanager";
  version = "6.28";

  inherit src;

  dontUnpack = true;

  nativeBuildInputs = [
    dpkg
    mysql80
    qt6.qtbase
    wrapGAppsHook
    libpulseaudio
    autoPatchelfHook
    gst_all_1.gst-devtools
    kdePackages.wrapQtAppsHook
    pipewire
  ];

  runtimeDependencies = [ (lib.getLib udev) ];

  installPhase = ''
    export tmp=$(mktemp -d)
    dpkg-deb -x $src $tmp
    mkdir $out
    cp -r $tmp/opt/freedownloadmanager/* $out
    patchelf $out/plugins/sqldrivers/libqsqlmimer.so --remove-needed libmimerapi.so
    cp -r $tmp/usr/share $out
    mkdir $out/bin
    ln -sf $out/fdm $out/bin/freedownloadmanager
    substituteInPlace $out/share/applications/freedownloadmanager.desktop\
      --replace "Exec=/opt/freedownloadmanager/fdm" "Exec=freedownloadmanager"\
      --replace "Icon=/opt/freedownloadmanager/icon.png" "Icon=$out/icon.png"
  '';

  meta = {
    description = "Free Download Manager";
    licenses = lib.licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
    homepage = "https://www.freedownloadmanager.org";
    maintainers = [ ];
  };
})
