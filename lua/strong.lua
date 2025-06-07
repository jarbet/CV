function Inlines(inlines)
  local i = 1
  while i <= (#inlines - 2) do
    local a = inlines[i]
    local b = inlines[i+1]
    local c = inlines[i+2]

    if a.t == "Str" and a.text == "Arbet," and
       b.t == "Space" and
       c.t == "Str" and c.text == "J.," then

      -- Replace three tokens (Arbet, + Space + J.,) with one bolded token
      inlines[i] = pandoc.Strong({
        pandoc.Str("Arbet,"),
        pandoc.Space(),
        pandoc.Str("J.,")
      })

      -- Remove the next two tokens (Space + J.,)
      table.remove(inlines, i+1)
      table.remove(inlines, i+1)

      -- No increment because we modified the table
    else
      i = i + 1
    end
  end
  return inlines
end
