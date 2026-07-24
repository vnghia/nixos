{
  lib,
  config,
  ...
}:
let
  cfg = config._.programs.nixos.appimage;
in
{
  options = with lib; {
    _ = {
      programs.nixos.appimage = {
        enable = mkEnableOption "Appimage";
        binfmt = mkEnableOption "Binfmt";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = cfg.binfmt;
    };
  };
}
