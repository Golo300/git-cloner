{
  description = "A NixOS flake with GitPython";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      git-cloner= pkgs.python311Packages.buildPythonApplication {
        pname = "git-cloner";
        version = "0.1";
        doCheck = false;
        src = ./git-cloner;
        propagatedBuildInputs = with pkgs; [
            pkgs.python3Packages.gitpython
        ];
      };
    in
    {
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            pkgs.python3
            pkgs.python3Packages.gitpython
          ];
        };
      };
      packages.${system} = {
        default = pkgs.writeShellScriptBin "git-cloner" ''
          ${git-cloner}/bin/git-cloner.py "''${@:1}"
        '';
      };

    };
}

