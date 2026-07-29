{
  lib,
  ...
}:
{
  overlay = {
    mkPackageOverlay =
      pkgs: packages:
      (
        self: super:
        lib.mergeAttrsList (
          lib.forEach packages (pkg: {
            ${pkg} = lib.getAttrFromPath (lib.splitString "." pkg) pkgs;
          })
        )
      );
  };
}
