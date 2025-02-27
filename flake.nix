{
  inputs = {
    nixpkgs.url = "gihub:NixOS/nixpkgs";
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
        ];

        phases = ["unpackPhase" "installPhase" "fixupPhase"];

        postUnpackPhase = ''
          dpkg-deb -x $src $out
          '';

        installPhase = ''
          '';
      
        meta = {
          description = "Free Download Manager";
          homepage = "https://www.freedownloadmanager.org";
        };
      });
  });
}
