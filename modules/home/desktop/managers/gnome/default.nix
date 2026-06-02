{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.managers.gnome;
  osCfg = osConfig._.desktop.managers.gnome;
  extensionPrefix = "org/gnome/shell/extensions/";
in
{
  options = with lib; {
    _ = {
      desktop.managers.gnome = {
        favorites = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };

  config = {
    _ = {
      desktop.managers.gnome = {
        favorites = [ (lib.mkOverride 50 "org.gnome.Nautilus.desktop") ];
      };
    };

    dconf = lib.mkIf osCfg.enable {
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
            disable-extension-version-validation = true;
            enabled-extensions = lib.attrsets.mapAttrsToList (
              name: value: pkgs.gnomeExtensions.${name}.extensionUuid
            ) (lib.attrsets.filterAttrs (name: value: value != null) osCfg.extensions);
            favorite-apps = cfg.favorites;
          };
        }
        (lib.attrsets.concatMapAttrs (
          name: value:
          if value.namespace then
            lib.attrsets.mapAttrs' (
              namespaceAttr: namespaceValue:
              lib.attrsets.nameValuePair (
                extensionPrefix
                + (if value.key != null then value.key else name)
                + (lib.optionalString (namespaceAttr != "") "/${namespaceAttr}")
              ) namespaceValue
            ) value.config
          else
            {
              "${extensionPrefix}${if value.key != null then value.key else name}" = value.config;
            }
        ) (lib.attrsets.filterAttrs (name: value: value.enable && value.config != null) osCfg.extensions))
      ];
    };
  };
}
