{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "dutree";
  version = "0.2.16";

  cargoSha256 = "0ahxil8v7sps3fn8hrryd9wq3npvk5m5x3sffscyw6l962crhnqx";

  src = fetchFromGitHub {
    owner = "nachoparker";
    repo = "dutree";
    rev = "83fc255965fb46c913a1c9b8be95c8b8e251c976";
    sha256 = "1sar1lv95z3apnpz2jry9ax7cvv64vj07ac84aqavwzc17szs97q";
  };
}
