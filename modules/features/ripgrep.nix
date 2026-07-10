# ripgrep (typed home-manager module).
{...}: {
  config.flake.modules.homeManager.ripgrep = {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow"
        "--multiline-dotall"
        "--type-add"
        "spec:*.spec.*"
      ];
    };
  };
}
