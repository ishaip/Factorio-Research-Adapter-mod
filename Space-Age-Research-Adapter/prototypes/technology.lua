---------------------------------------------------------------------------------------------------
-- TECHNOLOGY   (__spaceAgeResearchAdapter__/prototypes/technology.lua)                         --
---------------------------------------------------------------------------------------------------

-- This code is meant to lower cost of research for all technologies, whether standard or 
-- infinite, vanilla or modded, by a user-defined factor.

-- It does not rely on specific mod references. It simple iterates over the internal list of
-- technologies and does so at the final mod loading stage (using data-final-fixes.lua).

-- For the rare exceptions, exclusions can be added through a text-field in settings.

-- REQUIREMENTS ----------------------------------------------------------------------------------------------------------

require("functions/functions") -- for table_contains(table, element)

-- STARTUP SETTINGS -------------------------------------------------------------------------------

-- The factor by which the technology cost is changed.
local cost_factor_list = {
    settings.startup["Nauvis-research-cost-multiplyer"].value,
    settings.startup["Space-research-cost-multiplyer"].value,
    settings.startup["Infinite-research-cost-multiplyer"].value
}

local ex_tech_list = settings.startup["exclude-tech-from-cost"].value

local space_science_list = {
    "space-science-pack",
    "metallurgic-science-pack",
    "electromagnetic-science-pack",
    "agricultural-science-pack",
    "cryogenic-science-pack",
    "promethium-science-pack"
}


-- Excluded technologies
local exclusions = {}
if type(ex_tech_list) == "string" and ex_tech_list ~= "" then
    for word in string.gmatch(ex_tech_list, "[^,]+") do
        word = word:match("^%s*(.-)%s*$") -- trim whitespace
        for _, tech in pairs(data.raw["technology"]) do
            if tech.name == word then
                table.insert(exclusions, word)
                break
            end
        end
    end
end

-- Technology research cost scaling
for tech_name, tech in pairs(data.raw["technology"]) do
    if not table_contains(exclusions, tech_name) then
        if tech.unit then
            local count = tech.unit.count
            if type(count) == "number" then
                local cost_index = 1
                -- Check for infinite research
                if tech.max_level == "infinite" or type(tech.unit.count_formula) == "string" then
                    cost_index = 3
                else
                    local ingredients = tech.unit.ingredients
                    if type(ingredients) == "table" then
                        for _, ingredient in ipairs(ingredients) do
                            local ing_name = ingredient[1]
                            if table_contains(space_science_list, ing_name) then
                                cost_index = 2
                            end
                        end
                    end
                end
                tech.unit.count = math.max(math.floor(count * tonumber(cost_factor_list[cost_index])), 1)
                local formula = tech.unit.count_formula
                if type(formula) == "string" then
                    tech.unit.count_formula = "(" .. formula .. ")*" .. tostring(cost_factor_list[cost_index])
                end
            end
        end
    end
end


-- FOOTNOTES --------------------------------------------------------------------------------------

-- [n1] The function will stop its own 'for'-loop and return with a value of true, if the current
--      item in the main list is also found in the exclusion list.
-- [n2] Minimum value allowed for count has been set to 1, otherwise the game might crash.
--      (The mod cheaper-landfill has a tech cost of 1, and reducing that makes the game think the
--      value is negative. No idea why. And if the value of count somehow ends up being zero, the
--      game will look for count_formula instead - just like if it was nil - and fail!) 
-- [n3] The result is not rounded, because count_formula allows floating numbers within its string
--      value. The game handles rounding on its own! It can't handle a cost_factor of less than
--      about 0.0001, though, so input has to be limited to a minimum value higher than that.