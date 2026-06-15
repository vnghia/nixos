{
  lib,
  pkgs,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.vscodium;
  xdgCfg = config.xdg;

  profile =
    with lib;
    types.submodule {
      options = {
        extensions = mkOption {
          type = types.listOf types.package;
          default = [ ];
        };
        userSettings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
      };
    };
in
{
  options = with lib; {
    _ = {
      desktop.programs.vscodium = {
        enable = mkEnableOption "VsCodium";
        base = mkOption {
          type = profile;
        };
        profiles = mkOption {
          type = types.attrsOf profile;
        };
      }
      // customLib.home.desktop.programs.favorite.mkOption
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.vscodium = {
          enable = true;
          mutableExtensionsDir = false;
          profiles = lib.mapAttrs (
            name: profile:
            (lib.mkMerge [
              cfg.base
              profile
            ])
          ) cfg.profiles;
        };

        _ = {
          desktop.programs.vscodium = {
            base = {
              extensions = with pkgs.nix-vscode-extensions.open-vsx; [
                pkief.material-icon-theme

                # YAML
                redhat.vscode-yaml

                # Python
                ms-python.debugpy
                ms-python.python
                ms-python.vscode-python-envs
                meta.pyrefly
                ms-toolsai.jupyter
              ];
              userSettings = {
                "terminal.integrated.cursorStyle" = "line";
                "terminal.integrated.cursorBlinking" = true;
                "explorer.openEditors.visible" = 10;
                "editor.formatOnSave" = true;
                "editor.codeActionsOnSave" = {
                  "source.organizeImports" = "always";
                };
                "diffEditor.ignoreTrimWhitespace" = false;
                "workbench.iconTheme" = "material-icon-theme";

                # YAML
                "yaml.format.enable" = true;
                "[yaml]" = {
                  "editor.defaultFormatter" = "redhat.vscode-yaml";
                };

                # Python
                "python.languageServer" = "None";

                # RedHat extension
                "redhat.telemetry.enabled" = false;
              };
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
      (customLib.home.desktop.programs.favorite.mkConfig "codium.desktop" cfg)
      (customLib.home.desktop.theming.stylix.mkConfig "vscodium" cfg)
      {
        _ = {
          desktop.programs.vscodium = {
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
