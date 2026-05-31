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
  imports = [
    ./extensions
  ];

  options = {
    desktop.environment.gnome.enable = lib.mkEnableOption "Gnome";
  };

  config = lib.mkIf cfg.enable {
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
  };
}
