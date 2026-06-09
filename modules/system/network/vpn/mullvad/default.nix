{
  lib,
  config,
  ...
}:
let
  cfg = config._.network.vpn.mullvad;
in
{
  options = with lib; {
    _ = {
      network.vpn.mullvad = {
        enable = mkEnableOption "Mullvad";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    _ = {
      system.nixos.impermanence.directories = [ "/etc/mullvad-vpn" ];
    };
  };
}
