{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = config.shell.zsh;
  osCfg = osConfig.shell.zsh;
  userCfg = osConfig.user;
  xdgCfg = config.xdg;
  historyPath = "${xdgCfg.dataHome}/zsh/zsh_history";
in
{
  options = with lib; {
    shell.zsh = {
      plugins = mkOption {
        type = types.attrsOf (
          types.submodule {
            options = {
              enable = mkOption {
                type = lib.types.bool;
                default = true;
              };
              path = mkOption {
                type = types.nullOr types.str;
                default = null;
              };
            };
          }
        );
      };
    };
  };

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

      antidote = {
        enable = true;
        plugins = [
          (lib.strings.concatLines (
            lib.attrsets.mapAttrsToList (
              name: value: "${name}${lib.optionalString (value.path != null) " path:${value.path}"}"
            ) (lib.attrsets.filterAttrs (name: value: value.enable) cfg.plugins)
          ))
        ];
      };

      # Fix can't rename $HISTFILE.new to $HISTFILE
      setOptions = [
        "INC_APPEND_HISTORY"
        "NO_HIST_SAVE_BY_COPY"
      ];
    };

    shell.zsh.plugins = {
      "zsh-users/zsh-autosuggestions" = { };
      "zsh-users/zsh-history-substring-search" = { };
      "zsh-users/zsh-syntax-highlighting" = { };
    };

    impermanence.files = [
      (lib.strings.removePrefix "${config.home.homeDirectory}/" historyPath)
    ];
  };
}
