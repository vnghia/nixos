{
  lib,
  ...
}:
{
  nixos = (import ./sops.nix { inherit lib; });
}
