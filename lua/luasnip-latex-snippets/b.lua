local ls = require("luasnip")

local M = {}

function M.retrieve(not_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe

  local conds = require("luasnip.extras.expand_conditions")
  local condition = pipe({ conds.line_begin, not_math })

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = condition,
  }) --[[@as function]]

  return {
    parse_snippet(
      { trig = "col", name = "multicolumn" },
      "\\begin{multicols}{2}\n\\columnseprule=1pt\n\t$0\n\\end{multicols}"
    ),

    parse_snippet(
      { trig = "box", name = "box" },
      "\\begin{Tasks}[${2:blue!20}]{${1:Title}}\n$0\n\\end{Tasks}"
    ),

    parse_snippet(
      { trig = "code", name = "code" },
      "\\begin{lstlisting}[language=${1:Python}]\n$0\n\\end{lstlisting}"
    ),
  }
end

return M
