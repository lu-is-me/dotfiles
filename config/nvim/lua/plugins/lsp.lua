return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    opts.servers["*"] = opts.servers["*"] or {}
    opts.servers["*"].keys = opts.servers["*"].keys or {}
    table.insert(opts.servers["*"].keys, {
      "gV",
      function()
        vim.cmd("vsplit")
        vim.lsp.buf.definition()
      end,
      desc = "Open definition in split",
      has = "definition", -- only set if server supports it
    })

    opts.servers.qmlls = {
      cmd = { "qmlls", "-E" },
    }
    opts.servers.tinymist = {
      single_file_support = true,
      settings = {
        formatterMode = "typstyle",
      },
    }

    -- LanguageTool als LSP: Grammatik + Rechtschreibung fuer typst/markdown/tex.
    -- Teilt sich das Woerterbuch mit Neovims `zg` (siehe config/autocmds.lua):
    -- <git-root>/spell/de.utf-8.add. Nach einem `zg` einmal :LspRestart ltex_plus.
    opts.servers.ltex_plus = {
      -- Das dokumentierte ":/pfad/datei"-Syntax fuer externe Woerterbuecher ist ein
      -- Feature der VS-Code-Extension, nicht des Servers -- ueber LSP wird es still
      -- ignoriert. Also selbst einlesen und die Woerter inline uebergeben.
      --
      -- Muss in before_init passieren: der Projektpfad steht erst beim Serverstart
      -- fest, die Settings aber schon zum Initialize. Die vorhandene Tabelle wird
      -- in-place ergaenzt -- ein Ersetzen wuerde `client.settings` nicht treffen.
      before_init = function(_, config)
        if not config.root_dir then
          return
        end
        local ok, lines = pcall(vim.fn.readfile, config.root_dir .. "/spell/de.utf-8.add")
        if not ok then
          return
        end
        local words = {}
        for _, line in ipairs(lines) do
          -- Vim haengt Flags an ("wort/!" = als falsch markiert); LTeX will das blanke Wort.
          local word = vim.trim(line):gsub("/.*$", "")
          if word ~= "" and not vim.startswith(word, "#") then
            words[#words + 1] = word
          end
        end
        config.settings.ltex.dictionary = { ["de-CH"] = words }
      end,
      settings = {
        ltex = {
          language = "de-CH",
          -- "edit" pruefte bei jedem Tastendruck -- zu langsam fuer lange Dokumente.
          checkFrequency = "save",
          additionalRules = { enablePickyRules = true },
          disabledRules = {
            ["de-CH"] = { "WHITESPACE_RULE" },
          },
        },
      },
    }
  end,
}
