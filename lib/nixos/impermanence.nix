{
  lib,
  ...
}:
{
  impermanence = {
    mkConfig = (
      file: mkPath: path: value:
      if ((builtins.length (builtins.attrNames value)) == 0) then
        mkPath path
      else
        (lib.mkMerge [
          {
            "${if file then "file" else "directory"}" = mkPath path;
          }
          (removeAttrs value [ "restic" ])
        ])
    );
  };
}
