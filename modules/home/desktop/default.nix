{
  config,
  ...
}:
let
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

  config = {
    _ = {
      system.nixos.impermanence.directories = [
        # Graphic cache
        "${xdgCfg.cacheHome}/mesa_shader_cache"
        "${xdgCfg.cacheHome}/radv_builtin_shaders"
      ];
    };
  };
}
