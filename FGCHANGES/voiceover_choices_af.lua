-- ------------------------------------------------------
-- grid layout configuration
-- okay to modify these to suit your needs!
local numCols = 3
local choiceWidth = 172
local choiceHeight = 60
local choiceStroke = 4
local choicePaddingX = 14
local choicePaddingY = 18

local af_y_offset = 400
local instruction_y_offset_from_af = -46

-- ------------------------------------------------------
-- variables that need file-scope
local base_path = unpack(...)
local cursor_sfx_ref, cursor_triangle_ref
local choices_refs = {}
local voiceover_choice = 1
local voiceover_choices_af_has_focus = false

local voiceover_choices = {
  { file="en-A",  label="English", subLabel="Voice Actor A", doubleres=false, font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path)},
  { file="en-B",  label="English", subLabel="Voice Actor B", doubleres=false, font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path)},
  { file="jp",    label="日本語",                            doubleres=true,  font=("%sFGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini"):format(base_path)},
}

-- ------------------------------------------------------

local InputActions = {
  -- decrement by 1, wrap to end if needed
  MenuLeft = function()
    voiceover_choice = voiceover_choice - 1
    if (voiceover_choice <= 0) then voiceover_choice=#voiceover_choices end
  end,

  -- increment by 1, wrap to start if needed
  MenuRight = function()
    voiceover_choice = voiceover_choice + 1
    if (voiceover_choice>#voiceover_choices) then voiceover_choice=1 end
  end,

  --  -- decrement by numCols, wrap-and-maintain-column if needed
  --  MenuUp = function()
  --     voiceover_choice = voiceover_choice - numCols
  --     if (voiceover_choice <= 0) then
  --        if (voiceover_choice%numCols > #voiceover_choices%numCols) then
  --           voiceover_choice = math.floor(#voiceover_choices/numCols)*numCols + voiceover_choice
  --        else
  --           voiceover_choice = math.ceil(#voiceover_choices/numCols)*numCols + voiceover_choice
  --           if (voiceover_choice>#voiceover_choices) then voiceover_choice=math.floor(#voiceover_choices/numCols)*numCols end
  --        end
  --     end
  --  end,

  --  -- increment by numCols, wrap-and-maintain-column if needed
  --  MenuDown = function()
  --     voiceover_choice = voiceover_choice + numCols
  --     if (voiceover_choice>#voiceover_choices) then
  --        voiceover_choice = voiceover_choice%numCols
  --        if (voiceover_choice <= 0) then voiceover_choice=numCols end
  --     end
  --  end,

  Select = function()
    MESSAGEMAN:Broadcast("VoiceOverCanceled")
  end,

  -- Start = function()
  --   MESSAGEMAN:Broadcast("VoiceOverChosen")
  -- end
}

local function InputHandler( event )
  if not voiceover_choices_af_has_focus then return end
  if not InputActions[event.GameButton] then return end

  if event.type == "InputEventType_FirstPress" then
    choices_refs[voiceover_choice]:playcommand("LoseFocus")
    InputActions[event.GameButton]()
    choices_refs[voiceover_choice]:playcommand("GainFocus")
    cursor_sfx_ref:play()
    cursor_triangle_ref:playcommand("Move")
  end
end

-- ------------------------------------------------------

local choices_af = Def.ActorFrame({})

choices_af.InitCommand=function(self)
  self:y(af_y_offset)
end
choices_af.OnCommand=function()
  SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
end
choices_af.HideSubtitleChoicesCommand=function(self)
  self:hibernate(math.huge)
end
choices_af.SubtitleChosenMessageCommand=function()
  voiceover_choices_af_has_focus = true
end
choices_af.VoiceOverCanceledMessageCommand=function()
  voiceover_choices_af_has_focus = false
end
choices_af.PlayCommand=function()
  SCREENMAN:GetTopScreen():RemoveInputCallback( InputHandler )
end

-- ------------------------------------------------------
-- sound effect played when cursor moves
choices_af[#choices_af+1] = LoadActor("./sfx/cursor.ogg")..{
  InitCommand=function(self) cursor_sfx_ref = self end,
  HideCommand=function(self) self:hibernate(math.huge) end
}

-- help-text instructing players to choose their voiceover language
-- (XXX: would be better to have this display in the engine's current language)
choices_af[#choices_af+1] = LoadActor("./img/choose-voiceover-language.png")..{
  InitCommand=function(self) self:xy(_screen.cx, instruction_y_offset_from_af):zoom(0.333):align(0.5, 1) end,
  HideCommand=function(self) self:hibernate(math.huge) end
}

-- triangle cursor to help show which choice is active
choices_af[#choices_af+1] = LoadActor("./img/cursor-triangle.png")..{
  InitCommand=function(self)
    cursor_triangle_ref = self
    self:zoom(0.5):align(0.5,1):queuecommand("Move")
  end,
  MoveCommand=function(self)
    self:x(choices_refs[voiceover_choice]:GetX())
    self:y(choices_refs[voiceover_choice]:GetY()-((choiceHeight+choiceStroke)/2)-1)
    self:queuecommand("Bump")
  end,
  BumpCommand=function(self)
    self:finishtweening()
    self:smooth(0.1):y( self:GetY()-3 )
    self:smooth(0.1):y( self:GetY()+3)
  end,
}


for i,v in ipairs(voiceover_choices) do
  local choice_af = Def.ActorFrame({
    Name=("%s-choice"):format(v.file),

    InitCommand=function(self)
      choices_refs[i] = self
      self:x(_screen.cx + (((i-1) % numCols) - math.floor(numCols/2)) * (choiceWidth + choicePaddingX) + (numCols%2==0 and (choiceWidth/2) or 0))
      self:y((math.floor((i-1) / numCols) * (choiceHeight+choicePaddingY)))
      if (i==1) then self:queuecommand("GainFocus") end
    end,
  })


  choice_af[#choice_af+1] = LoadActor("./img/choice-bg.png")..{
    Name=("%s choice-stroke"):format(v.file),
    InitCommand=function(self)
      self:diffuse(1, 1, 1, 1)
      self:zoomto(choiceWidth+choiceStroke, choiceHeight+choiceStroke):visible(false)
      self:glowshift()
      self:effectcolor1(color("#818cf8"))
      self:effectcolor2(color("#6366f1"))
      self:effectperiod(1)
    end,
    GainFocusCommand=function(self)
      self:visible(true)
    end,
    LoseFocusCommand=function(self)
      self:visible(false)
    end
  }

  choice_af[#choice_af+1] = LoadActor("./img/choice-bg.png")..{
    Name=("%s choice-bg"):format(v.file),
    InitCommand=function(self)
      self:diffuse(color("94a3b8"))
      self:zoomto(choiceWidth, choiceHeight)
    end,
    GainFocusCommand=function(self)
      self:diffuse(color("#4f46e5"))
    end,
    LoseFocusCommand=function(self)
      self:diffuse(color("94a3b8"))
    end
  }


  local choice_font_actor = Def.BitmapText{}
  choice_font_actor.File = v.font
  choice_font_actor.Name = ("%s label"):format(v.file)
  choice_font_actor.Text = v.label
  choice_font_actor.InitCommand=function(self)
    self:diffuse(0,0,0,1):zoom(v.doubleres and 1.2 or 0.6)
    if (v.subLabel ~= nil) then
      self:y(-7)
    end
  end
  choice_font_actor.GainFocusCommand=function(self) self:diffuse(1,1,1,1) end
  choice_font_actor.LoseFocusCommand=function(self) self:diffuse(0,0,0,1) end


  choice_af[#choice_af+1] = choice_font_actor

  choice_af[#choice_af+1] = LoadFont("Common normal")..{
    Name=("%s sub-label"):format(v.file),
    Text=v.subLabel,
    Condition=v.subLabel ~= nil,
    InitCommand=function(self)
      self:diffuse(0,0,0,1):zoom(0.9):y(15)
    end,
    GainFocusCommand=function(self) self:diffuse(1,1,1,1) end,
    LoseFocusCommand=function(self) self:diffuse(0,0,0,1) end,
  }

   choices_af[#choices_af+1] = choice_af
end

choices_af[#choices_af+1] = Def.Quad{
  InitCommand=function(self)
    self:zoom(_screen.w, _screen.h):xy(_screen.cx, af_y_offset + instruction_y_offset_from_af - 20)
    self:diffuse(0,0,0,0.75)
  end,
  SubtitleChosenMessageCommand=function(self)
    self:diffusealpha(0)
  end,
  VoiceOverCanceledMessageCommand=function(self)
    self:diffuse(0,0,0,0.75)
  end,
}

-- ------------------------------------------------------
local function GetVoiceOverChoice()
  return voiceover_choices[voiceover_choice]
end
-- ------------------------------------------------------

return {choices_af, GetVoiceOverChoice}