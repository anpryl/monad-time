{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, mtl, stdenv, time }:
      mkDerivation {
        pname = "monad-time";
        version = "0.3.1.0";
        src = ./.;
        libraryHaskellDepends = [ base mtl time ];
        testHaskellDepends = [ base mtl time ];
        homepage = "https://github.com/scrive/monad-time";
        description = "Type class for monads which carry the notion of the current time";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
