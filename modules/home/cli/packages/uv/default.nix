{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.cli.packages.uv;
  nixLdCfg = osConfig.system.packages.nixLd;
in
{
  options = with lib; {
    cli.packages.uv = {
      enable = mkEnableOption "Uv";
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
