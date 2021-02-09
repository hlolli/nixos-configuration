{ config, lib, pkgs, ... }:

let dutree = pkgs.callPackage ./unpublished/dutree.nix {};

in {
  config.environment.systemPackages = with pkgs; [
    bind
    cifs-utils
    convmv # <char-encoding fixer>
    dutree
    encfs
    ethtool
    file
    fontconfig
    fping
    gcc
    gdb
    git
    gnumake
    gnupg
    gnuplot
    gnutls
    htop
    iftop
    inetutils
    iotop
    killall
    libtool
    lld
    lshw
    lsof
    man-pages
    mercurial
    nfs-utils
    nmap
    ntfs3g
    openssl
    openvpn
    p7zip
    parallel
    patchelf
    pciutils
    pkgconfig
    pmtools
    pmutils
    pwgen
    reflex # <cli file-change detector>
    rlwrap
    service-wrapper
    smartmontools
    tcpdump
    tcpflow
    telnet
    tinc_pre
    tree
    udevil
    unzip
    upower
    usbutils
    valgrind
    wavemon
    wget

  ];
}
