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
in
{
  options = with lib; {
    _ = {
      desktop.theming.stylix = {
        image = mkOption {
          type = types.nullOr types.path;
          default = null;
        };
        scheme = mkOption {
          type = types.nullOr types.str;
          default = null;
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

    stylix = {
      base16Scheme = lib.mkIf (
        cfg.scheme != null
      ) "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";
      fonts = lib.mkMerge [
        cfg.fonts.fonts
        { sizes = cfg.fonts.sizes; }
      ];
      opacity = cfg.opacity;
    };
  };
}
