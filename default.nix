{ pkgs ? import <nixpkgs> {} }:
let
  # We currently take all libraries from systemd and nix as the default
  # https://github.com/NixOS/nixpkgs/blob/c339c066b893e5683830ba870b1ccd3bbea88ece/nixos/modules/programs/nix-ld.nix#L44
  pythonldlibpath = pkgs.lib.makeLibraryPath (with pkgs; [
    zlib zstd stdenv.cc.cc curl openssl attr libssh bzip2 libxml2 acl libsodium util-linux xz systemd
  ]);
  # Darwin requires a different library path prefix
  wrapPrefix = if (!pkgs.stdenv.isDarwin) then "LD_LIBRARY_PATH" else "DYLD_LIBRARY_PATH";
  patchedpython = (pkgs.symlinkJoin {
    name = "python";
    paths = [ pkgs.python313Full ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/python3.13" --prefix ${wrapPrefix} : "${pythonldlibpath}"
    '';
  });
in pkgs.mkShell {
    packages = with pkgs; [
        patchedpython
        clingo
        clingcon
    ];

    # Create a venv with "python -m venv .venv" first
    shellHook = ''
        source .venv/bin/activate
    '';
    # Run "pip install -r requirements.txt" if necessary
}