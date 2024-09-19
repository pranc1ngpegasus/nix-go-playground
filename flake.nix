{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        checks = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra = {
              enable = true;
              entry = "alejandra .";
              files = "^.*\\.nix$";
              language = "system";
              pass_filenames = false;
            };
            golangci-lint = {
              enable = true;
              entry = "golangci-lint run ./...";
              files = "^.*\\.go$";
              language = "system";
              pass_filenames = false;
            };
            gotest = {
              enable = true;
              entry = "go test ./...";
              files = "^.*_test\\.go$";
              language = "system";
              pass_filenames = false;
            };
            govet = {
              enable = true;
              entry = "go vet ./...";
              files = "^.*\\.go$";
              language = "system";
              pass_filenames = false;
            };
          };
        };
      in {
        devShells.default = pkgs.stdenv.mkDerivation {
          name = "nix-go-playground";
          nativeBuildInputs = [];
          buildInputs = with pkgs; [
            go_1_23
            golangci-lint
            httpie
          ];
          shellHook = ''
            export PORT=8080
            export LOG_LEVEL=debug
            ${checks.shellHook}
          '';
        };
      }
    );
}
