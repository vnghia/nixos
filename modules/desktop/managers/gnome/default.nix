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
            gvfs = mkEnableOption "Gvfs";
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
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];

    services.gvfs.enable = lib.mkForce cfg.gvfs;

    stylix.targets.gnome.enable = cfg.stylix;

    environment.systemPackages = [
      pkgs.gnome-terminal
    ];
  };
}
