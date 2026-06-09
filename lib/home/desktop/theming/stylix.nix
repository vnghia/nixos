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

    mkConfig =
      target: cfg:
      (lib.mkIf cfg.stylix.enable {
        stylix.targets.${target} = (
          lib.mkMerge [
            {
              enable = true;
            }
            cfg.stylix.config
          ]
        );
      });
  };
}
