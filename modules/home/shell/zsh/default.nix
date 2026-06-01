{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  osCfg = osConfig.shell.zsh;
  userCfg = osConfig.user;
  xdgCfg = config.xdg;
  historyPath = "${xdgCfg.dataHome}/zsh/zsh_history";
in
{
  config = lib.mkIf (osCfg.enable || userCfg.shell == "zsh") {
    programs.zsh = {
      enable = true;

      history = {
        path = historyPath;
        append = true;
        save = 999999999;
        size = 999999999;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        findNoDups = true;
        saveNoDups = true;
        share = true;
      };
    };

    impermanence.files = [
      (lib.strings.removePrefix "${config.home.homeDirectory}/" historyPath)
    ];
  };
}
