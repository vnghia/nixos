{
  config,
  secrets,
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
            user = secrets.cli.packages.git.user;
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
