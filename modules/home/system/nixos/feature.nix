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
        exec = {
          enable = mkEnableOption "builtins.exec";
        };
      };
    };
  };

  config = {
    nix.extraOptions = lib.concatStringsSep "\n" (
      if cfg.exec.enable then [ "allow-unsafe-native-code-during-evaluation = true" ] else [ ]
    );
  };
}
