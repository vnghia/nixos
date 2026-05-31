{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.desktop.environment.gnome;
in
{
  options = with lib; {
    desktop = {
      environment = {
        gnome = {
          enable = mkEnableOption "Gnome";
          extensions = mkOption {
            type = types.attrsOf (
              types.nullOr (
                types.submodule {
                  options = {
                    key = mkOption {
                      type = types.nullOr types.str;
                      default = null;
                    };
                    config = mkOption {
                      type = types.nullOr types.attrs;
                      default = null;
                    };
                  };
                }
              )
            );
            default = { };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    desktop = {
      environment = {
        gnome = {
          extensions = {
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
    ) (lib.attrsets.filterAttrs (name: value: value != null) cfg.extensions);
  };
}
