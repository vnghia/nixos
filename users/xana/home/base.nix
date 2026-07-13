{
  config,
  secrets,
  ...
}:
let
  homeCfg = config.home;
  techDirectory = "${homeCfg.homeDirectory}/tech";
in
{
  config = {
    _ = {
      cli = {
        programs = {
          data = {
            jq = {
              enable = true;
            };
            rclone = {
              enable = true;
            };
          };
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
            vim = {
              enable = true;
            };
          };
          system = {
            dust = {
              enable = true;
            };
            eza = {
              enable = true;
            };
            nh = {
              enable = true;
              clean = {
                enable = true;
              };
              flake = "${techDirectory}/code/infrastructure/nixos";
            };
          };
          terminal = {
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

      nixos = {
        impermanence.directories = {
          ${techDirectory} = { };
        };
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
