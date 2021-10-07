{
  description = "Quickstart configurations for the Nvim LSP client";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs { system = "x86_64-linux";};
    in {

    devShell."x86_64-linux" = pkgs.mkShell {

      buildInputs = [
        pkgs.stylua
        pkgs.luaPackages.luacheck
      ];
    };

  };
}
