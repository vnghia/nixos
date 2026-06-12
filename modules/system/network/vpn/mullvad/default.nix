{
  lib,
  config,
  pkgs,
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
      network.vpn.commands = {
        mullvad = {
          inputs = [ pkgs.jq ];
          check = "${pkgs.mullvad}/bin/mullvad status --json | jq '.state == \"connected\"'";
          up = "${pkgs.mullvad}/bin/mullvad connect --wait";
          down = "${pkgs.mullvad}/bin/mullvad disconnect --wait";
        };
      };

      system.nixos.impermanence.directories = [
        {
          directory = "/etc/mullvad-vpn";
          mode = "0600";
        }
        "/var/cache/mullvad-vpn"
      ];
    };
  };
}
