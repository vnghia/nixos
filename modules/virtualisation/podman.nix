{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.virtualisation.podman;
  filesystemCfg = config._.filesystem;
in
{
  options = with lib; {
    _ = {
      virtualisation.podman = {
        enable = mkEnableOption "Podman";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        virtualisation.podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };

        environment.systemPackages = with pkgs; [
          podman
          shadow
          passt
        ];
      }
      (lib.mkIf (filesystemCfg.root.type == "btrfs") {
        virtualisation.containers.storage.settings = {
          storage = {
            driver = "btrfs";
          };
        };
      })
    ]
  );
}
