{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.system.packages.nixLd;
in
{
  options = with lib; {
    system.packages.nixLd = {
      enable = mkEnableOption "Nix-ld";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nix-ld = {
      enable = true;
    };
  };
}
