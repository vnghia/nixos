{
  lib,
  config,
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
              tpm2 = true;
            };
          };
        };
      };
    };
  };
}
