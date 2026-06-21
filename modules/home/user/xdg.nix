{
  lib,
  config,
  ...
}:
let
  cfg = config._.user.xdg;
  homeCfg = config.home;
in
{
  options = with lib; {
    _ = {
      user.xdg = {
        enable = mkEnableOption "XDG user directories";
        directories = mkOption {
          type = types.attrsOf (types.nullOr types.str);
          default = { };
        };
      };
    };
  };

  config = {
    xdg.userDirs = lib.mkMerge [
      {
        enable = cfg.enable;
        createDirectories = true;
      }
      (lib.mapAttrs (
        _: path: if (path != null) then "${homeCfg.homeDirectory}/${path}" else null
      ) cfg.directories)
    ];

    _ = {
      system.nixos.impermanence.directories = builtins.filter (path: path != null) (
        lib.mapAttrsToList (directory: path: path) cfg.directories
      );
    };
  };
}
