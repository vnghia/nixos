{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.desktop.programs.productivity.cake-wallet;
  xdgCfg = config.xdg;
in
{
  options = with lib; {
    _ = {
      desktop.programs.productivity.cake-wallet = {
        enable = mkEnableOption "Cake wallet";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cake-wallet
    ];

    _ = {
      nixos.impermanence.directories = {
        "${xdgCfg.configHome}/cake_wallet" = { };
      };
    };
  };
}
