{
  pkgs,
  ...
}:
{
  config = {
    _ = {
      system = {
        boot = {
          type = "lanzaboote";
        };
        linux = {
          dbus = {
            implementation = "broker";
          };
          kernel = pkgs.linuxPackages_zen;
        };
        hardware = {
          bluetooth = {
            enable = true;
            onBoot = true;
            config = {
              experimental = true;
              fastConnectable = true;
            };
          };
        };
        nixos = {
          feature = {
            experimental = {
              common = {
                enable = true;
              };
            };
          };
          sops = {
            enable = true;
            tpm2 = true;
          };
        };
        packages = {
          gvfs = {
            enable = true;
          };
          nixLd = {
            enable = true;
          };
        };
        security = {
          tpm2 = {
            enable = true;
            abrmd = true;
          };
        };
        virtualisation = {
          qemu = {
            enable = true;
            onBoot = "ignore";
            onShutdown = "suspend";
          };
        };
      };
    };
  };
}
