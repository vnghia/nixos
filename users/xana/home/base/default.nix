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
          development = {
            direnv = {
              enable = true;
              nix = true;
            };
            git = {
              enable = true;
              user = secrets.cli.programs.development.git.user;
            };
            just = {
              enable = true;
            };
            nixd = {
              enable = true;
            };
            nixfmt = {
              enable = true;
            };
            uv = {
              enable = true;
            };
          };
          shell = {
            eza = {
              enable = true;
            };
            starship = {
              enable = true;
            };
            zellij = {
              enable = true;
            };
            zoxide = {
              enable = true;
            };
          };
          system = {
            nh = {
              enable = true;
              clean = {
                enable = true;
              };
              flake = "${techDirectory}/code/infrastructure/nixos";
            };
          };
          utility = {
            dust = {
              enable = true;
            };
            jq = {
              enable = true;
            };
            vim = {
              enable = true;
            };
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
