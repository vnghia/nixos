{
  lib,
  config,
  ...
}:
let
  cfg = config._.system.linux.dbus;
in
{
  options = with lib; {
    _ = {
      system.linux.dbus = {
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
