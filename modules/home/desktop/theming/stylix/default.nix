{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.theming.stylix;
  osCfg = osConfig._.desktop.theming.stylix;
  fontCfg = osConfig._.desktop.fonts;
  mkThemeConfig = theme: force: {
    image = lib.mkIf (theme.image != null) (if force then (lib.mkForce theme.image) else theme.image);
    base16Scheme = lib.mkIf (theme.scheme != null) (
      if force then
        (lib.mkForce "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml")
      else
        "${pkgs.base16-schemes}/share/themes/${theme.scheme}.yaml"
    );
    polarity = (if force then (lib.mkForce theme.polarity) else theme.polarity);
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
    assertions = lib.attrsets.mapAttrsToList (_: value: {
      assertion = builtins.elem value.package fontCfg;
      message = "font package ${value.name} is not included in system font packages";
    }) cfg.fonts.fonts;

    stylix = lib.mkMerge [
      (mkThemeConfig cfg.themes.${cfg.default} false)
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

    specialisation = lib.attrsets.concatMapAttrs (
      name: theme:
      let
        specialisationName = "${name}-theme";
      in
      {
        ${specialisationName} = {
          configuration = {
            xdg.dataFile."home-manager/specialisation".text = specialisationName;
            stylix = mkThemeConfig theme true;
          };
        };
      }
    ) cfg.themes;
  };
}
