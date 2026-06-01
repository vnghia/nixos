{
  lib,
  ...
}:
{
  options = {
    system.filesystem = with lib; {
      root = {
        type = mkOption { type = types.enum [ "btrfs" ]; };
      };
    };
  };
}
