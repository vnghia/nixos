{
  config,
  ...
}:
{
  config = {
    _ = {
      cli = {
        packages = {
          direnv = {
            enable = true;
            nix = true;
          };
          eza = {
            enable = true;
          };
          git = {
            enable = true;
            user = {
              name = "Vo Van Nghia";
              email = "git@vnghia.com";
            };
          };
          just = {
            enable = true;
          };
          nh = {
            enable = true;
            clean = {
              enable = true;
            };
            flake = "${config.home.homeDirectory}/code/nixos";
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

      system.nixos = {
        feature = {
          exec = {
            enable = true;
          };
        };
        impermanence.directories = [
          "code"
        ];
        sops = {
          enable = true;
        };
      };
    };
  };
}
