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
              always-show-workspace-thumbnails = { };
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
              caffeine = {
                config = {
                  cli-toggle = false;
                  indicator-position-max = 1;
                  user-enabled = true;
                };
              };
              dash-to-dock = {
                config = {
                  always-center-icons = true;
                  animate-show-apps = true;
                  apply-custom-theme = true;
                  apply-glossy-effect = false;
                  autohide = true;
                  background-opacity = 0.5;
                  custom-background-color = false;
                  custom-theme-shrink = false;
                  dash-max-icon-size = 44;
                  disable-overview-on-startup = true;
                  dock-fixed = false;
                  dock-position = "BOTTOM";
                  extend-height = false;
                  height-fraction = 0.9;
                  hide-tooltip = false;
                  icon-size-fixed = false;
                  intellihide = false;
                  intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
                  isolate-monitors = false;
                  isolate-workspaces = false;
                  max-alpha = 0.8;
                  middle-click-action = "launch";
                  multi-monitor = true;
                  preview-size-scale = 0.0;
                  running-indicator-dominant-color = false;
                  running-indicator-style = "DOTS";
                  scroll-action = "do-nothing";
                  shift-click-action = "minimize";
                  shift-middle-click-action = "launch";
                  show-apps-always-in-the-edge = true;
                  show-show-apps-button = false;
                  show-trash = true;
                  transparency-mode = "FIXED";
                  unity-backlit-items = false;
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
