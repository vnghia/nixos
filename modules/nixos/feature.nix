{
  lib,
  config,
  ...
}:
let
  cfg = config._.nixos.feature;
in
{
  options = with lib; {
    _ = {
      nixos.feature = {
        experimental = {
          common = {
            enable = mkEnableOption "Common experimental features";
          };
        };
      };
    };
  };

  config = {
    nix.settings.experimental-features = lib.mkIf cfg.experimental.common.enable [
      "nix-command"
      "flakes"
    ];
  };
}
