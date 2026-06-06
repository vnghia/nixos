{
  lib,
  pkgs,
  ...
}:
(import ./desktop {
  inherit lib;
  inherit pkgs;
})
