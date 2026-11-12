{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.programs.game.prismlauncher;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.game.prismlauncher = {
        enable = mkEnableOption "PrismLauncher";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.prismlauncher = {
          enable = true;
        };

        _ = {
          nixos.impermanence.directories = {
            "${xdgCfg.dataHome}/PrismLauncher" = {
              restic = false;
            };
          };
        };
      }
    ]
  );
}
