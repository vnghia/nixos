{
  lib,
  ...
}:
{
  options = with lib; {
    _ = {
      system.filesystem = {
        root = {
          type = mkOption { type = types.enum [ "btrfs" ]; };
        };
      };
    };
  };
}
