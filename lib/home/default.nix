{
  lib,
  pkgs,
  ...
}:
let
  mkForceRecursive =
    attrs:
    lib.attrsets.mapAttrs (
      name: value: (if (builtins.isAttrs value) then (mkForceRecursive value) else (lib.mkForce value))
    ) attrs;
in
(import ./desktop {
  inherit lib;
  inherit pkgs;
})
// {
  mkForceRecursive = mkForceRecursive;
}
