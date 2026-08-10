{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.cli.programs.system.tree;
in
{
  options = with lib; {
    _ = {
      cli.programs.system.tree = {
        enable = mkEnableOption "Tree";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
