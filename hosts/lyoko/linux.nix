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
        kernel = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v4;
      };
    };
  };
}
