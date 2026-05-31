{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.desktop.environment.gnome;
in
{
  dconf = lib.mkIf cfg.enable {
    enable = true;
    settings = lib.mkMerge [
      {
        "org/gnome/shell" = {
          enabled-extensions = lib.attrsets.mapAttrsToList (
            name: value: pkgs.gnomeExtensions.${name}.extensionUuid
          ) cfg.extensions;
        };
      }
      (lib.attrsets.mapAttrs' (
        name: value: lib.nameValuePair ("org/gnome/shell/extensions/${value.key or name}") (value.config)
      ) (lib.attrsets.filterAttrs (name: value: value != null && value.config != null) cfg.extensions))
    ];
  };
}
