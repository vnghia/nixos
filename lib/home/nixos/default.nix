{
  lib,
  ...
}:
{
  nixos = (import ./jail.nix { inherit lib; });
}
