{
  lib,
  ...
}:
{
  system = (import ./nixos { inherit lib; });
}
