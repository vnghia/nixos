{
  lib,
  pkgs,
  ...
}:
{
  stylix = {
    mkOption = with lib; {
      stylix = {
        enable = mkEnableOption "Stylix";
        config = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
      };
    };

    mkConfig = target: cfg: {
      stylix.targets.${target} = lib.mkIf cfg.stylix.enable (
        lib.mkMerge [
          {
            enable = lib.attrByPath [ "enable" ] true cfg;
          }
          cfg.stylix.config
        ]
      );
    };

    mkScheme = scheme: "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
  };
}
