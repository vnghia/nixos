{
  lib,
  config,
  ...
}:
let
  cfg = config._.nixos.substituters;
in
{
  options = with lib; {
    _ = {
      nixos.substituters = mkOption {
        type = types.attrsOf types.str;
        default = { };
      };
    };
  };

  config = {
    nix.settings.extra-substituters = lib.attrNames cfg;
    nix.settings.extra-trusted-public-keys = lib.attrValues cfg;
    nix.settings.substituters = [ "https://cache.nixos.org/" ];
  };
}
