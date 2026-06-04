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
  dumpDconf =
    attrs:
    lib.attrsets.concatMapAttrs (
      name: value:
      if (builtins.isAttrs value) then
        (
          let
            rawResults = lib.attrsets.mapAttrsToList (
              innerName: innerValue:
              if (builtins.isAttrs innerValue) then
                lib.nameValuePair ("${name}/${innerName}") innerValue
              else
                lib.nameValuePair name {
                  ${innerName} = innerValue;
                }
            ) (dumpDconf value);
          in
          (builtins.listToAttrs (builtins.filter (children: children.name != name) rawResults))
          // {
            "${name}" = lib.attrsets.mergeAttrsList (
              builtins.map (nameValuePair: nameValuePair.value) (
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
        favorites = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
        dconf = mkOption { type = types.attrsOf types.anything; };
      }
      // customLib.desktop.theming.stylix.mkOption;
    };
  };

  config = lib.mkIf osCfg.enable (
    lib.mkMerge [
      {
        dconf = {
          enable = true;
          settings = dumpDconf cfg.dconf;
        };
      }
      (customLib.desktop.theming.stylix.mkConfig "gnome" (cfg // { enable = osCfg.stylix; }))
      {
        _ = {
          desktop.managers.gnome = {
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
                    enabled-extensions = lib.attrsets.mapAttrsToList (
                      name: value: pkgs.gnomeExtensions.${name}.extensionUuid
                    ) (lib.attrsets.filterAttrs (name: value: value != null) osCfg.extensions);
                    favorite-apps = cfg.favorites;

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
                {
                  shell.extensions = lib.attrsets.concatMapAttrs (name: value: {
                    ${if value.key != null then value.key else name} = value.config;
                  }) (lib.attrsets.filterAttrs (name: value: value.enable && value.config != null) osCfg.extensions);
                }
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
