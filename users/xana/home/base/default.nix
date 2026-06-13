{
  lib,
  config,
  secrets,
  ...
}:
let
  emailAccountsList = secrets.user.email.accounts;
  secretPrefix = "user/email/accounts";
in
{
  config = {
    sops.secrets = lib.mergeAttrsList (
      builtins.genList (
        i:
        let
          emailAccount = builtins.elemAt emailAccountsList i;
        in
        {
          "${secretPrefix}/${emailAccount.name}" = {
            key = "${secretPrefix}/${toString i}";
          };
        }
      ) (builtins.length emailAccountsList)
    );

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

      user = {
        email = {
          accounts = lib.mapAttrs (
            name: value:
            lib.mkMerge [
              value
              { passwordCommand = "cat ${config.sops.secrets."${secretPrefix}/${name}".path}"; }
            ]
          ) (lib.listToAttrs emailAccountsList);
        };
      };
    };
  };
}
