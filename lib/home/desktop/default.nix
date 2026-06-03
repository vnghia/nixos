{
  lib,
  ...
}:
{
  desktop = (import ./packages { inherit lib; }) // (import ./theming { inherit lib; });
}
