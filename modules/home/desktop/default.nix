{
  lib,
  config,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.desktop;
  xdgCfg = config.xdg;
in
{
  imports = [
    ./frameworks
    ./i18n
    ./managers
    ./programs
    ./security
    ./theming
  ];

  config = lib.mkIf osCfg.enable {
    _ = {
      nixos.impermanence.directories = {
        # Graphic cache
        "${xdgCfg.cacheHome}/mesa_shader_cache" = {
          restic = false;
        };
        "${xdgCfg.cacheHome}/radv_builtin_shaders" = {
          restic = false;
        };

        # Application entries
        "${xdgCfg.dataHome}/icons" = {
          restic = false;
        };
        "${xdgCfg.dataHome}/applications" = {
          restic = false;
        };
      };
    };
  };
}
