{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.desktop.packages.nautilus;
in
{
  options = with lib; {
    _ = {
      desktop.packages.nautilus = {
        enable = mkEnableOption "Nautilus";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nautilus
    ];
  };
}
