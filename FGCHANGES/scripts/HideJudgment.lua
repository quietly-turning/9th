local function IsEditMode()
   local screen = SCREENMAN:GetTopScreen()
    if not screen then
      lua.ReportScriptError("helpers.IsEditMode() check failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
      return nil
   end

   return (THEME:GetMetric(screen:GetName(), "Class") == "ScreenEdit")
end

local function HideJudgment(player)
  local screen = SCREENMAN:GetTopScreen()
  if not screen then
    lua.ReportScriptError("HideJudgment() failed to run because there is no Screen yet.\nYou should call helpers.IsEditMode() from an OnCommand, or queue it from InitCommand, so that it will be useful.")
    return nil
  end

  -- hiding judgment in EditMode not supported by this helper function
  if IsEditMode() then
    return nil
  end

  local playerAFName = (player==PLAYER_1 and "PlayerP1") or (player==PLAYER_2 and "PlayerP2") or nil
  if not playerAFName then
    return nil
  end

  local named_judgment = screen:GetChild(playerAFName):GetChild("Judgment")
  if named_judgment then
    named_judgment:hibernate(math.huge)
  end
end


local a = Def.Actor{}

a.OnCommand=function(self)
  -- hide judgment ActorFrame for all available players
  -- this is typically an animated sprite display text like "Fantastic", "Great", and "Miss"
  for player in ivalues(GAMESTATE:GetHumanPlayers()) do
    HideJudgment(player)
  end
end

return a