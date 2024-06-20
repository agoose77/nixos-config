{inputs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  # Setup nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    plugins = {
      fugitive.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;
      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>k" = "goto_prev";
            "<leader>j" = "goto_next";
          };
          lspBuf = {
            gd = "definition";
            gD = "references";
            gt = "type_definition";
            gi = "implementation";
            K = "hover";
            "<F2>" = "rename";
          };
        };
        servers = {
          pylsp.enable = true;
          ruff-lsp.enable = true;
          tsserver.enable = true;
          nil-ls.enable = true;
        };
      };
    };
    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      termguicolors = true;
    };
  };
}
