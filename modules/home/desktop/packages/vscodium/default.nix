{
  lib,
  pkgs,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.vscodium;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.vscodium = {
        enable = mkEnableOption "VsCodium";
        profiles = mkOption {
          type = types.attrsOf types.anything;
        };
      }
      // customLib.home.desktop.packages.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.vscodium = {
          enable = true;
          profiles = cfg.profiles;
        };

        _ = {
          desktop.packages.vscodium.profiles = {
            default = {
              extensions = with pkgs.nix-vscode-extensions.open-vsx; [
                pkief.material-icon-theme
              ];
              userSettings = {
                terminal.integrated = {
                  cursorStyle = "line";
                  cursorBlinking = true;
                };
                editor = {
                  formatOnSave = true;
                  codeActionsOnSave = {
                    source = {
                      organizeImports = "always";
                    };
                  };
                };
                diffEditor = {
                  ignoreTrimWhitespace = false;
                };
                workbench = {
                  iconTheme = "material-icon-theme";
                };
              };
            };
          };

          system.nixos.impermanence.directories = [
            "${xdgCfg.configHome}/VSCodium"
            "${xdgCfg.stateHome}/VSCodium"
          ];
        };
      }
      (customLib.home.desktop.packages.favorite.mkConfig "codium.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "vscodium" cfg)
      {
        _ = {
          desktop.packages.vscodium.stylix.config = {
            colors.enable = true;
            fonts.enable = true;
          };
        };
      }
    ]
  );
}
