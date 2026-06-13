{
  lib,
  config,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.thunderbird;
  desktop = "thunderbird.desktop";
in
{
  options = with lib; {
    _ = {
      desktop.packages.thunderbird = {
        enable = mkEnableOption "Thunderbird";
        birdtray = mkEnableOption "Birdtray";
        default = mkEnableOption "Default";
        profiles = mkOption {
          type = types.attrsOf types.anything;
        };
      }
      // customLib.home.desktop.packages.favorite.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.thunderbird = {
          enable = true;
          profiles = cfg.profiles;
        };

        _ = {
          system.nixos.impermanence.directories = [ ".thunderbird" ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig desktop cfg)
      (lib.mkIf cfg.default (
        let
          mimeApps = {
            "x-scheme-handler/mailto" = [ (lib.mkForce desktop) ];
            "x-scheme-handler/mid" = [ (lib.mkForce desktop) ];
            "message/rfc822" = [ (lib.mkForce desktop) ];
          };
        in
        {
          xdg.mimeApps = {
            enable = true;
            defaultApplications = mimeApps;
            associations = {
              added = mimeApps;
            };
          };
        }
      ))
      (lib.mkIf cfg.birdtray {
        home.packages = [
          pkgs.birdtray
        ];
      })
    ]
  );
}
