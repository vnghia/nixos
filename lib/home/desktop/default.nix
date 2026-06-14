{
  lib,
  ...
}:
{
  desktop =
    (import ./programs { inherit lib; })
    // (import ./theming {
      inherit lib;
    });
}
