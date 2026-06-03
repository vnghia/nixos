{
  lib,
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
            enable = true;
          }
          cfg.stylix.config
        ]
      );
    };
  };
}
