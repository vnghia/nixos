{
  lib,
  pkgs,
  ...
}:
{
  theming = (
    import ./stylix.nix {
      inherit lib;
      inherit pkgs;
    }
  );
}
