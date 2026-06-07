{
  lib,
  ...
}:
{
  stylix = {
    mkScheme = pkgs: scheme: "${pkgs.base16-schemes}/share/themes/${scheme}.yaml";
  };
}
