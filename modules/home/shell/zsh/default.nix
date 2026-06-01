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

  config = lib.mkIf osCfg.enable {
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

      autosuggestion = {
        enable = true;
      };

      historySubstringSearch = {
        enable = true;
        searchUpKey = "^[[A";
        searchDownKey = "^[[B";
      };

      syntaxHighlighting = {
        enable = true;
        styles = {
          unknown-token = "fg=160";
          reserved-word = "fg=130";
          alias = "fg=84";
          builtin = "fg=84";
          command = "fg=84";
          function = "fg=84";

          commandseparator = "fg=250";
          redirection = "fg=250";

          path = "fg=45";
          globbing = "fg=33";

          command-substitution-delimiter = "fg=78";
          process-substitution-delimiter = "fg=78";
          back-quoted-argument-delimiter = "fg=78";

          single-quoted-argument = "fg=178";
          double-quoted-argument = "fg=178";
          dollar-quoted-argument = "fg=178";
          dollar-double-quoted-argument = "fg=178";

          single-quoted-argument-unclosed = "fg=248";
          double-quoted-argument-unclosed = "fg=248";
          dollar-quoted-argument-unclosed = "fg=248";
          dollar-double-quoted-argument-unclosed = "fg=248";

          single-hyphen-option = "fg=180";
          double-hyphen-option = "fg=228";

          default = "fg=253";
        };
      };

      antidote = {
        enable =
          builtins.length (
            builtins.attrNames (lib.attrsets.filterAttrs (name: value: value.enable) cfg.plugins)
          ) != 0;
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

    impermanence.files = [
      (lib.strings.removePrefix "${config.home.homeDirectory}/" historyPath)
    ];
  };
}
