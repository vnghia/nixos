{
  lib,
  pkgs,
  config,
  customLib,
  ...
}:
let
  cfg = config._.desktop.programs.development.vscodium;
  homeCfg = config.home;
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
        argvSettings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
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
          argvSettings = cfg.argvSettings;
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
            argvSettings = {
              enable-proposed-api = [
                "s-h-a-d-o-w.dev-containers-oss"
              ];
            };
            base = {
              extensions = with pkgs.nix-vscode-extensions.open-vsx-release; [
                # Remote
                google.colab
                jeanp413.open-remote-ssh
                s-h-a-d-o-w.dev-containers-oss

                # Theme
                pkief.material-icon-theme

                # Data
                muhammad-ahmad.xlsx-viewer

                # Python
                ms-python.debugpy
                ms-python.python
                astral-sh.ty
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
                "editor.fontLigatures" = true;
                "editor.codeActionsOnSave" = {
                  "source.fixAll" = "explicit";
                  "source.organizeImports" = "explicit";
                };
                "diffEditor.ignoreTrimWhitespace" = false;
                "workbench.iconTheme" = "material-icon-theme";

                # Python
                "python.languageServer" = "None";
                "ty.disableLanguageServices" = false;
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

                # Telemetry
                "redhat.telemetry.enabled" = false;
                "telemetry.telemetryLevel" = "off";
              };
            };
            profiles = {
              default = { };
            };
          };

          nixos.impermanence.directories = {
            "${homeCfg.homeDirectory}/.vscode-oss-shared/sharedStorage" = { };
            "${xdgCfg.configHome}/VSCodium" = { };
            "${xdgCfg.stateHome}/VSCodium" = { };
          };
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
