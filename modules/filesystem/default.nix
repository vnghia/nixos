{
  lib,
  ...
}:
{
  options = with lib; {
    _ = {
      filesystem = {
        root = {
          type = mkOption { type = types.enum [ "btrfs" ]; };
        };
      };
    };
  };
}
