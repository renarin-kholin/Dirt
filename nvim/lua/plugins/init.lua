return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },

  {
    "vyfor/cord.nvim",
    lazy = false,
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- See Configuration section for options
    },
  },
  {
    "nvim-java/nvim-java",
    config = function()
      require("java").setup()
      vim.lsp.enable "jdtls"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^7", -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_general_viewer = "okular"
    end,
  },
  {
    "jbyuki/instant.nvim",
    cmd = {
      "InstantStartServer",
      "InstantStartSingle",
      "InstantStartSession",
      "InstantJoinSingle",
      "InstantJoinSession",
      "InstantStop",
    },
    keys = {
      {
        "<leader>is",
        function()
          -- if already hosting, warn and bail
          if vim.g.instant_status then
            vim.notify("Already in a session. Stop it first with \\ix", vim.log.levels.WARN)
            return
          end

          vim.ui.input({ prompt = "Port (default 8080): " }, function(port)
            if port == nil then
              return
            end
            port = port ~= "" and port or "8080"

            -- check if port is already in use
            local handle = io.popen("lsof -i :" .. port .. " -t 2>/dev/null")
            local result = handle:read "*a"
            handle:close()

            if result ~= "" then
              vim.notify("Port " .. port .. " is already in use. Try a different port.", vim.log.levels.ERROR)
              return
            end

            local ok, err = pcall(vim.cmd, "InstantStartServer 0.0.0.0 " .. port)
            if not ok then
              vim.notify("Failed to start server: " .. err, vim.log.levels.ERROR)
              return
            end

            vim.defer_fn(function()
              local ok2, err2 = pcall(vim.cmd, "InstantStartSession localhost " .. port)
              if not ok2 then
                vim.notify("Server started but session failed: " .. err2, vim.log.levels.ERROR)
                pcall(vim.cmd, "InstantStop")
                return
              end

              local ip = vim.fn.system("hostname -I"):match "%S+"
                or vim.fn.system("ipconfig getifaddr en0"):gsub("%s+", "")
              vim.g.instant_status = true
              vim.notify("⚡ Session started — share with pair: " .. ip .. ":" .. port, vim.log.levels.INFO)
            end, 300)
          end)
        end,
        desc = "Instant: Start session (host)",
      },
      {
        "<leader>ij",
        function()
          if vim.g.instant_status then
            vim.notify("Already in a session. Stop it first with \\ix", vim.log.levels.WARN)
            return
          end

          vim.ui.input({ prompt = "Host IP: " }, function(ip)
            if not ip or ip == "" then
              vim.notify("No IP entered, aborting.", vim.log.levels.WARN)
              return
            end

            vim.ui.input({ prompt = "Port (default 8080): " }, function(port)
              if port == nil then
                return
              end
              port = port ~= "" and port or "8080"

              local ok, err = pcall(vim.cmd, "InstantJoinSession " .. ip .. " " .. port)
              if not ok then
                vim.notify("Failed to join session: " .. err, vim.log.levels.ERROR)
                return
              end

              vim.g.instant_status = true
              vim.notify("⚡ Joined session at " .. ip .. ":" .. port, vim.log.levels.INFO)
            end)
          end)
        end,
        desc = "Instant: Join session (guest)",
      },
      {
        "<leader>ix",
        function()
          if not vim.g.instant_status then
            vim.notify("No active session.", vim.log.levels.WARN)
            return
          end

          local ok, err = pcall(vim.cmd, "InstantStop")
          if not ok then
            vim.notify("Error stopping session: " .. err, vim.log.levels.ERROR)
            return
          end

          vim.g.instant_status = false
          vim.notify("Session stopped.", vim.log.levels.INFO)
        end,
        desc = "Instant: Stop session",
      },
      {
        "<leader>ii",
        function()
          -- try hostname -I first (linux), fall back to ipconfig (mac)
          local ip = vim.fn.system("hostname -I 2>/dev/null"):match "%S+"
          if not ip or ip == "" then
            ip = vim.fn.system("ipconfig getifaddr en0 2>/dev/null"):gsub("%s+", "")
          end
          if not ip or ip == "" then
            vim.notify("Could not determine IP address.", vim.log.levels.ERROR)
            return
          end
          vim.notify("Your IP: " .. ip, vim.log.levels.INFO)
        end,
        desc = "Instant: Show my IP",
      },
    },
  },
  {
    "yetone/avante.nvim",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = vim.fn.has "win32" ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- this file can contain specific instructions for your project
      instructions_file = "avante.md",
      -- for example
      provider = "opencode",
      providers = {
        ollama = {
          model = "qwq:32b",
          is_env_set = function()
            return require("avante.providers.ollama").check_endpoint_alive
          end,
        },
        --   claude = {
        --     endpoint = "https://api.anthropic.com",
        --     model = "claude-sonnet-4-20250514",
        --     timeout = 30000, -- Timeout in milliseconds
        --     extra_request_body = {
        --       temperature = 0.75,
        --       max_tokens = 20480,
        --     },
        --   },
        --   moonshot = {
        --     endpoint = "https://api.moonshot.ai/v1",
        --     model = "kimi-k2-0711-preview",
        --     timeout = 30000, -- Timeout in milliseconds
        --     extra_request_body = {
        --       temperature = 0.75,
        --       max_tokens = 32768,
        --     },
        --   },
        -- },
        {
          acp_providers = {
            ["opencode"] = {
              command = "opencode",
              args = { "acp" },
            },
          },
        },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-mini/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "stevearc/dressing.nvim", -- for input provider dressing
        "folke/snacks.nvim", -- for input provider snacks
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          "MeanderingProgrammer/render-markdown.nvim",
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
  },
  -- test new blink

  -- { import = "nvchad.blink.lazyspec" },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },
  {
    {
      "christoomey/vim-tmux-navigator",
      lazy = false,
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      init = function()
        -- Reusable function to register keymaps in different contexts
        local function set_keymaps()
          vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>TmuxNavigateLeft<cr>")
          vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>TmuxNavigateDown<cr>")
          vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>TmuxNavigateUp<cr>")
          vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>TmuxNavigateRight<cr>")
        end

        -- Register once globally
        set_keymaps()

        -- Re-register for terminal buffers to prevent literal command injection
        vim.api.nvim_create_autocmd("TermOpen", {
          callback = set_keymaps,
        })
      end,
    },
  },
  { "kosayoda/nvim-lightbulb", lazy = false, autocmd = { enabled = true } },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
