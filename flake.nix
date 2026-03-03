{
  description = "Utopia Nix Development Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          f { inherit pkgs; }
        );
    in
    {
      devShells = forAllSystems (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            nativeBuildInputs = with pkgs; [
              act
              bun
              doppler
              gnupg
              sd
              typescript-language-server
              codebook
              vscode-langservers-extracted
              tailwindcss-language-server
              flyctl
              nodejs_20
              github-copilot-cli
              vtsls
            ];
            shellHook = ''
              export PATH=$(echo $PATH | sd "${pkgs.xcbuild.xcrun}/bin" "")
              unset DEVELOPER_DIR
            '';
          };
        }
      );
    };
}
