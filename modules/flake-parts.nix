# Registers flake-parts' `flake.modules` option (lazyAttrsOf (lazyAttrsOf
# deferredModule)), which lets every feature file set
# `flake.modules.darwin.<name>` / `flake.modules.homeManager.<name>` as
# arbitrary class-keyed module values. Required: without this import the
# `flake.modules` option is not declared.
{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];
}
