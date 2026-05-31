{
  lib,
  pkgs,
  config,
  ...
}:
let
  gnomeCfg = config.desktop.environment.gnome;
  cfg = gnomeCfg.extensions.hideTopBar;
in
{
  options = {
    desktop.environment.gnome.extensions.hideTopBar = {
      enable = lib.mkEnableOption "Hide top bar";
    };
  };

  config = lib.mkIf (gnomeCfg.enable && cfg.enable) {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-top-bar ];
  };
}
