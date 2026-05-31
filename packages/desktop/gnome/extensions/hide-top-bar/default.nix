{
  lib,
  pkgs,
  config,
  ...
}:
let
  gnomeCfg = config.desktop.gnome;
  cfg = gnomeCfg.extensions.hideTopBar;
in
{
  options = {
    desktop.gnome.extensions.hideTopBar = {
      enable = lib.mkEnableOption "Hide top bar";
    };
  };

  config = lib.mkIf (gnomeCfg.enable && cfg.enable) {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-top-bar ];
  };
}
