-- ------------------------------------------------------
-- grid layout configuration
-- okay to modify these to suit your needs!
local numCols = 4
local choiceWidth = 172
local choiceHeight = 60
local choiceStroke = 4
local choicePaddingX = 14
local choicePaddingY = 18

-- ------------------------------------------------------
-- variables that need file-scope
local base_path, subtitle_choices = unpack(...)
local af_ref, cursor_sfx_ref, cursor_triangle_ref
local choices_refs = {}
local subtitle_choice = 1

-- ------------------------------------------------------

local InputActions = {
   -- decrement by 1, wrap to end if needed
   MenuLeft = function()
      subtitle_choice = subtitle_choice - 1
      if (subtitle_choice <= 0) then subtitle_choice=#subtitle_choices end
   end,

   -- increment by 1, wrap to start if needed
   MenuRight = function()
      subtitle_choice = subtitle_choice + 1
      if (subtitle_choice>#subtitle_choices) then subtitle_choice=1 end
   end,

   -- decrement by numCols, wrap-and-maintain-column if needed
   MenuUp = function()
      subtitle_choice = subtitle_choice - numCols
      if (subtitle_choice <= 0) then
         if (subtitle_choice%numCols > #subtitle_choices%numCols) then
            subtitle_choice = math.floor(#subtitle_choices/numCols)*numCols + subtitle_choice
         else
            subtitle_choice = math.ceil(#subtitle_choices/numCols)*numCols + subtitle_choice
            if (subtitle_choice>#subtitle_choices) then subtitle_choice=math.floor(#subtitle_choices/numCols)*numCols end
         end
      end
   end,

   -- increment by numCols, wrap-and-maintain-column if needed
   MenuDown = function()
      subtitle_choice = subtitle_choice + numCols
      if (subtitle_choice>#subtitle_choices) then
         subtitle_choice = subtitle_choice%numCols
         if (subtitle_choice <= 0) then subtitle_choice=numCols end
      end
   end
}

local function InputHandler( event )
   if event.type ~= "InputEventType_FirstPress" then return end
   if not InputActions[event.GameButton]        then return end

   choices_refs[subtitle_choice]:playcommand("LoseFocus")
   InputActions[event.GameButton]()
   choices_refs[subtitle_choice]:playcommand("GainFocus")
   cursor_sfx_ref:play()
   cursor_triangle_ref:playcommand("Move")
end

-- ------------------------------------------------------

local choices_af = Def.ActorFrame({})

choices_af.InitCommand=function(self)
   self:y(100)
end
choices_af.HideSubtitleChoicesCommand=function(self)
   self:hibernate(math.huge)
end

-- ------------------------------------------------------
-- sound effect played when cursor moves
choices_af[#choices_af+1] = LoadActor("./sfx/cursor.ogg")..{
   InitCommand=function(self) cursor_sfx_ref = self end,
   HideCommand=function(self) self:hibernate(math.huge) end
}

-- help-text instructing players to choose their subtitle language
-- (XXX: would be better to have this display in the engine's current language)
choices_af[#choices_af+1] = LoadActor("./img/choose-subtitle-language.png")..{
   InitCommand=function(self) self:xy(_screen.cx, -46):zoom(0.333):align(0.5, 1) end,
   HideCommand=function(self) self:hibernate(math.huge) end
}

-- triangle cursor to help show which choice is active
choices_af[#choices_af+1] = LoadActor("./img/cursor-triangle.png")..{
   InitCommand=function(self)
      cursor_triangle_ref = self
      self:zoom(0.5):align(0.5,1):queuecommand("Move")
   end,
   MoveCommand=function(self)
      self:x(choices_refs[subtitle_choice]:GetX())
      self:y(choices_refs[subtitle_choice]:GetY()-((choiceHeight+choiceStroke)/2)-1)
      self:queuecommand("Bump")
   end,
   BumpCommand=function(self)
      self:finishtweening()
      self:smooth(0.1):y( self:GetY()-3 )
      self:smooth(0.1):y( self:GetY()+3)
   end,
}


for i,v in ipairs(subtitle_choices) do
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


   local choice_font_actor

   if     v.characterSet == "en" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans 20px/_Noto Sans 20px.ini" }

   -- simplified chinese
   elseif v.characterSet == "sc" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans SC 20px/_Noto Sans SC 20px.ini" }

   -- traditional chinese
   elseif v.characterSet == "tc" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans TC 20px/_Noto Sans TC 20px.ini" }

   -- japanese
   elseif v.characterSet == "jp" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini" }

   -- korean
   elseif v.characterSet == "ko" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans KR 20px/_Noto Sans KR 20px.ini" }

   -- thai
   elseif v.characterSet == "th" then
      choice_font_actor = Def.BitmapText{ File=base_path.."FGCHANGES/fonts/Noto Sans Thai 20px/_Noto Sans Thai 20px.ini" }

   end

   choice_font_actor.Name = ("%s label"):format(v.file)
   choice_font_actor.Text = v.label
   choice_font_actor.InitCommand=function(self)
      self:diffuse(0,0,0,1):zoom(1.5)
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

-- ------------------------------------------------------
-- author's note:
-- `subtitle_choice` is an int (like `1` or `5`) local to this file
--  FGCHANGES.lua needs to have access to it, but returning it directly here
-- like `return {InputHandler, choices_af, subtitle_choice}` won't work
-- because FGCHANGES.lua will immediately receive the initial *value* of `1` from unpack()!
-- so, we wrap it in a "getter" function, and return (a reference to) that function
-- to FGCHANGES, which can call the function to get the value of `subtitle_choice`.

local function GetSubtitleChoice()
  return subtitle_choice
end
-- ------------------------------------------------------


return {InputHandler, choices_af, GetSubtitleChoice}