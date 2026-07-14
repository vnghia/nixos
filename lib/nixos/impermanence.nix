{
  lib,
  ...
}:
{
  impermanence = {
    mkNormalizedPaths =
      mkPath: paths:
      lib.mapAttrs' (
        path: value: lib.nameValuePair (lib.strings.normalizePath (mkPath path)) value
      ) paths;

    mkConfig = (
      file: path: value:
      (lib.mkMerge [
        {
          "${if file then "file" else "directory"}" = path;
        }
        (removeAttrs value [ "restic" ])
      ])
    );
  };
}
