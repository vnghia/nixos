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
      desktop.security.secret = mkOption {
        type = types.enum [
          "gnome"
          "keepassxc"
        ];
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "gnome") {
      services.gnome-keyring = {
        enable = true;
        components = [ "secrets" ];
      };
    })
    (lib.mkIf (cfg == "keepassxc") {
      _ = {
        desktop.packages.keepassxc = {
          enable = true;
          autostart = true;
        };
      };

      programs.keepassxc = {
        settings = {
          FdoSecrets.Enabled = true;
        };
      };
    })
  ];
}
