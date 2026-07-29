{
  lib,
  ...
}:
{
  nixos =
    (import ./sops.nix { inherit lib; })
    // (import ./impermanence.nix { inherit lib; })
    // (import ./overlay.nix { inherit lib; });
}
