{
  ...
}:
{
  config = {
    _ = {
      virtualisation = {
        qemu = {
          enable = true;
          onBoot = "ignore";
          onShutdown = "suspend";
        };
      };
    };
  };
}
