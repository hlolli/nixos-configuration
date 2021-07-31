{ lib, stdenv, pkgs, fetchFromGitHub, clojure, joker,
  watchexec, runtimeShell, Foundation, zlib, makeWrapper, ... }:

let cljdeps = import ./goku.deps.nix { inherit pkgs; };
    classp = cljdeps.makeClasspaths {};
    # clojureGraal = clojure.override { jdk = graalvm; };

in stdenv.mkDerivation rec {
  name = "goku";
  version = "0.3.11";

  buildInputs = [ clojure Foundation zlib makeWrapper ];

  src = fetchFromGitHub {
    owner = "yqrashawn";
    repo = "GokuRakuJoudo";
    rev = "v${version}";
    sha256 = "0j9lk194a4fva866c3q6nhblcb9zfl6nz0gb6zymnsalkp56pfzn";
  };

  patchPhase = ''
    substituteInPlace src/karabiner_configurator/core.clj \
      --replace 'shell/sh joker-bin' 'shell/sh "${joker}/bin/joker"'
  '';

  buildPhase = ''
    HOME=$(pwd) \
    clojure \
      -Scp 'src:${classp}' \
      -M src/karabiner_configurator/core.clj
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/goku
    cp -R ./* $out/lib/goku
    makeWrapper ${clojure}/bin/clojure $out/bin/goku \
      --add-flags "-Scp $out/lib/goku/src:${classp} -m karabiner-configurator.core"

    # https://github.com/yqrashawn/GokuRakuJoudo/blob/a9016fe1ffd700365b1929a87a15c90132903640/.github/workflows/build-and-release.yaml#L34-L38
    touch $out/bin/gokuw
    echo "#!${runtimeShell}" >> $out/bin/gokuw
    echo '${watchexec}/bin/watchexec -r -w `[[ -z $GOKU_EDN_CONFIG_FILE ]] && echo ~/.config/karabiner.edn || echo $GOKU_EDN_CONFIG_FILE`' \
          $out/bin/goku >> $out/bin/gokuw
    chmod +x $out/bin/gokuw
  '';

  meta = with pkgs.lib; {
    description = "Karabiner configurator";
    homepage = "https://github.com/yqrashawn/GokuRakuJoudo";
    license = licenses.gpl3;
    maintainers = [ maintainers.nikitavoloboev maintainers.hlolli ];
    platforms = platforms.darwin;
  };
}
