{
  lib,
  pkgs,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.packages.vscodium;
  cliCfg = config._.cli.packages;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.packages.vscodium = {
        enable = mkEnableOption "VsCodium";
        base = mkOption {
          type = types.attrsOf types.anything;
        };
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
          profiles = lib.mapAttrs (
            name: profile:
            (lib.mkMerge [
              cfg.base
              profile
            ])
          ) cfg.profiles;
        };

        _ = {
          desktop.packages.vscodium = {
            base = {
              extensions =
                with pkgs.nix-vscode-extensions.open-vsx;
                [
                  pkief.material-icon-theme
                ]
                ++ (if cliCfg.nixfmt.enable then [ jnoortheen.nix-ide ] else [ ]);
              userSettings = lib.mkMerge [
                {
                  "terminal.integrated.cursorStyle" = "line";
                  "terminal.integrated.cursorBlinking" = true;
                  "explorer.openEditors.visible" = 10;
                  "editor.formatOnSave" = true;
                  "editor.codeActionsOnSave" = {
                    "source.organizeImports" = "always";
                  };
                  "diffEditor.ignoreTrimWhitespace" = false;
                  "workbench.iconTheme" = "material-icon-theme";
                }
                (lib.mkIf (cliCfg.nixfmt.enable && cliCfg.nixd.enable) {
                  "nix.enableLanguageServer" = true;
                  "nix.serverPath" = "nixd";
                  "nix.serverSettings" = {
                    nixd = {
                      formatting = {
                        command = [ "nixfmt" ];
                      };
                    };
                  };
                })
              ];
            };
            profiles = {
              default = { };
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
          desktop.packages.vscodium = {
            stylix.config = {
              colors.enable = true;
              fonts.enable = true;
            };
          };
        };
      }
    ]
  );
}
