{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "v0.60.0";
  rev = "1a0325014f02d30f55b68420af9d4cd4091d7191";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    inherit rev;
    sha256 = "15qy6g2qgd96jf8jgqcbz4qgi3767vpdq6whrx4bjhag4vy9s0kw";
    fetchSubmodules = true;
  };

  cargoSha256 = "1044ch600g2294qd2n22lb8khg5x31ihpbfakaxhlbc8bqir4953";

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ]
  ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  doCheck = false; # https://github.com/bytecodealliance/wasmtime/issues/1197

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = https://github.com/CraneStation/wasmtime;
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
