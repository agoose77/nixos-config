{
  flake.modules.homeManager.no-global-kubeconfig = {
    # Prevent kubeconfig being used
    home.file.".kube/config".text = ''
    '';
  };
}
