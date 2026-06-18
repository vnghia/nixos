{
  config,
  secrets,
  ...
}:
let
  homeCfg = config.home;
  techDirectory = "${homeCfg.homeDirectory}/Tech";
in
{
  config = {
    _ = {
      cli = {
        programs = {
          direnv = {
            enable = true;
            nix = true;
          };
          dust = {
            enable = true;
          };
          eza = {
            enable = true;
          };
          git = {
            enable = true;
            user = secrets.cli.programs.git.user;
          };
          jq = {
            enable = true;
          };
          just = {
            enable = true;
          };
          nh = {
            enable = true;
            clean = {
              enable = true;
            };
            flake = "${techDirectory}/code/infrastructure/nixos";
          };
          nixd = {
            enable = true;
          };
          nixfmt = {
            enable = true;
          };
          starship = {
            enable = true;
          };
          uv = {
            enable = true;
          };
          vim = {
            enable = true;
          };
          zellij = {
            enable = true;
          };
          zoxide = {
            enable = true;
          };
        };
        security = {
          ssh = {
            type = "tpm";
          };
        };
      };

      services = {
        syncthing = {
          enable = true;
          devices = secrets.services.syncthing.devices;
        };
      };

      system.nixos = {
        impermanence.directories = [
          techDirectory
        ];
        sops = {
          enable = true;
        };
      };

      user = {
        email = {
          accounts = {
            accounts = secrets.user.email.accounts;
          };
        };
      };
    };
  };
}
