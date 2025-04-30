{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    #TODO: Add support for more systems.
    flake-utils.lib.eachSystem (["x86_64-linux"]) (system:
      with import nixpkgs { inherit system; }; {
        packages.default = stdenv.mkDerivation (finalAttrs: {
          pname = "freedownloadmanager";
          version = "6.25.2";

          src = builtins.fetchurl {
            url =
              "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
            sha256 = "1gdlc3ln4sv47jj4jq0xaqjrrskpl1hcwmrrn6d4p18lxs00wf2i";
          };

          nativeBuildInputs = [
            dpkg
            mysql80
            qt6.qtbase
            wrapGAppsHook
            libpulseaudio
            autoPatchelfHook
            gst_all_1.gst-devtools
            kdePackages.wrapQtAppsHook
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
            platforms = [ "x86_64-linux" ];
            homepage = "https://www.freedownloadmanager.org";
            maintainers = [];
          };
        });
        formatter = nixfmt-classic;
      });
}
