{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.secret;
in
{
  options = with lib; {
    _ = {
      desktop.secret = {
        type = mkOption {
          type = types.nullOr (
            types.enum [
              "gnome"
              "keepassxc"
            ]
          );
        };
        ssh = mkEnableOption "SSH Agent";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "gnome") {
      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ] ++ (if cfg.ssh then [ "ssh" ] else [ ]);
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
        settings = lib.mkMerge [
          {
            FdoSecrets.Enabled = true;
          }
          (lib.mkIf cfg.ssh {
            SSHAgent = {
              Enabled = true;
              UseOpenSSH = true;
              UsePageant = false;
            };
          })
        ];
      };
    })
  ];
}
