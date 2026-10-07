# SOURCE: https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies.html

[Skip to content](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies#material-dependencies)

# Material Dependencies [¶](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies\#material-dependencies)

Material dependencies help ensure that a material profile is only used with compatible printer and process profiles, preventing potential printing issues.

## Compatible printers [¶](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies\#compatible-printers)

Set of printers that this material profile is compatible with if you want to limit its usage to specific printers.

### Printer Condition [¶](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies\#printer-condition)

boolean expression using the configuration values of an active printer profile.

If this expression evaluates to true, this profile is considered compatible with the active printer profile.

## Compatible process profiles [¶](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies\#compatible-process-profiles)

Set of process profiles that this material profile is compatible with if you want to limit its usage to specific process profiles.

### Process Condition [¶](https://www.orcaslicer.com/wiki/material_settings/dependencies/material_dependencies\#process-condition)

A boolean expression using the configuration values of an active print profile.

If this expression evaluates to true, this profile is considered compatible with the active print profile.

Back to top