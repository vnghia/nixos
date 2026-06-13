{
  lib,
  config,
  ...
}:
let
  cfg = config._.user.email;
in
{
  options = with lib; {
    _ = {
      user.email = {
        accounts = mkOption {
          type = types.attrsOf types.anything;
          default = { };
        };
        clients = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };
      };
    };
  };

  config = {
    accounts.email = {
      maildirBasePath = ".local/share/mail";
      accounts = lib.mapAttrs (
        name: value:
        lib.mkMerge (
          [
            value
          ]
          ++ (lib.forEach cfg.clients (client: {
            ${client}.enable = true;
          }))
        )
      ) cfg.accounts;
    };
  };
}
