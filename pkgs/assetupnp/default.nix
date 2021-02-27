{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "assetupnp";
  version = "7.2";

  src = fetchurl {
    url = "https://www.dbpoweramp.com/install/AssetUPnP-Linux-x64.tar.gz";
    sha256 = "1khshiryra1l29xgdb2xcb0p4r63b0s2nr2dnp97l80fsv0w2aj0";
  };

  buildPhase = ":";
  installPhase = ''
    mkdir -p $out
    cp -R bin $out/bin
  '';
}
