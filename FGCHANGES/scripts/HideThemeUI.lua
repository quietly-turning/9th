-- ------------------------------------------------------
-- helper function for detecting if the player is in edit mode
-- returns true or false

local function IsEditMode()
  local screen = SCREENMAN:GetTopScreen()
  if not screen then
    lua.ReportScriptError("helpers.IsEditMode() check failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
    return nil
  end

  return (THEME:GetMetric(screen:GetName(), "Class") == "ScreenEdit")
end

-- ------------------------------------------------------
-- hides all children layers of ScreenGameplay
-- except for "SongForeground", "PlayerP1", and "PlayerP2"
-- intended to be used with ScreenGameplay

local function HideThemeUI()
  local screen = SCREENMAN:GetTopScreen()
  if not screen then
    lua.ReportScriptError("HideThemeUI() failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
    return nil
  end

  -- don't hide the theme's UI in EditMode
  if IsEditMode() then
    return
  end

  for name,layer in pairs(screen:GetChildren()) do
    if not (name == "SongForeground" or name == "PlayerP1" or name == "PlayerP2") then
      layer:visible(false)
    end
  end
end

return Def.Actor{
  OnCommand=function(self) HideThemeUI() end
}
