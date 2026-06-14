{
  lib,
  ...
}:
{
  programs = (import ./favorite.nix { inherit lib; });
}
