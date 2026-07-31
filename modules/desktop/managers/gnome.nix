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
            stylix = mkEnableOption "Stylix";
            extensions = mkOption {
              type = types.attrsOf (
                types.submodule {
                  options = {
                    config = mkOption {
                      type = types.nullOr (types.attrsOf types.anything);
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
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        gnome-browser-connector.enable = false;
        gnome-keyring.enable = false;

        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];

    stylix.targets.gnome.enable = cfg.stylix;

    environment.systemPackages = [
      pkgs.gnome-terminal
    ];
  };
}
