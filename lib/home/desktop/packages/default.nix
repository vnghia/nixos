{
  lib,
  ...
}:
{
  packages = (import ./favorite.nix { inherit lib; });
}
