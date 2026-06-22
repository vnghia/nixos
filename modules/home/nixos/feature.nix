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
