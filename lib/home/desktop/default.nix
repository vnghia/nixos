{
  lib,
  pkgs,
  ...
}:
{
  desktop =
    (import ./packages { inherit lib; })
    // (import ./theming {
      inherit lib;
      inherit pkgs;
    });
}
