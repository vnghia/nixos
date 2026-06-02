{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig._.desktop.managers.gnome;
in
{
  dconf = lib.mkIf cfg.enable {
    enable = true;
    settings = lib.mkMerge [
      {
        "org/gnome/desktop/calendar" = {
          show-weekdate = false;
          week-start-day = "monday";
        };

        "org/gnome/mutter" = {
          experimental-features = [
            "scale-monitor-framebuffer"
            "variable-refresh-rate"
            "xwayland-native-scaling"
            "autoclose-xwayland"
          ];
        };

        "org/gnome/shell" = {
          enabled-extensions = lib.attrsets.mapAttrsToList (
            name: value: pkgs.gnomeExtensions.${name}.extensionUuid
          ) (lib.attrsets.filterAttrs (name: value: value != null) cfg.extensions);
        };
      }
      (lib.attrsets.mapAttrs' (
        name: value:
        lib.nameValuePair ("org/gnome/shell/extensions/${if value.key != null then value.key else name}") (
          value.config
        )
      ) (lib.attrsets.filterAttrs (name: value: value.enable && value.config != null) cfg.extensions))
    ];
  };
}
