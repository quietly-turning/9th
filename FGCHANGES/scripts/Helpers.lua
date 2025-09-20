-- if you contribute, please tick up the version number :)
local helpers = {
    version = "1.0",
    name    = "SubtitleHelpers",
    contributors = {
        "quietly-turning",
    }
}

-- ------------------------------------------------------
-- based on global split() from _fallback/Scripts/00 init.lua
-- hackishly modified to include a numeric "stop" value
-- as in: stop splitting the provided `text` if you've already split `stop` number of times

helpers.split = function(delimiter, text, stop)
   local list = {}
   local pos = 1

  if type(stop)~="number" then stop=9999 end

   while 1 do
      local first,last = string.find(text, delimiter, pos)
      if first then
         table.insert(list, string.sub(text, pos, first-1))
         pos = last+1
         -- if we've reach our limit of splits
         -- insert the remaining string until its end and break
         if #list >= stop-1 then
            table.insert(list, string.sub(text, pos))
            break
         end
      else
         table.insert(list, string.sub(text, pos))
         break
      end
   end
   return list
end

-- ------------------------------------------------------
-- StrToSecs converts a stringified timestamp formatted like "00:02:15.10"
-- and returns it as a numeric value of seconds

helpers.StrToSecs = function(s)
   local hour, min, sec = s:match("(%d+):(%d%d):(%d%d%.%d+)")
   hour = hour or 0
   min  = min  or 0
   sec  = sec  or 0
   return ((hour*60*60)+(min*60)+(sec))
end

-- ------------------------------------------------------
-- function for detecting edit mode
-- returns true or false

helpers.IsEditMode = function()
   local screen = SCREENMAN:GetTopScreen()
    if not screen then
      lua.ReportScriptError("Helpers.IsEditMode() check failed to run because there is no Screen yet.")
      return nil
   end

   return (THEME:GetMetric(screen:GetName(), "Class") == "ScreenEdit")
end

-- ------------------------------------------------------
-- hides all children layers of the current screen except for "SongForeground"
-- intended to be used with ScreenGameplay

helpers.HideUI = function()
   local screen = SCREENMAN:GetTopScreen()
   if not screen then
      lua.ReportScriptError("Helpers.HideUI() failed to run because there is no Screen yet.")
      return nil
   end

   -- don't hide the theme's UI in EditMode
   if helpers.IsEditMode() then
      return
   end

   for name,layer in pairs(screen:GetChildren()) do
      if name ~= "SongForeground" then
         layer:visible(false)
      end
   end
end


helpers.HideUI = function()
   local screen = SCREENMAN:GetTopScreen()
   if not screen then
      lua.ReportScriptError("Helpers.HideUI() failed to run because there is no Screen yet.")
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