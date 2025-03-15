local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

local M = {}

M.decorator = {}

local postfix_trig = function(match)
  return string.format("(%s)", match)
end

local postfix_node = f(function(_, snip)
  return string.format("\\%s ", snip.captures[1])
end, {})

local build_snippet = function(trig, node, match, priority, name)
  return s({
    name = name and name(match) or match,
    trig = trig(match),
    priority = priority,
  }, vim.deepcopy(node))
end

local build_with_priority = function(trig, node, priority, name)
  return function(match)
    return build_snippet(trig, node, match, priority, name)
  end
end

local postfix_completions = function()
  local re = "sin|cos|tan|csc|sec|cot|ln|log|exp|star|perp|int"

  local build = build_with_priority(postfix_trig, postfix_node)
  return vim.tbl_map(build, vim.split(re, "|"))
end

local snippets = {}

function M.retrieve(is_math)
  local utils = require("luasnip-latex-snippets.util.utils")
  local pipe = utils.pipe
  local no_backslash = utils.no_backslash

  M.decorator = {
    wordTrig = true,
    trigEngine = "pattern",
    condition = pipe({ is_math, no_backslash }),
  }

  s = ls.extend_decorator.apply(ls.snippet, M.decorator) --[[@as function]]

  vim.list_extend(snippets, postfix_completions())
  vim.list_extend(snippets, { build_snippet(postfix_trig, postfix_node, "q?quad", 200) })

  return snippets
end

return M
