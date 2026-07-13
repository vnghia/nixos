{
  lib,
  ...
}:
{
  nixos = (import ./sops.nix { inherit lib; }) // (import ./impermanence.nix { inherit lib; });
}
