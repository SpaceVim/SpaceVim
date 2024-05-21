{
  description = "Quickstart configurations for the Nvim LSP client";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.stylua
            pkgs.luaPackages.luacheck
            pkgs.luajitPackages.vusted
            pkgs.selene
          ];
        };
      }
    );
}
