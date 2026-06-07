{
  lib,
  customLib,
  config,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config._.specialisation;
  xdgCfg = config.xdg;
  homeCfg = config.home;
  specialisationDirectory = "${homeCfg.homeDirectory}/.local/specialisation";
in
{
  options = with lib; {
    _ = {
      specialisation = mkOption {
        type = types.attrsOf (types.attrsOf (types.attrsOf types.anything));
        default = { };
      };
    };
  };

  config = {
    home.activation.linkSpecialisation =
      lib.hm.dag.entryBetween [ "installPackages" ] [ "writeBoundary" ]
        ''
          homeSpecialisationDirectory="$newGenPath/specialisation"
          if [ -d "$homeSpecialisationDirectory" ]; then
            run mkdir -p ${specialisationDirectory}

            for specialisation in $(find $homeSpecialisationDirectory -mindepth 1 -maxdepth 1 -type l); do
              name=${specialisationDirectory}/$(basename $specialisation)
              verboseEcho "Linking $specialisation to $name ..."
              run rm -f $name
              run ln -s $(realpath $specialisation) $name
            done
          fi
        '';

    home.packages = [
      (pkgs.writeShellApplication {
        name = customLib.home.specialisation.activateScript;
        text = ''
          ${specialisationDirectory}/"$1"-"$2"/activate
        '';
      })
    ];

    specialisation = lib.attrsets.concatMapAttrs (
      typeName: typeSpecialisation:
      (lib.attrsets.mapAttrs' (
        subName: subConfig:
        lib.attrsets.nameValuePair "${typeName}-${subName}" {
          configuration = customLib.mkForceRecursive subConfig;
        }
      ) typeSpecialisation)
    ) cfg;
  };
}
