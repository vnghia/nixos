{
  users.users = {
    alice = {
      initialPassword = "test";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}
