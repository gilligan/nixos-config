{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "assetupnp";
  version = "7.3";
  src = ./AssetUPnP-Linux-x64-premium.tar.gz;

  buildPhase = ":";
  installPhase = ''
    mkdir -p $out
    cp -R bin $out/bin
  '';
}
