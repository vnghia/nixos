{
  lib,
  customLib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.desktop.managers.gnome;
  osCfg = osConfig._.desktop.managers.gnome;
  enabledPlugins = lib.filterAttrs (name: value: value.enable) cfg.extensions;

  dumpDconf =
    attrs:
    lib.concatMapAttrs (
      name: value:
      if (builtins.isAttrs value) then
        (
          let
            rawResults = lib.mapAttrsToList (
              innerName: innerValue:
              if (builtins.isAttrs innerValue) then
                lib.nameValuePair "${name}/${innerName}" innerValue
              else
                lib.nameValuePair name {
                  ${innerName} = innerValue;
                }
            ) (dumpDconf value);
          in
          (builtins.listToAttrs (builtins.filter (children: children.name != name) rawResults))
          // {
            "${name}" = lib.mergeAttrsList (
              map (nameValuePair: nameValuePair.value) (
                builtins.filter (children: children.name == name) rawResults
              )
            );
          }
        )
      else
        { ${name} = value; }
    ) attrs;
in
{
  options = with lib; {
    _ = {
      desktop.managers.gnome = {
        location = mkEnableOption "Location";
        favorites = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
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
                config = mkOption {
                  type = types.nullOr (types.attrsOf types.anything);
                  default = null;
                };
              };
            }
          );
          default = { };
        };
        dconf = mkOption { type = types.attrsOf types.anything; };
        themes = {
          light = mkOption { type = types.str; };
          dark = mkOption { type = types.str; };
        };
      }
      // customLib.home.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf osCfg.enable (
    lib.mkMerge [
      {
        home.packages = lib.mapAttrsToList (name: value: pkgs.gnomeExtensions.${name}) enabledPlugins;
      }
      {
        dconf = {
          enable = true;
          settings = lib.mkMerge [
            (dumpDconf cfg.dconf)
            (dumpDconf {
              org.gnome.shell = {
                favorite-apps = cfg.favorites;

                enabled-extensions = lib.mapAttrsToList (
                  name: _: pkgs.gnomeExtensions.${name}.extensionUuid
                ) enabledPlugins;

                extensions = lib.mapAttrs' (
                  name: value:
                  lib.nameValuePair (if value.key != null then value.key else name) (
                    if value.config != null then value.config else { }
                  )
                ) enabledPlugins;
              };
            })
            (dumpDconf {
              org.gnome.shell.extensions = lib.mapAttrs' (
                name: value:
                lib.nameValuePair (if value.key != null then value.key else name) (
                  lib.attrByPath [
                    name
                    "config"
                  ] { } osCfg.extensions
                )
              ) enabledPlugins;
            })
          ];
        };
      }
      (customLib.home.desktop.theming.stylix.mkConfig "gnome" cfg)
      {
        _ = {
          desktop.managers.gnome = {
            extensions = {
              appindicator = {
                config = {
                  legacy-tray-enabled = false;
                  tray-pos = "right";
                };
              };
              blur-my-shell = {
                config = {
                  hacks-level = 1;
                  rounded-blur-found = false;
                  settings-version = 2;
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
              clipboard-indicator = {
                config = {
                  excluded-apps = [ "KeePassXC" ];
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
              disable-unredirect = { };
              emoji-copy = {
                config = {
                  emoji-keybind = [ "<Super>E" ];
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
              just-perfection = {
                config = {
                  accessibility-menu = false;
                  activities-button = false;
                  background-menu = true;
                  clock-menu = true;
                  controls-manager-spacing-size = 0;
                  dash = true;
                  dash-app-running = true;
                  dash-icon-size = 0;
                  dash-separator = true;
                  double-super-to-appgrid = true;
                  keyboard-layout = true;
                  max-displayed-search-results = 0;
                  osd = true;
                  overlay-key = true;
                  panel = true;
                  panel-in-overview = true;
                  panel-notification-icon = true;
                  power-icon = true;
                  quick-settings = true;
                  ripple-box = false;
                  search = false;
                  show-apps-button = false;
                  startup-status = 0;
                  support-notifier-showed-version = 34;
                  support-notifier-type = 0;
                  theme = true;
                  type-to-search = true;
                  window-demands-attention-focus = true;
                  window-maximized-on-create = false;
                  window-picker-icon = false;
                  window-preview-caption = true;
                  window-preview-close-button = false;
                  workspace = true;
                  workspace-background-corner-size = 0;
                  workspace-peek = false;
                  workspace-popup = true;
                  workspace-switcher-should-show = true;
                  workspace-thumbnail-to-main-view = false;
                  workspace-wrap-around = true;
                  workspaces-in-app-grid = false;
                };
              };
              maximize-window-into-new-workspace = { };
              night-theme-switcher = {
                key = "nightthemeswitcher";
                config = {
                  time = {
                    manual-schedule = false;
                    nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
                  };
                  commands = {
                    enabled = true;
                    sunrise = "${config._.activateSpecialisationBin} theme ${cfg.themes.light}";
                    sunset = "${config._.activateSpecialisationBin} theme ${cfg.themes.dark}";
                  };
                };
              };
              quick-settings-audio-panel = { };
            };

            dconf = {
              org.gnome = lib.mkMerge [
                {
                  desktop = {
                    calendar = {
                      show-weekdate = false;
                      week-start-day = "monday";
                    };
                    interface = {
                      clock-format = "24h";
                      clock-show-weekday = false;
                      enable-animations = true;
                      enable-hot-corners = false;
                      font-antialiasing = "rgba";
                      font-hinting = "slight";
                      show-battery-percentage = true;
                      text-scaling-factor = 1.0;
                    };
                  };

                  mutter = {
                    dynamic-workspaces = true;
                    edge-tiling = true;
                    experimental-features = [
                      "scale-monitor-framebuffer"
                      "variable-refresh-rate"
                      "xwayland-native-scaling"
                      "autoclose-xwayland"
                    ];
                    workspaces-only-on-primary = true;
                  };

                  settings-daemon.plugins.power = {
                    ambient-enabled = false;
                    power-button-action = "interactive";
                    sleep-inactive-ac-timeout = 3600;
                    sleep-inactive-ac-type = "suspend";
                    sleep-inactive-battery-timeout = 1800;
                    sleep-inactive-battery-type = "suspend";
                  };

                  shell = {
                    disable-extension-version-validation = true;

                    app-switcher = {
                      current-workspace-only = false;
                    };
                    keybindings = {
                      show-screenshot-ui = [ "<Shift><Control>s" ];
                    };
                  };

                  tweaks = {
                    show-extensions-notice = false;
                  };
                }
                (lib.mkIf cfg.location { system.location.enabled = true; })
              ];
            };

            stylix.config = {
              colors.enable = true;
              fonts.enable = true;
              image.enable = true;
              imageScalingMode.enable = true;
              inputs.enable = true;
              polarity.enable = true;
            };
          };
        };
      }
    ]
  );
}
