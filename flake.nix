{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    dmg-control.url = "gitlab:InvraNet/dmg-control-nix";
    linux-src = {
      url = "https://files2.freedownloadmanager.org/6/latest/freedownloadmanager.deb";
      flake = false;
    };
    darwin-src = {
      url = "https://files2.freedownloadmanager.org/6/latest/fdm.dmg";
      flake = false;
    };
  };

  outputs =
    {
      linux-src,
      darwin-src,
      nixpkgs,
      flake-utils,
      self,
      dmg-control,
    }:

    {
      packages = {
        x86_64-linux.default = import ./x86_64-linux.nix { inherit nixpkgs; src = linux-src; };
        aarch64-darwin.default = import ./aarch64-darwin.nix { inherit nixpkgs dmg-control; src = darwin-src; };
      };
      overlay = (
        _: old: {
          free-download-manager = self.packages.${old.system}.default;
        }
      );
    }
    // flake-utils.lib.eachDefaultSystem (
      system: with import nixpkgs { inherit system; }; {
        formatter = nixfmt-tree;
      }
    );
}
