{
  lib,
  config,
  ...
}:
let
  cfg = config._.desktop.theming.darkman;
in
{
  options = with lib; {
    _ = {
      desktop.theming.darkman = {
        enable = mkEnableOption "Darkman";
        themes = {
          light = mkOption { type = types.str; };
          dark = mkOption { type = types.str; };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.darkman = {
      enable = true;
      settings = {
        usegeoclue = true;
      };
      scripts = {
        activate-specialisation = ''
          if [ "$1" = "light" ]; then
            ${config._.activateSpecialisationBin} theme ${cfg.themes.light}
          else
            ${config._.activateSpecialisationBin} theme ${cfg.themes.dark}
          fi
        '';
      };
    };
  };
}
