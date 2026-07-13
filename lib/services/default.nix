{
  lib,
  ...
}:
{
  services = (import ./restic.nix { inherit lib; });
}
