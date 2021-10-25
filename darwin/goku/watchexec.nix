{ lib, stdenv, clang, rustPlatform, fetchFromGitHub, CoreServices, Foundation, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "watchexec";
    repo = "watchexec";
    rev = "110e1d4c96fce760c9f759d679a90136252f8f4e";
    sha256 =  "sha256-4ORStqEVE8jLJC4h82qG2ZPfnv4xmBs2ftWcISRlrd0=";
  };

  cargoSha256 = "sha256-aWD2lgI1O8UmOeAPzBKF5dighEqXcztzOwwNCuyLNqo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ clang CoreServices Foundation libiconv ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://watchexec.github.io/";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
  };
}
