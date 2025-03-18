local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

local utils = require("luasnip-latex-snippets.util.utils")
local pipe = utils.pipe
local no_backslash = utils.no_backslash

local M = {}

-- Greek letters mapping (lowercase)
local greek_letters = {
  a = "alpha",
  b = "beta",
  g = "gamma",
  d = "delta",
  e = "epsilon",
  z = "zeta",
  h = "eta",
  i = "iota",
  k = "kappa",
  l = "lambda",
  m = "mu",
  n = "nu",
  x = "xi",
  o = "omicron",
  r = "rho",
  s = "sigma",
  t = "tau",
  u = "upsilon",
  p = "phi",
  c = "chi",
  y = "psi",
  w = "omega",
  f = "theta",
}

-- Create uppercase version for capital Greek letters
local uppercase_greek = {}
for k, v in pairs(greek_letters) do
  uppercase_greek[k:upper()] = v:gsub("^%l", string.upper)
end

-- Special variants
local variant_greek = {
  ve = "varepsilon",
  vp = "varphi",
  vr = "varrho",
  vf = "vartheta",
}

function M.retrieve(is_math)
  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ is_math, no_backslash }),
  }) --[[@as function]]

  local with_priority = ls.extend_decorator.apply(parse_snippet, {
    priority = 10,
  }) --[[@as function]]

  local snippets = {}

  -- Add lowercase Greek letter snippets
  for letter, name in pairs(greek_letters) do
    table.insert(
      snippets,
      with_priority({ trig = ";" .. letter, name = name }, "\\" .. name .. " ")
    )
  end

  -- Add uppercase Greek letter snippets
  for letter, name in pairs(uppercase_greek) do
    table.insert(
      snippets,
      with_priority({ trig = ";" .. letter, name = name }, "\\" .. name .. " ")
    )
  end

  -- Add variant Greek letter snippets
  for trig, name in pairs(variant_greek) do
    table.insert(snippets, with_priority({ trig = ";" .. trig, name = name }, "\\" .. name .. " "))
  end

  table.insert(snippets, with_priority({ trig = "asin", name = "arcsin" }, "\\arcsin "))
  table.insert(snippets, with_priority({ trig = "atan", name = "arctan" }, "\\arctan "))
  table.insert(snippets, with_priority({ trig = "asec", name = "arcsec" }, "\\arcsec "))
  table.insert(snippets, parse_snippet({ trig = "set", name = "set" }, [[ \\{$1\\} $0 ]]))
  table.insert(
    snippets,
    parse_snippet({ trig = "fun", name = "function map" }, "f \\colon $1 \\R \\to \\R \\colon $0")
  )
  table.insert(
    snippets,
    parse_snippet(
      { trig = "abs", name = "absolute value \\abs{}" },
      "\\abs{${1:${TM_SELECTED_TEXT}}}$0"
    )
  )

  return snippets
end

return M
