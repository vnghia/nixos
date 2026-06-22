{
  lib,
  config,
  ...
}:
let
  cfg = config._.packages.nixLd;
in
{
  options = with lib; {
    _ = {
      packages.nixLd = {
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
