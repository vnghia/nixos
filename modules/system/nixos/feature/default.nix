{
  lib,
  config,
  ...
}:
let
  cfg = config.system.nixos.feature;
in
{
  options = {
    system.nixos.feature = with lib; {
      experimental = {
        common = {
          enable = mkEnableOption "Common experimental features";
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
