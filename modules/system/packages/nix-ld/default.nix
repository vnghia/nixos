{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.system.packages.nixLd;
in
{
  options = with lib; {
    _ = {
      system.packages.nixLd = {
        enable = mkEnableOption "Nix-ld";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
  };
}
