{
  lib,
  config,
  ...
}:
let
  cfg = config._.programs.nixos.nix-ld;
in
{
  options = with lib; {
    _ = {
      programs.nixos.nix-ld = {
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
