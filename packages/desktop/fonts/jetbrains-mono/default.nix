{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [ ./options.nix ];

  fonts.packages = lib.mkIf config.desktopFonts.enableJetbrainsMono ([
    pkgs.nerd-fonts.jetbrains-mono
  ]);
}
