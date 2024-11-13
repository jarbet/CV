function Block(el)
    -- Check if the block is of type Para or Plain
    if el.t == "Para" or el.t == "Plain" then
        -- Iterate through each element in the block
        for k, _ in ipairs(el.content) do
            -- Check if the element is a string (text) and if the text contains "Arbet"
            if el.content[k].t == "Str" then
                -- If the text contains "Arbet", replace it with the bolded version
                if el.content[k].text:find("Arbet,") then
                    -- Replace "Arbet" with bolded "Arbet"
                    el.content[k] = pandoc.Strong(pandoc.Str("Arbet,"))
                end
            end
        end
    end
    return el
end
