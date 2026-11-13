{
  pkgs,
  ...
}:
{
  config = {
    _ = {
      linux = {
        dbus = {
          implementation = "broker";
        };
        kernel = pkgs.linuxPackages_zen;
      };
    };
  };
}
