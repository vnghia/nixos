{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.cli.packages.just;
in
{
  options = with lib; {
    _ = {
      cli.packages.just = {
        enable = mkEnableOption "Just";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.just
      pkgs.just-lsp
    ];
  };
}
