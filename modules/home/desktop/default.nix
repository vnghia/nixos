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
    ./managers
    ./packages
    ./security
    ./theming
  ];

  config = lib.mkIf osCfg.enable {
    _ = {
      system.nixos.impermanence.directories = [
        # Graphic cache
        "${xdgCfg.cacheHome}/mesa_shader_cache"
        "${xdgCfg.cacheHome}/radv_builtin_shaders"
      ];
    };
  };
}
