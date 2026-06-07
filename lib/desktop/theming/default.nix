{
  lib,
  ...
}:
{
  theming = (
    import ./stylix.nix {
      inherit lib;
    }
  );
}
