{
  lib,
  customLib,
  config,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.i18n.input;
  fcitx5Cfg = cfg.config.fcitx5;
  managersCfg = osConfig._.desktop.managers;
in
{
  options = with lib; {
    _ = {
      desktop.i18n.input = {
        type = mkOption {
          type = types.nullOr (
            types.enum [
              "fcitx5"
            ]
          );
          default = null;
        };
        config = {
          fcitx5 = {
            globalOptions = mkOption {
              type = types.attrsOf types.anything;
              default = { };
            };
            addons = mkOption {
              type = types.attrsOf (
                types.submodule {
                  options = {
                    package = mkOption { type = types.str; };
                    globalSection = mkOption {
                      type = types.attrsOf types.anything;
                      default = { };
                    };
                    sections = mkOption {
                      type = types.attrsOf types.anything;
                      default = { };
                    };
                  };
                }
              );
              default = { };
            };
            inputMethod = mkOption {
              type = types.attrsOf types.anything;
              default = { };
            };
          }
          // customLib.home.desktop.theming.stylix.mkOption;
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.type == "fcitx5") (
      lib.mkMerge [
        {
          i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
              addons = lib.mapAttrsToList (
                _: addon: lib.getAttrFromPath (lib.splitString "." addon.package) pkgs
              ) fcitx5Cfg.addons;
              settings = {
                globalOptions = fcitx5Cfg.globalOptions;
                addons = lib.mapAttrs (name: addon: {
                  globalSection = addon.globalSection;
                  sections = addon.sections;
                }) fcitx5Cfg.addons;
                inputMethod = fcitx5Cfg.inputMethod;
              };
              waylandFrontend = true;
            };
          };
        }
        (lib.mkIf managersCfg.gnome.enable {
          home.packages = [
            pkgs.fcitx5-gtk
          ];

          _ = {
            desktop.managers.gnome.extensions = {
              kimpanel = { };
            };
          };
        })
        (customLib.home.desktop.theming.stylix.mkConfig "fcitx5" fcitx5Cfg)
        {
          _ = {
            desktop.i18n.input.config.fcitx5.stylix.config = {
              colors.enable = true;
              fonts.enable = true;
            };
          };
        }
      ]
    ))
  ];
}
