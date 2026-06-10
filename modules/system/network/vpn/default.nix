{
  lib,
  config,
  ...
}:
let
  cfg = config._.network.vpn;
in
{
  imports = [
    ./mullvad
    ./tailscale
  ];

  options = with lib; {
    _ = {
      network.vpn = {
        default = mkOption {
          type = types.nullOr (
            types.enum [
              "mullvad"
            ]
          );
          default = null;
        };
        enabledInterfaces = mkOption {
          type = types.listOf types.str;
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.default == "mullvad") {
      _ = {
        network.vpn.mullvad.enable = true;
      };
    })
  ];
}
