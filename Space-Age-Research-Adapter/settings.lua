---------------------------------------------------------------------------------------------------
-- SETTINGS   (__spaceAgeResearchAdapter__/settings.lua)                                        --
---------------------------------------------------------------------------------------------------

-- STARTUP SETTINGS -------------------------------------------------------------------------------

data:extend({

  { -- This option determines the factor by which Nauvis technology cost is changed.
    type = "double-setting",
    name = "Nauvis-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.001, -- [n1] 
    maximum_value = 10000,
    order = 'a'
  },
  
  { -- This option determines the factor by which space technology cost is changed.
    type = "double-setting",
    name = "Space-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.001, 
    maximum_value = 10000,
    order = 'b'
  },

  { -- This option determines the factor by which infinite technology cost is changed.
    type = "double-setting",
    name = "Infinite-research-cost-multiplier",
    setting_type = "startup",
    default_value = 1,
    minimum_value = 0.001, 
    maximum_value = 10000,
    order = 'c'
  },

  { -- Option to manually type in ID of technologies to be excluded from effect of cost factor. -- [n3]
  name = "exclude-tech-from-cost",
  type = "string-setting",
  setting_type  = "startup",
  default_value = "",
  allow_blank = true,
  auto_trim = true,
  order = "d"
  }

})

-- FOOTNOTES --------------------------------------------------------------------------------------

-- [n1] Count value of 0 not accepted by game! It will look for count_formula instead, and fail!
--      Values lower than about 0.0001 also throws a strange error. Trying to stay on the safe side
--      with a lower bound of 0.01. See notes in technology.lua.
-- [n3] Must be written as a comma-separated list with no space in between.