{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.productivity.obsidian;
  userXdgCfg = config._.user.xdg;
  xdgCfg = config.xdg;

  mkObsidianTarget = name: "${userXdgCfg.directories.documents}/obsidian/${name}";
in
{
  options = with lib; {
    _ = {
      desktop.programs.productivity.obsidian = {
        enable = mkEnableOption "Obsidian";
        vaults = mkOption { type = types.attrsOf types.anything; };
      }
      // customLib.home.desktop.programs.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.obsidian = {
          enable = true;
          vaults = lib.mkMerge [
            cfg.vaults
            (lib.mapAttrs (name: _: {
              target = mkObsidianTarget name;
            }) cfg.vaults)
          ];
        };

        _ = {
          nixos.impermanence.directories = [
            "${xdgCfg.configHome}/obsidian"
            "${userXdgCfg.directories.documents}/obsidian"
          ];
        };
      }
      (customLib.home.desktop.programs.favorite.mkConfig "obsidian.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "obsidian" cfg)
      {
        _ = {
          desktop.programs.productivity.obsidian.stylix.config = {
            colors.enable = true;
            fonts.enable = true;
            polarity.enable = true;
          };
        };
      }
    ]
  );
}
