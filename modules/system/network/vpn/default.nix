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
        commands = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                inputs = mkOption {
                  type = types.listOf types.package;
                  default = [ ];
                };
                check = mkOption { type = types.str; };
                up = mkOption { type = types.str; };
                down = mkOption { type = types.str; };
              };
            }
          );
          default = { };
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
