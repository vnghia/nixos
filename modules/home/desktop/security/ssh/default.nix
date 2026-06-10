{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.security.ssh;
in
{
  options = with lib; {
    _ = {
      desktop.security.ssh = {
        type = mkOption {
          type = types.nullOr (
            types.enum [
              "gnome"
              "keepassxc"
            ]
          );
          default = null;
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "gnome") {
      services.gnome-keyring = {
        enable = true;
        components = [ "ssh" ];
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
          SSHAgent = {
            Enabled = true;
            UseOpenSSH = true;
            UsePageant = false;
          };
        };
      };
    })
  ];
}
