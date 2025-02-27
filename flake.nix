{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ...}: flake-utils.lib.eachDefaultSystem(system: 
    with import nixpkgs {inherit system;}; {
      packages.default = stdenv.mkDerivation (finalAttrs: {
        pname = "freedownloadmanager";
        version = "6.25.2";
      
        src = builtins.fetchurl "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
      
        nativeBuildInputs = [
          dpkg
          libxkbcommon
          libGL
          mysql80
          xorg.libX11
          xorg.libxcb
          egl-wayland
          libmysqlclient
          gst_all_1.gst-devtools
          gtk3
          libpq
          xorg.xcbutil
          xcb-util-cursor
          libpulseaudio
          unixODBC
          cairo
          pango
          autoPatchelfHook
          kdePackages.wrapQtAppsHook
          qt6.qtbase
          wrapGAppsHook
        ];

        
        runtimeDependencies = [
          (lib.getLib udev)
        ];


        installPhase = ''
          export tmp=$(mktemp -d)
          dpkg-deb -x $src $tmp
          mkdir $out
          cp -r $tmp/opt/freedownloadmanager/* $out
          patchelf $out/plugins/sqldrivers/libqsqlmimer.so --remove-needed libmimerapi.so
          cp -r $tmp/usr/share $out
          mkdir $out/bin
          ln -sf $out/fdm $out/bin/freedownloadmanager
        '';

        meta = {
          description = "Free Download Manager";
          homepage = "https://www.freedownloadmanager.org";
        };
      });
      fomatter = nixfmt-classic;
  });
}
