---------------------------------------------------------------------------------------------------
-- SETTINGS   (__spaceExplorationResearchAdapter__/settings.lua)                                        --
---------------------------------------------------------------------------------------------------

-- STARTUP SETTINGS -------------------------------------------------------------------------------

data:extend({

  { -- This option determines the factor by which Nauvis technology cost is changed.
    type = "double-setting",
    name = "Nauvis-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.01, -- [n1] 
    maximum_value = 1000,
    order = 'a'
  },
  
  { -- This option determines the factor by which Space technology cost is changed.
    type = "double-setting",
    name = "Space-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.01, 
    maximum_value = 1000,
    order = 'b'
  },

  { -- This option determines the factor by which Redacted technology cost is changed.
    type = "double-setting",
    name = "Redacted-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.01,
    maximum_value = 1000,
    order = 'c'
  },

  { -- This option determines the factor by which Infinite technology cost is changed.
    type = "double-setting",
    name = "Infinite-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.001, 
    maximum_value = 10000,
    order = 'd'
  },

  { -- Option to manually type in the ID of technologies to be excluded from the effect of the cost factor. -- [n3]
    name = "exclude-tech-from-cost",
    type = "string-setting",
    setting_type  = "startup",
    default_value = "creative-mod_void-technology",
    allow_blank = true,
    auto_trim = true,
    order = "e"
  }

})

-- FOOTNOTES --------------------------------------------------------------------------------------

-- [n1] Count value of 0 not accepted by game! It will look for count_formula instead, and fail!
--      Values lower than about 0.0001 also throw a strange error. Trying to stay on the safe side
--      with a lower bound of 0.01. See notes in technology.lua.
-- [n3] Must be written as a comma-separated list with no spaces in between.