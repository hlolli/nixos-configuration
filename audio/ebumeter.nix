{ stdenv, fetchurl, libclxclient, libclthreads,
  libjack2, libsndfile, libX11, libXft,
  zita-resampler }:

stdenv.mkDerivation rec {
  version = "0.4.2";
  pname = "ebumeter";
  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/ebumeter-0.4.2.tar.bz2";
    sha256 = "1wm9j1phmpicrp7jdsvdbc3mghdd92l61yl9qbps0brq2ljjyd5s";
  };

  buildInputs = [
    libclxclient libclthreads libsndfile
    libXft libX11 libjack2 zita-resampler ];

  buildPhase = ''
    cd source
    export PREFIX=$out
    make && make install
  '';
}
