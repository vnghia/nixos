{
  lib,
  pkgs,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.development.vscodium;
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
      desktop.programs.development.vscodium = {
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
          desktop.programs.development.vscodium = {
            base = {
              extensions = with pkgs.nix-vscode-extensions.open-vsx; [
                # Theme
                pkief.material-icon-theme

                # Python
                ms-python.debugpy
                ms-python.python
                astral-sh.ty
                detachhead.basedpyright
                ms-toolsai.jupyter
                charliermarsh.ruff

                # YAML
                redhat.vscode-yaml

                # TOML
                tamasfe.even-better-toml

                # XML
                redhat.vscode-xml
              ];
              userSettings = {
                "terminal.integrated.cursorStyle" = "line";
                "terminal.integrated.cursorBlinking" = true;
                "explorer.openEditors.visible" = 10;
                "editor.formatOnSave" = true;
                "editor.codeActionsOnSave" = {
                  "source.fixAll" = "explicit";
                  "source.organizeImports" = "explicit";
                };
                "diffEditor.ignoreTrimWhitespace" = false;
                "workbench.iconTheme" = "material-icon-theme";

                # Python
                "python.languageServer" = "None";
                "ty.disableLanguageServices" = true;
                "[python]" = {
                  "editor.defaultFormatter" = "charliermarsh.ruff";
                };

                # YAML
                "yaml.format.enable" = true;
                "[yaml]" = {
                  "editor.defaultFormatter" = "redhat.vscode-yaml";
                };

                # TOML
                "[toml]" = {
                  "editor.defaultFormatter" = "tamasfe.even-better-toml";
                };

                # XML
                "[xml]" = {
                  "editor.defaultFormatter" = "redhat.vscode-xml";
                };

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
          desktop.programs.development.vscodium = {
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
