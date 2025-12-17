local function IsEditMode()
   local screen = SCREENMAN:GetTopScreen()
    if not screen then
      lua.ReportScriptError("IsEditMode() check failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
      return nil
   end

   return (THEME:GetMetric(screen:GetName(), "Class") == "ScreenEdit")
end

local function HideCombo(player)
  local screen = SCREENMAN:GetTopScreen()
  if not screen then
    lua.ReportScriptError("HideCombo() failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
    return nil
  end

  -- hiding combo in EditMode not supported by this helper function
  if IsEditMode() then
    return nil
  end

  local playerAFName = (player==PLAYER_1 and "PlayerP1") or (player==PLAYER_2 and "PlayerP2") or nil
  if not playerAFName then
    return nil
  end

  local named_combo = screen:GetChild(playerAFName):GetChild("Combo")
  if named_combo then
    named_combo:hibernate(math.huge)
  end
end


local a = Def.Actor{}

a.OnCommand=function(self)
  -- hide Combo ActorFrame for all available players
  for player in ivalues(GAMESTATE:GetHumanPlayers()) do
    HideCombo(player)
  end
end

return a