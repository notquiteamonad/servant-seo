{
  description = "Development infrastructure for servant-seo";
  inputs = {
    nixpkgs-src.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    { nixpkgs-src
    , flake-utils
    , self
    , ...
    }:
    flake-utils.lib.eachSystem (with flake-utils.lib.system; [ x86_64-linux aarch64-linux ]) (system:
    let
      nixpkgs = nixpkgs-src.legacyPackages.${system};
      haskellPackages = nixpkgs.haskell.packages.ghc948;
      haskellEnv = haskellPackages.ghcWithPackages (pkgs: with pkgs; [ cabal-install haskell-language-server ]);
    in
    {
      devShell = self.devShells.${system}.default;
      devShells.default = nixpkgs.mkShell {
        buildInputs = [ haskellEnv ];
      };
    });
}
