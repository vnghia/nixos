{
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config._.system.shell.zsh;
  osCfg = osConfig._.system.shell.zsh;
  xdgCfg = config.xdg;
  historyPath = "${xdgCfg.dataHome}/zsh/zsh_history";
  compdumpPath = "${xdgCfg.cacheHome}/zsh/zcompdump";
  enabledPlugins = lib.filterAttrs (name: value: value.enable) cfg.plugins;
  enabledAntidote = builtins.length (builtins.attrNames enabledPlugins) > 0;
in
{
  options = with lib; {
    _ = {
      system.shell.zsh = {
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
        searchUpKey = "$terminfo[kcuu1]";
        searchDownKey = "$terminfo[kcud1]";
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
        enable = enabledAntidote;
        plugins = [
          (lib.concatLines (
            lib.mapAttrsToList (
              name: value: "${name}${lib.optionalString (value.path != null) " path:${value.path}"}"
            ) enabledPlugins
          ))
        ];
      };

      # Fix can't rename $HISTFILE.new to $HISTFILE
      setOptions = [
        "INC_APPEND_HISTORY"
        "NO_HIST_SAVE_BY_COPY"
      ];

      sessionVariables = {
        ZSH_COMPDUMP = compdumpPath;
      };
    };

    _ = {
      system.nixos.impermanence = {
        directories = if enabledAntidote then [ "${xdgCfg.cacheHome}/antidote" ] else [ ];

        files = [
          historyPath
          compdumpPath
        ];
      };
    };
  };
}
