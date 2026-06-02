{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.packages.uv;
  nixLdCfg = osConfig._.system.packages.nixLd;
in
{
  options = with lib; {
    _ = {
      cli.packages.uv = {
        enable = mkEnableOption "Uv";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nixLdCfg.enable;
        message = "uv requires nix-ld";
      }
    ];

    programs.uv = {
      enable = true;
    };
  };
}
