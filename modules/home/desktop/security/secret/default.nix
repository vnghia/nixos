{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.security.secret;
in
{
  options = with lib; {
    _ = {
      desktop.security.secret = {
        type = mkOption {
          type = types.enum [
            "gnome"
            "keepassxc"
          ];
        };
        config = {
          keepassxc = {
            confirmAccessItem = mkOption {
              type = types.bool;
              default = true;
            };
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "gnome") {
      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };
    })
    (lib.mkIf (cfg.type == "keepassxc") {
      _ = {
        desktop.packages.keepassxc = {
          enable = true;
          autostart = true;
        };
      };

      programs.keepassxc = {
        settings = {
          FdoSecret = {
            Enabled = true;
            ConfirmAccessItem = cfg.config.keepassxc.confirmAccessItem;
          };
        };
      };
    })
  ];
}
