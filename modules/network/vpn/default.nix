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
    ./mullvad.nix
    ./tailscale.nix
  ];

  options = with lib; {
    _ = {
      network.vpn = {
        default = {
          type = mkOption {
            type = types.nullOr (
              types.enum [
                "mullvad"
              ]
            );
            default = null;
          };
          enabledInterfaces = mkOption {
            type = types.listOf types.str;
            default = [ ];
          };
          interfaceTrustedConnections = mkOption {
            type = types.attrsOf (types.listOf types.str);
            default = { };
          };
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
    (lib.mkIf (cfg.default.type == "mullvad") {
      _ = {
        network.vpn.mullvad.enable = true;
      };
    })
  ];
}
