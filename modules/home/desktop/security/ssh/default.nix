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
      desktop.security.ssh = mkOption {
        type = types.enum [
          "gnome"
          "keepassxc"
          "tpm"
        ];
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg == "gnome") {
      services.gnome-keyring = {
        enable = true;
        components = [ "ssh" ];
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
          SSHAgent = {
            Enabled = true;
            UseOpenSSH = true;
            UsePageant = false;
          };
        };
      };
    })
    (lib.mkIf (cfg == "tpm") {
      services.ssh-tpm-agent = {
        enable = true;
      };
    })
  ];
}
