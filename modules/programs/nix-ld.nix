{
  lib,
  config,
  ...
}:
let
  cfg = config._.programs.nixLd;
in
{
  options = with lib; {
    _ = {
      programs.nixLd = {
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
