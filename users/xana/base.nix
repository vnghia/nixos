{
  ...
}:
{
  config = {
    _ = {
      users = {
        users = {
          xana = {
            shell = "zsh";
            groups = {
              wheel = true;
              networkManager = true;
              qemu = true;
              tpm2 = true;
            };
          };
        };
      };
    };
  };
}
