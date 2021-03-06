{ stdenv, lib, fetchurl, autoPatchelfHook, dpkg, wrapGAppsHook, nixosTests
, gnome2, gtk3, atk, at-spi2-atk, cairo, pango, gdk-pixbuf, glib, freetype, fontconfig
, dbus, libX11, xorg, libXi, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver, nss, nspr, alsaLib
, cups, expat, libuuid, at-spi2-core, libappindicator-gtk3, mesa
# Runtime dependencies:
, systemd, libnotify, libdbusmenu, libpulseaudio
# Unfortunately this also overwrites the UI language (not just the spell
# checking language!):
, hunspellDicts, spellcheckerLanguage ? null # E.g. "de_DE"
# For a full list of available languages:
# $ cat pkgs/development/libraries/hunspell/dictionaries.nix | grep "dictFileName =" | awk '{ print $3 }'
, undmg
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  pname = "signal-desktop";

  customLanguageWrapperArgs = (with lib;
    let
      # E.g. "de_DE" -> "de-de" (spellcheckerLanguage -> hunspellDict)
      spellLangComponents = splitString "_" spellcheckerLanguage;
      hunspellDict = elemAt spellLangComponents 0 + "-" + toLower (elemAt spellLangComponents 1);
    in if spellcheckerLanguage != null
       then ''
        --set HUNSPELL_DICTIONARIES "${hunspellDicts.${hunspellDict}}/share/hunspell" \
        --set LC_MESSAGES "${spellcheckerLanguage}"''
       else "");

  x86_64-darwin-version = "5.0.0";
  x86_64-darwin-sha256 = "09ag5mmpx7vqz5dg2fd89sgj6y89q4kin7rnn5zjsbyig6m6xp0y";

  aarch64-darwin-version = "5.3.0";
  aarch64-darwin-sha256 = lib.fakeSha256;

  x86_64-linux-version = "5.0.0";
  x86_64-linux-sha256 = "17hxg61m9kk1kph6ifqy6507kzx5hi6yafr2mj8n0a6c39vc8f9g";

  version = {
    aarch64-darwin = aarch64-darwin-version;
    x86_64-darwin = x86_64-darwin-version;
    x86_64-linux = x86_64-linux-version;
  }.${system} or throwSystem;

  src = {
    x86_64-darwin = fetchurl {
      url = "https://updates.signal.org/desktop/signal-desktop-mac-${version}.dmg";
      sha256 = x86_64-darwin-sha256;
    };
    x86_64-linux = fetchurl {
      url = "https://updates.signal.org/desktop/apt/pool/main/s/signal-desktop/signal-desktop_${version}_amd64.deb";
      sha256 = x86_64-linux-sha256;
    };
  }.${system} or throwSystem;

  meta = {
    description = "Private, simple, and secure messenger";
    longDescription = ''
      Signal Desktop is an Electron application that links with your
      "Signal Android" or "Signal iOS" app.
    '';
    homepage    = "https://signal.org/";
    changelog   = "https://github.com/signalapp/Signal-Desktop/releases/tag/v${version}";
    license     = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ixmatus primeos equirosa ];
    platforms   = [ "x86_64-linux" "x86_64-darwin" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit version src meta pname;
    # Please backport all updates to the stable channel.
    # All releases have a limited lifetime and "expire" 90 days after the release.
    # When releases "expire" the application becomes unusable until an update is
    # applied. The expiration date for the current release can be extracted with:
    # $ grep -a "^{\"buildExpiration" "${signal-desktop}/lib/Signal/resources/app.asar"
    # (Alternatively we could try to patch the asar archive, but that requires a
    # few additional steps and might not be the best idea.)

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      wrapGAppsHook
    ];

    buildInputs = [
      alsaLib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gnome2.GConf
      gtk3
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libXdamage
      libXext
      libXfixes
      libXi
      libXrandr
      libXrender
      libXtst
      libappindicator-gtk3
      libnotify
      libuuid
      mesa # for libgbm
      nspr
      nss
      pango
      systemd
      xorg.libxcb
    ];

    runtimeDependencies = [
      (lib.getLib systemd)
      libnotify
      libdbusmenu
    ];

    unpackPhase = "dpkg-deb -x $src .";

    dontBuild = true;
    dontConfigure = true;
    dontPatchELF = true;
    # We need to run autoPatchelf manually with the "no-recurse" option, see
    # https://github.com/NixOS/nixpkgs/pull/78413 for the reasons.
    dontAutoPatchelf = true;

    installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    mv usr/share $out/share
    mv opt/Signal $out/lib/Signal

    # Note: The following path contains bundled libraries:
    # $out/lib/Signal/resources/app.asar.unpacked/node_modules/sharp/vendor/lib/
    # We run autoPatchelf with the "no-recurse" option to avoid picking those
    # up, but resources/app.asar still requires them.

    # Symlink to bin
    mkdir -p $out/bin
    ln -s $out/lib/Signal/signal-desktop $out/bin/signal-desktop

    runHook postInstall
  '';

    preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc ] }"
      ${customLanguageWrapperArgs}
                   )

    # Fix the desktop link
    substituteInPlace $out/share/applications/signal-desktop.desktop \
      --replace /opt/Signal/signal-desktop $out/bin/signal-desktop

    autoPatchelf --no-recurse -- $out/lib/Signal/
    patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/Signal/resources/app.asar.unpacked/node_modules/ringrtc/build/linux/libringrtc.node
  '';

    # Tests if the application launches and waits for "Link your phone to Signal Desktop":
    passthru.tests.application-launch = nixosTests.signal-desktop;
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Signal.app";

    installPhase = ''
      mkdir -p $out/Applications/Signal.app
      cp -R . $out/Applications/Signal.app
    '';
  };

in if stdenv.isDarwin
   then darwin
   else linux
