{
  lib,
  ...
}:
{
  desktop = (
    import ./theming {
      inherit lib;
    }
  );
}
