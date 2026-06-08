{
  lib,
  customLib,
  config,
  pkgs,
  ...
}:
let
  cfg = config._.specialisation;
  homeCfg = config.home;
  specialisationDirectory = "${homeCfg.homeDirectory}/.local/specialisation";

  activateSpecialisationPackage = pkgs.writeShellApplication {
    name = customLib.home.specialisation.activateScript;
    text = ''
      ${specialisationDirectory}/"$1"-"$2"/activate
    '';
  };
in
{
  options = with lib; {
    _ = {
      specialisation = mkOption {
        type = types.attrsOf (types.attrsOf (types.attrsOf types.anything));
        default = { };
      };
      activateSpecialisationBin = mkOption {
        type = types.path;
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
      activateSpecialisationPackage
    ];

    _ = {
      activateSpecialisationBin = "${activateSpecialisationPackage}/bin/activate-specialisation";
    };

    specialisation = lib.concatMapAttrs (
      typeName: typeSpecialisation:
      (lib.mapAttrs' (
        subName: subConfig:
        lib.nameValuePair "${typeName}-${subName}" {
          configuration = customLib.mkForceRecursive subConfig;
        }
      ) typeSpecialisation)
    ) cfg;
  };
}
