{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.desktop.gnome.extensions.hideTopBar;
in
{
  options = {
    desktop.gnome.extensions.hideTopBar = {
      enable = lib.mkEnableOption "Hide top bar";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnomeExtensions.hide-top-bar ];
  };
}
