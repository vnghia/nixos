{
  ...
}:
{
  config = {
    _ = {
      hardware = {
        bluetooth = {
          enable = true;
          onBoot = true;
          config = {
            experimental = true;
            fastConnectable = true;
          };
        };
      };
    };
  };
}
