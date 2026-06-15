{
  lib,
  config,
  ...
}:
let
  cfg = config._.services.syncthing;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      services.syncthing = {
        enable = mkEnableOption "Syncthing";
        tray = mkEnableOption "Tray";
        devices = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        folders = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      overrideDevices = true;
      overrideFolders = true;
      settings = {
        options = {
          urAccepted = -1;
        };
        devices = cfg.devices;
        folders = cfg.folders;
      };
      tray = {
        enable = cfg.tray;
      };
    };

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.stateHome}/syncthing" ];
    };
  };
}
