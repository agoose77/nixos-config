{inputs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  home.sessionVariables.EDITOR = "nvim";

  # Setup nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    plugins = {
      cmp.enable = true;
      #        cmp.mapping.preset.insert({
      #    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      #    ['<C-f>'] = cmp.mapping.scroll_docs(4),
      #    ['<C-Space>'] = cmp.mapping.complete(),
      #    ['<C-e>'] = cmp.mapping.abort(),
      #    ['<CR>'] = cmp.mapping.confirm({ select = true }),
      #  })
      fugitive.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;

      treesitter.enable = true;
      treesitter-context.enable = true;

      # treesitter-textobjects.enable = true; TODO: this would be cool
      lsp-format.enable = true;
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
          eslint.enable = true;
          nil-ls.enable = true;
        };
      };
      oil = {
        enable = true;
        settings = {
          # Don't perm-delete files first
          delete_to_trash = true;
          use_default_keymaps = true;
          # Use LSP to aut-change names of files we modify
          lsp_file_method.autosave_changes = true;
          buf_options = {
            buflisted = true;
            bufhidden = "hide";
          };
          view_options = {
            show_hidden = true;
          };
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
