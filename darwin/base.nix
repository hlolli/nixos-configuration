{ nixpkgs, darwin, ... }:
let
  systems = [ "x86_64-darwin" "aarch64-darwin" ];
  forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

  # Memoize nixpkgs for different platforms for efficiency.
  nixpkgsFor = forAllSystems (system:
    import nixpkgs {
      inherit system;
      # overlays = [ self.overlay ];
    }
  );

in {
  environment.systemPackages = forAllSystems (system:
    {
    with nixpkgsFor.${system};
    [
      hello
    ]
  );
}
