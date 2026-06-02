{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.desktop.managers.gnome;
in
{
  options = with lib; {
    _ = {
      desktop = {
        managers = {
          gnome = {
            enable = mkEnableOption "Gnome";
            extensions = mkOption {
              type = types.attrsOf (
                types.submodule {
                  options = {
                    enable = mkOption {
                      type = types.bool;
                      default = true;
                    };
                    key = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    namespace = mkOption {
                      type = types.bool;
                      default = false;
                    };
                    config = mkOption {
                      type = types.nullOr types.attrs;
                      default = null;
                    };
                  };
                }
              );
              default = { };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    _ = {
      desktop = {
        managers = {
          gnome = {
            extensions = {
              appindicator = {
                config = {
                  legacy-tray-enabled = false;
                  tray-pos = "right";
                };
              };
              blur-my-shell = {
                namespace = true;
                config = {
                  "" = {
                    hacks-level = 1;
                    rounded-blur-found = false;
                    settings-version = 2;
                  };
                  appfolder = {
                    blur = true;
                    brightness = 1.0;
                    sigma = 0;
                  };
                  applications = {
                    pipeline = "pipeline_default";
                  };
                  coverflow-alt-tab = {
                    pipeline = "pipeline_default";
                  };
                  dash-to-dock = {
                    blur = true;
                    brightness = 1.0;
                    pipeline = "pipeline_default_rounded";
                    sigma = 100;
                    static-blur = true;
                    style-dash-to-dock = 0;
                    unblur-in-overview = false;
                  };
                  hidetopbar = {
                    compatibility = false;
                  };
                  lockscreen = {
                    pipeline = "pipeline_default";
                  };
                  overview = {
                    blur = true;
                    pipeline = "pipeline_default";
                    style-components = 1;
                  };
                  panel = {
                    brightness = 1.0;
                    force-light-text = false;
                    pipeline = "pipeline_default";
                    sigma = 0;
                    unblur-in-overview = true;
                  };
                  screenshot = {
                    pipeline = "pipeline_default";
                  };
                  window-list = {
                    brightness = 1.0;
                    sigma = 0;
                  };
                };
              };
              hide-top-bar = {
                key = "hidetopbar";
                config = {
                  enable-active-window = false;
                  enable-intellihide = false;
                  mouse-sensitive = true;
                };
              };
            };
          };
        };
      };
    };

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    # To disable installing GNOME's suite of applications
    # and only be left with GNOME shell.
    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];

    environment.systemPackages = lib.attrsets.mapAttrsToList (
      name: value: pkgs.gnomeExtensions.${name}
    ) (lib.attrsets.filterAttrs (name: value: value.enable) cfg.extensions);
  };
}
