{
  # Prevent kubeconfig being used
  home.file.".kube/config".text = ''
  '';
}
