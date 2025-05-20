-----------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS -- (__ConfigurableResearchCost__/functions.lua)    													 --
-----------------------------------------------------------------------------------------------------------------------

-- Standard function for checking whether a value is in a list
function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end