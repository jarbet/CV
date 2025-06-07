function Inlines(inlines)
  local i = 1
  while i <= (#inlines - 1) do
    local a = inlines[i]
    local b = inlines[i+1]
    local c = inlines[i+2]

    if a.t == "Str" and a.text == "Arbet," and b and b.t == "Space" then
      -- Case 1: Arbet, J.,
      if c and c.t == "Str" and c.text == "J.," then
        inlines[i] = pandoc.Strong({
          pandoc.Str("Arbet,"),
          pandoc.Space(),
          pandoc.Str("J.")
        })
        inlines[i+1] = pandoc.Str(",") -- just the comma
        table.remove(inlines, i+2)     -- remove the original "J.,"
      -- Case 2: Arbet, J.
      elseif c and c.t == "Str" and c.text == "J." then
        inlines[i] = pandoc.Strong({
          pandoc.Str("Arbet,"),
          pandoc.Space(),
          pandoc.Str("J.")
        })
        table.remove(inlines, i+1) -- remove Space
        table.remove(inlines, i+1) -- remove J.
      end
    end
    i = i + 1
  end
  return inlines
end
