local ls = require("luasnip")
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local M = {}

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  local s = ls.extend_decorator.apply(ls.snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  return {
    parse_snippet({ trig = "mk", name = "Math" }, "\\( ${1:${TM_SELECTED_TEXT}} \\)$0"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "\\[\n\t${1:${TM_SELECTED_TEXT}}\n.\\] $0"),
    s(
      { trig = "li;", name = "URL" },
      fmta(
        [[ 
        \href{<>}{\textcolor{blue}{<>}}%
        ]],
        {
          f(function()
            return vim.fn.getreg("+")
          end, {}),
          i(0),
        }
      )
    ),
  }
end

return M
