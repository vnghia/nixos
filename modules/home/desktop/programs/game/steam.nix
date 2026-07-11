{
  lib,
  config,
  osConfig,
  ...
}:
let
  osCfg = osConfig._.desktop.programs.game.steam;
  homeCfg = config.home;
  xdgCfg = config.xdg;
in
{
  config = lib.mkIf osCfg.enable {
    _ = {
      nixos.impermanence.directories = [
        "${homeCfg.homeDirectory}/.steam"
        "${xdgCfg.dataHome}/Steam"
      ];
    };

    # https://wiki.nixos.org/wiki/Steam#Fix_missing_icons_for_games_in_GNOME_dock_and_activities_overview
    home.activation.fixSteamIcons = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for f in ~/.local/share/applications/*.desktop; do
        id=$(grep -Eo 'steam://rungameid/[0-9]+' "$f" | sed 's#.*/##') || true
        [ -n "$id" ] || continue
        last=$(tail -n1 "$f" || true)
        want="StartupWMClass=steam_app_$id"
        [ "$last" = "$want" ] || echo "$want" >> "$f"
      done
    '';
  };
}
