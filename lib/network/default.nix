{
  ...
}:
{
  network = {
    isIpV4 = ip: (builtins.match "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}" ip) != null;
    isCdirV4 =
      cdir: (builtins.match "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}/[0-9]{1,3}" cdir) != null;
  };
}
