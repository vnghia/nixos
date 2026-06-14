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
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };

    _ = {
      system.nixos.impermanence.directories = [ "${xdgCfg.stateHome}/syncthing" ];
    };
  };
}
