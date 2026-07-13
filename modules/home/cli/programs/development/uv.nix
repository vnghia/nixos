{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.cli.programs.development.uv;
  nixLdCfg = osConfig._.programs.nixLd;
  xdgCfg = config.xdg;

  uvDataDirectory = "${xdgCfg.dataHome}/uv";
  uvCacheDirectory = "${xdgCfg.cacheHome}/uv";
in
{
  options = with lib; {
    _ = {
      cli.programs.development.uv = {
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
      nixos.impermanence.directories = {
        ${uvDataDirectory} = { };
        ${uvCacheDirectory} = { };
      };
    };
  };
}
