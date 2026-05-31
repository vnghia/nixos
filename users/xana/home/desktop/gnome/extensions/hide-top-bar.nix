{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.desktop.gnome.extensions.hideTopBar;
in
{
  dconf = lib.mkIf cfg.enable {
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
        ];
      };
    };
  };
}
