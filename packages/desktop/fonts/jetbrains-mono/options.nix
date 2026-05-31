{
  lib,
  config,
  ...
}:
{
  options = {
    desktopFonts = {
      enableJetbrainsMono = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };
}
