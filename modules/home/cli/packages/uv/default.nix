{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.packages.uv;
  nixLdCfg = osConfig._.system.packages.nixLd;
  xdgCfg = config.xdg;
  uvCacheDirectory = "${xdgCfg.cacheHome}/uv";
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
      settings = {
        cache-dir = uvCacheDirectory;
        python-preference = "managed";
      };
    };

    _ = {
      system.nixos.impermanence.directories = [ uvCacheDirectory ];
    };
  };
}
