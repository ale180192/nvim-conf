return {
  -- Deshabilitar solo el explorador de snacks.nvim (según documentación oficial)
  {
    "snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
        open_cmd = "edit",
        root_dir = "cwd",
        show_hidden = false,
        follow_current_file = false,
        hijack_netrw = false,
      },
    },
  },
  
  -- Configurar bufferline con picker
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        pick = {
          alphabet = "abcdefghijklmnopqrstuvwxyz", -- Solo minúsculas para más buffers
        },
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_buffer_icons = true,
        show_buffer_default_icon = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_buffer_icons = true,
        show_buffer_default_icon = true,
      },
    },
    keys = {
      { "<leader>bp", ":BufferLinePick<CR>", desc = "Pick Buffer" },
      { "<leader>bc", ":BufferLinePickClose<CR>", desc = "Pick Buffer to Close" },
    },
    config = function()
      -- Asegurar que el picker esté habilitado
      require("bufferline").setup({
        options = {
          pick = {
            alphabet = "abcdefghijklmnopqrstuvwxyz",
          },
        },
      })
    end,
  },

  -- we activate and configure telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", ":Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Find Buffers" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Find Help" },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
    end,
  },
  -- Plugin para búsqueda y reemplazo avanzado
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>sr", ":Spectre<CR>", desc = "Search and Replace" },
      { "<leader>sw", ":lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search Current Word" },
    },
    config = function()
      require("spectre").setup({
        mapping = {
          ["send_to_qf"] = {
            map = "<leader>q",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix",
          },
        },
      })
    end,
  },
  
  -- Configurar Mason para evitar errores
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  
  -- Plugin para manejo de Poetry
  {
    "karloskar/poetry-nvim",
    ft = "python",
    config = function()
      require("poetry-nvim").setup()
    end,
    -- Forzar activación en proyectos de Poetry
    cond = function()
      return vim.fn.filereadable(vim.fn.getcwd() .. "/pyproject.toml") == 1
    end,
  },

  -- Configurar LSP para Python (ahora con poetry-nvim)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Función para obtener el path de Python de Poetry
            local function get_poetry_python_path()
              local current_dir = vim.fn.getcwd()
              
              -- Verificar si poetry-nvim configuró VIRTUAL_ENV
              local virtual_env = vim.env.VIRTUAL_ENV
              if virtual_env then
                local python_path = virtual_env .. "/bin/python"
                if vim.fn.filereadable(python_path) == 1 then
                  return python_path
                end
              end
              
              -- Fallback: buscar manualmente el entorno de Poetry
              if vim.fn.filereadable(current_dir .. "/pyproject.toml") == 1 then
                local poetry_cache = vim.fn.expand("~/Library/Caches/pypoetry/virtualenvs")
                if vim.fn.isdirectory(poetry_cache) == 1 then
                  -- Buscar el entorno correcto (NJddIv5g)
                  local handle = io.popen("find " .. poetry_cache .. " -name 'learning-api-NJddIv5g*' -type d 2>/dev/null | head -1")
                  if handle then
                    local venv_dir = handle:read("*a"):gsub("%s+", "")
                    handle:close()
                    
                    if venv_dir and venv_dir ~= "" then
                      local python_path = venv_dir .. "/bin/python"
                      if vim.fn.filereadable(python_path) == 1 then
                        return python_path
                      end
                    end
                  end
                end
              end
              
              return nil
            end
            
            local python_path = get_poetry_python_path()
            if python_path then
              client.config.settings.python.defaultInterpreterPath = python_path
              client.config.settings.python.pythonPath = python_path
              vim.notify("Python LSP configured with Poetry env: " .. python_path, vim.log.levels.INFO)
            else
              vim.notify("Could not find Poetry environment", vim.log.levels.WARN)
            end
          end,
        },
      },
    },
  },
  
  -- Instalar window-picker para neo-tree
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "v1.*",
    config = function()
      require("window-picker").setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
          bo = {
            filetype = { "neo-tree", "neo-tree-popup", "notify" },
            buftype = { "terminal", "quickfix" },
          },
        },
        other_win_hl_color = "#e35e4f",
      })
    end,
  },
  
  -- Configurar neo-tree como explorador principal
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
      { "<leader>o", ":Neotree focus<CR>", desc = "Focus Explorer" },
      { "<leader>E", ":Explore<CR>", desc = "Open Netrw" }, -- Atajo para netrw como respaldo
    },
    config = function()
      -- Asegurar que netrw esté habilitado
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      
      -- LazyVim maneja automáticamente los atajos de LSP y snacks
      

      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        filesystem = {
          bind_to_cwd = false,
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
        window = {
          position = "left",
          width = 30,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false,
            },
            ["<2-LeftMouse>"] = "open_with_window_picker",
            ["<cr>"] = "open_with_window_picker",
            ["<esc>"] = "revert_preview",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = {
              "add",
              config = {
                show_path = "none",
              },
            },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          },
        },
        default_component_configs = {
          indent = {
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "󰄱",
              conflict = "󰐙",
            },
          },
        },
        commands = {
          parent_or_close = function(state)
            local node = state.tree:get_node()
            if (node.type == "directory" or node:has_children()) and node:is_expanded() then
              state.commands.toggle_node(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          child_or_open = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" or node:has_children() then
              if not node:is_expanded() then
                state.commands.toggle_node(state)
              else
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            else
              state.commands.open_with_window_picker(state)
            end
          end,
        },
      })
    end,
  },
  
  -- Configurar scrolloff para centrar el cursor
  {
    "LazyVim/LazyVim",
    opts = {
      -- Configuración adicional
    },
  },
  
  -- La configuración de scrolloff se movió a lua/config/options.lua
}
