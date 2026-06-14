{
  lib,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.obsidian;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.obsidian = {
        enable = mkEnableOption "Obsidian";
        vaults = mkOption { type = types.attrsOf types.anything; };
      }
      // customLib.home.desktop.packages.favorite.mkOption
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
            (lib.mapAttrs (name: _: { target = "Documents/Obsidian/${name}"; }) cfg.vaults)
          ];
        };

        _ = {
          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/obsidian"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "obsidian.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "obsidian" cfg)
      {
        _ = {
          desktop.packages.obsidian.stylix.config = {
            colors.enable = true;
            fonts.enable = true;
            polarity.enable = true;
          };
        };
      }
    ]
  );
}
