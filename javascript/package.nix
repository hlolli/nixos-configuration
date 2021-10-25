{
  dependencies = {
    prettier = {
      version = "^2.4.1";
      postInstall = pkgs: ''
        mkdir -p $out/bin
        ln -s $out/lib/node_modules/prettier/bin-prettier.js $out/bin/prettier
      '';
    };
    typescript = "latest";
  };
}
