{
  description = "A NixOS flake with GitPython and a NixOS module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    git-cloner = pkgs.python311Packages.buildPythonApplication {
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
        exec ${git-cloner}/bin/git-cloner.py "$@"
      '';
    };

    nixosModules.git-cloner = {
      config = { config, pkgs, lib, ... }: {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the git-cloner service.";
          };

          targetDirectory = lib.mkOption {
            type = lib.types.str;
            default = "cloned_repos";
            description = "Target directory to clone repositories into.";
          };

          repositories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "List of Git repository URLs to clone.";
          };
        };

        config = lib.mkIf config.git-cloner.enable {
          systemd.services.git-cloner = {
            description = "Git Cloner Service";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.git-cloner}/bin/git-cloner -d ${config.git-cloner.targetDirectory} ${lib.concatStringsSep " " config.git-cloner.repositories}";
              Restart = "on-failure";
            };
          };
        };
      };
    };
  };
}

