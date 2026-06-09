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
          kernel = pkgs.linuxPackages_zen;
        };
        nixos = {
          feature = {
            experimental = {
              common = {
                enable = true;
              };
            };
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
          };
        };
      };
    };
  };
}
