{
  lib,
  ...
}:
{
  home =
    (import ./desktop {
      inherit lib;
    })
    // (import ./specialisation { inherit lib; });
}
