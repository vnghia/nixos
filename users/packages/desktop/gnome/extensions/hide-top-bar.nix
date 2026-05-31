{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  gnomeCfg = osConfig.desktop.environment.gnome;
  cfg = gnomeCfg.extensions.hideTopBar;
in
{
  dconf = lib.mkIf (gnomeCfg.enable && cfg.enable) {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
        ];
      };
    };
  };
}
