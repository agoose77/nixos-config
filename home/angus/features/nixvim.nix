{inputs, ...}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];

  home.sessionVariables.EDITOR = "nvim";
  # Setup nixvim
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # Trouble
    keymaps = [
      {
        mode = "n";
        key = "<leader>d";
        action = "+diagnostics/debug";
      }

      {
        key = "<leader>dt";
        action = "<CMD>Trouble diagnostics toggle<CR>";
        options.desc = "Toggle trouble";
      }
    ];
    plugins = {
      nvim-surround.enable = true;
      autoclose = {
        enable = true;
        # Don't close when touching a non-whitespace character
        settings.options.disable_when_touch = true;
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
            {
              name = "nvim_lsp";
            }
            {
              name = "path";
            }
            {
              name = "buffer";
            }
          ];
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };
      fugitive.enable = true;
      gitsigns.enable = true;
      trouble.enable = true;
      web-devicons.enable = true; # For trouble

      treesitter.enable = true;
      treesitter-context.enable = true;

      # treesitter-textobjects.enable = true; TODO: this would be cool
      lsp-format = {
        enable = true;
        lspServersToEnable = ["ruff" "pylsp" "nil_ls"];
      };
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources.formatting.prettier = {
          enable = true;
          disableTsServerFormatter = false; # We've handled this by setting lspServersToEnable
        };
      };
      dap = {
        enable = true;
      };
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
        inlayHints = true;
        servers = {
          pylsp.enable = true;
          ruff.enable = true;
          eslint.enable = true;
          nil_ls = {
            enable = true;
            settings.formatting.command = ["alejandra"];
          };
          ts_ls.enable = true;
          jsonls.enable = true;
        };
      };
      oil = {
        enable = true;
        settings = {
          # Don't perm-delete files first
          delete_to_trash = true;
          use_default_keymaps = true;
          # Use LSP to auto-change names of files we modify
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
