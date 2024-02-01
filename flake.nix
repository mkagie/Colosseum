{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        mkShell = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; };
      in
      {
        devShells = {
          default = mkShell {
            # packages = with pkgs; [
            #   cmake
            #   vulkan-loader
            #   lsb-release
            #   rsync
            #   wget
            #   clang
            #   unzip
            #   llvmPackages_latest.llvm
            # ];

            nativeBuildInputs = with pkgs; [
              cmake
              lsb-release
              rsync
              wget
              unzip
            ];

            buildInputs = with pkgs; [
              clang
              llvmPackages_latest.llvm
            ];

            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc pkgs.clangStdenv.cc.cc ];
          };
        };
      }
    );
}
