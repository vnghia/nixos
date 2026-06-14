{
  lib,
  config,
  ...
}:
let
  cfg = config._.user.email;
  secretPrefix = "user/email/accounts";
in
{
  options = with lib; {
    _ = {
      user.email = {
        accounts = {
          accounts = mkOption {
            type = types.attrsOf (
              types.listOf (
                types.submodule {
                  options = {
                    name = mkOption { type = types.str; };
                    config = {
                      catchAllDomains = mkOption {
                        type = types.listOf types.str;
                        default = [ ];
                      };
                    };
                    value = mkOption { type = types.attrsOf types.anything; };
                  };
                }
              )
            );
            default = { };
          };
          config = mkOption {
            type = types.attrsOf types.anything;
            default = { };
          };
        };
      };
    };
  };

  config = {
    sops.secrets = lib.concatMapAttrs (
      profile: accounts:
      lib.mergeAttrsList (
        builtins.genList (
          i:
          let
            account = builtins.elemAt accounts i;
          in
          {
            "${secretPrefix}/${profile}/${account.name}" = {
              key = "${secretPrefix}/${profile}/${toString i}";
            };
          }
        ) (builtins.length accounts)
      )
    ) cfg.accounts.accounts;

    accounts.email = {
      maildirBasePath = ".local/share/mail";
      accounts = lib.concatMapAttrs (
        profile: accounts:
        lib.mapAttrs (
          name: account:
          lib.mkMerge [
            account
            { passwordCommand = "cat ${config.sops.secrets."${secretPrefix}/${profile}/${name}".path}"; }
            (lib.attrByPath [ name ] { } cfg.accounts.config)
          ]
        ) (lib.listToAttrs accounts)
      ) cfg.accounts.accounts;
    };
  };
}
