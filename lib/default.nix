{
  lib,
  ...
}:
let
  mkForceRecursive =
    attrs:
    lib.attrsets.mapAttrs (
      name: value: (if (builtins.isAttrs value) then (mkForceRecursive value) else (lib.mkForce value))
    ) attrs;
in
(import ./home {
  inherit lib;
})
// (import ./desktop {
  inherit lib;
})
// {
  mkForceRecursive = mkForceRecursive;
}
