-- if you contribute, please tick up the version number :)
local helpers = {
    version = "1.0",
    name    = "SubtitleHelpers",
    contributors = {
        "quietly-turning",
    }
}

-- ------------------------------------------------------
-- function for detecting edit mode
-- returns true or false

helpers.IsEditMode = function()
   local screen = SCREENMAN:GetTopScreen()
    if not screen then
      lua.ReportScriptError("helpers.IsEditMode() check failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
      return nil
   end

   return (THEME:GetMetric(screen:GetName(), "Class") == "ScreenEdit")
end

-- ------------------------------------------------------
-- hides all children layers of ScreenGameplay except for "SongForeground", "PlayerP1", and "PlayerP2"
-- intended to be used with ScreenGameplay

helpers.HideUI = function()
   local screen = SCREENMAN:GetTopScreen()
   if not screen then
      lua.ReportScriptError("helpers.HideUI() failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
      return nil
   end

   -- don't hide the theme's UI in EditMode
   if helpers.IsEditMode() then
      return
   end

   for name,layer in pairs(screen:GetChildren()) do
      if not (name == "SongForeground" or name == "PlayerP1" or name == "PlayerP2") then
         layer:visible(false)
      end
   end
end

-- ------------------------------------------------------
-- Takes a string and generates a case insensitive Lua string pattern.
-- e.g. "ini" returns "[Ii][Nn][Ii]"
--
-- originally appeared in Simply Love/Scripts/SL-ChartParser.lua

helpers.MixedCasePattern = function(str)
	local t = {}
	for c in str:gmatch(".") do
		t[#t+1] = "[" .. c:upper() .. c:lower() .. "]"
	end
	return table.concat(t, "")
end

-- ------------------------------------------------------
-- WideScale() is copied from Simply Love/Scripts/SL-Helpers.lua
-- Useful for writing one line of code that scales a number depending on the player's current theme aspect ratio.
-- This clamps the the scaled value to not exceed whatever is provided as AR16_9, which would otherwise happen
-- with, for example, ultrawide (21:9) monitors.

helpers.WideScale = function(AR4_3, AR16_9)
	return clamp(scale( SCREEN_WIDTH, 640, 854, AR4_3, AR16_9 ), AR4_3, AR16_9)
end

return helpers