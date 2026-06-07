{
  lib,
  ...
}:
{
  home = (
    import ./desktop {
      inherit lib;
    }
  );
}
