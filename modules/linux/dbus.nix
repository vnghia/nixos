{
  lib,
  config,
  ...
}:
let
  cfg = config._.linux.dbus;
in
{
  options = with lib; {
    _ = {
      linux.dbus = {
        implementation = mkOption {
          type = types.enum [
            "dbus"
            "broker"
          ];
          default = "dbus";
        };
      };
    };
  };

  config = {
    services.dbus = {
      implementation = cfg.implementation;
    };
  };
}
