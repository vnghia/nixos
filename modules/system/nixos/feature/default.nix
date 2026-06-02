{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.nixos.feature;
in
{
  options = with lib; {
    _ = {
      system.nixos.feature = {
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
