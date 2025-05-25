{ nixpkgs, src, dmg-control }:
let pkgs = import nixpkgs {
  system = "aarch64-darwin";
  overlays = [ dmg-control.overlay ];
}; in
with pkgs;
dmgInstaller {
  pname = "freedownloadmanager";
  filename = "FreeDownloadManager.app";
  version = "6.28";
  inherit src;
  meta = {
    description = " It's a powerful modern download accelerator and organizer for Windows, macOS, Android, and Linux.";
    mainProgram = "freedownloadmanager";
    license = lib.licenses.unfree;
    homepage = "https://www.freedownloadmanager.org";
    platforms = [ "aarch64-darwin" "x86_64-linux" ];
  };
}
