{
  lib,
  config,
  osConfig,
  pkgs,
  customLib,
  ...
}:
let
  cfg = config._.desktop.theming.stylix;
  fontCfg = osConfig._.desktop.fonts;
  mkThemeConfig = theme: {
    image = lib.mkIf (theme.image != null) theme.image;
    base16Scheme = lib.mkIf (theme.scheme != null) (
      customLib.desktop.theming.stylix.mkScheme pkgs theme.scheme
    );
    polarity = lib.mkIf (theme.polarity != null) theme.polarity;
  };
in
{
  options = with lib; {
    _ = {
      desktop.theming.stylix = {
        default = mkOption { type = types.str; };
        themes = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                image = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                };
                scheme = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
                polarity = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
              };
            }
          );
        };

        fonts = {
          fonts = mkOption {
            type = types.attrsOf (
              types.submodule {
                options = {
                  package = mkOption { type = types.package; };
                  name = mkOption { type = types.str; };
                };
              }
            );
            default = { };
          };
          sizes = mkOption {
            type = types.attrsOf types.int;
            default = { };
          };
        };
        opacity = mkOption {
          type = types.attrsOf types.float;
          default = { };
        };
      };
    };
  };

  config = {
    assertions = lib.mapAttrsToList (_: value: {
      assertion = builtins.elem value.package fontCfg;
      message = "font package ${value.name} is not included in system font packages";
    }) cfg.fonts.fonts;

    stylix = lib.mkMerge [
      (mkThemeConfig cfg.themes.${cfg.default})
      {
        enable = true;
        autoEnable = false;
        fonts = lib.mkMerge [
          cfg.fonts.fonts
          { sizes = cfg.fonts.sizes; }
        ];
        opacity = cfg.opacity;
      }
    ];

    _ = {
      specialisation = {
        theme = lib.mapAttrs (name: theme: {
          stylix = mkThemeConfig theme;
          dconf.settings."org/gnome/desktop/interface".color-scheme =
            if theme.polarity == "dark" then
              "prefer-dark"
            else if theme.polarity == "light" then
              "prefer-light"
            else
              null;
        }) cfg.themes;
      };
    };
  };
}
