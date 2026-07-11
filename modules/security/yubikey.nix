{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config._.security.yubikey;
in
{
  options = with lib; {
    _ = {
      security.yubikey = {
        enable = mkEnableOption "Yubikey";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = with pkgs; [
      yubikey-personalization
    ];

    environment.systemPackages = with pkgs; [
      yubikey-manager
    ];
  };
}
