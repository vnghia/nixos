{
  lib,
  ...
}:
{
  desktop = (import ./packages { inherit lib; });
}
