{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.network;
  desktopCfg = config._.desktop;
in
{
  options = with lib; {
    _ = {
      desktop.network = {
        captive = {
          interface = mkOption { type = types.str; };
        };
      };
    };
  };

  config = lib.mkIf desktopCfg.enable {
    programs.captive-browser = {
      enable = true;
      bindInterface = true;
      interface = cfg.captive.interface;
    };
  };
}
