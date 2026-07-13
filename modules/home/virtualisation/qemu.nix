{
  lib,
  config,
  osConfig,
  ...
}:
let
  virtualisationCfg = osConfig._.virtualisation;
  userCfg = osConfig._.users.users.${config.home.username};
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf (virtualisationCfg.qemu.enable && userCfg.groups.qemu) {
    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.configHome}/libvirt" = { };
        "${xdgCfg.dataHome}/libvirt" = { };
      };
    };
  };
}
