---------------------------------------------------------------------------------------------------
-- TECHNOLOGY   (__spaceExplorationResearchAdapter__/prototypes/technology.lua)                         --
---------------------------------------------------------------------------------------------------

-- This code is meant to lower cost of research for all technologies, whether standard or 
-- infinite, vanilla or modded, by a user-defined factor.

-- It does not rely on specific mod references. It simple iterates over the internal list of
-- technologies and does so at the final mod loading stage (using data-final-fixes.lua).

-- For the rare exceptions, exclusions can be added through a text-field in settings.

-- REQUIREMENTS ----------------------------------------------------------------------------------------------------------

require('functions') -- for table_contains(table, element)

-- STARTUP SETTINGS -------------------------------------------------------------------------------

-- The factor by which the technology cost is changed.
local cost_factor_list ={

 [1] = settings.startup["Nauvis-research-cost-multiplyer"].value,
 [2] = settings.startup["Space-research-cost-multiplyer"].value,
 [3] = settings.startup["Redacted-research-cost-multiplyer"].value
}
-- Comma-separated list of tech ID's to be excluded from cost change.
local ex_tech_list  = settings.startup["exclude-tech-from-cost"].value
-- list of space reserch packs
local space_science_list = {
    [1] = "se-" .. "material-science-pack-1",
    [2] = "se-" .. "material-science-pack-2",
    [3] = "se-" .. "material-science-pack-3",
    [4] = "se-" .. "material-science-pack-4",
    [5] = "se-" .. "energy-science-pack-1",
    [6] = "se-" .. "energy-science-pack-2",
    [7] = "se-" .. "energy-science-pack-3",
    [8] = "se-" .. "energy-science-pack-4",
    [9] = "se-" .. "biological-science-pack-1",
    [10] = "se-" .. "biological-science-pack-2",
    [11] = "se-" .. "biological-science-pack-3",
    [12] = "se-" .. "biological-science-pack-4",
    [13] = "se-" .. "astronomic-science-pack-1",
    [14] = "se-" .. "astronomic-science-pack-2",
    [15] = "se-" .. "astronomic-science-pack-3",
    [16] = "se-" .. "astronomic-science-pack-4",
    [17] = "space-science-pack",
    [18] = "utility-science-pack",
    [19] = "production-science-pack"


}

local redacted_science_list = {
    [1] = "se-" .. "deep-space-science-pack-1",
    [2] = "se-" .. "deep-space-science-pack-2",
    [3] = "se-" .. "deep-space-science-pack-3",
    [4] = "se-" .. "deep-space-science-pack-4"
}

-- EXCLUDED TECHNOLOGIES --------------------------------------------------------------------------

-- This code parses the comma-separated list of excluded tech ID's, checks if they exist, then adds
-- them to the internal list of exclusions.

local exclusions = {}

if ex_tech_list ~= nil and type(ex_tech_list) == "string" then
    for word in string.gmatch(ex_tech_list, '([^,]+)') do
        for _, tech in pairs(data.raw["technology"]) do
            if tech.name == word then
                table.insert(exclusions, word)
            end
        end
    end
end

-- TECHNOLOGY RESEARCH COST SCALING ---------------------------------------------------------------

-- Changes research cost for all listed technologies by a factor
for tech_name, tech in pairs(data.raw["technology"])
do
    if not table_contains(exclusions, tech_name) -- [n1]
    then
        if tech.unit ~= nil
        then

            -- STANDARD -- Changes research cost for standard technologies by a factor
            local count = tech.unit.count
            if count ~= nil and type(count) == "number" then
                local cost_index = 1
                local ingredients = tech.unit.ingredients
                for index, ingredient in pairs(ingredients) do
                    if table_contains(redacted_science_list, ingredients[index][1]) then
                        cost_index = 3
                        break
                    end
                    if table_contains(space_science_list, ingredients[index][1]) then
                        cost_index = 2
                    end
                end

                tech.unit.count = math.max(math.floor(count * cost_factor_list[cost_index]),1) -- [n2]
                -- INFINITE -- Changes research cost for infinite technologies by a factor
                local formula = tech.unit.count_formula
                if formula ~= nil and type(formula) == "string" then
                    tech.unit.count_formula = "(" .. formula .. ")*" .. tostring(cost_factor_list[cost_index]) -- [n3]
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