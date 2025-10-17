-- ------------------------------------------------------
-- load helpers

local base_path = GAMESTATE:GetCurrentSong():GetSongDir()
local helpers = dofile(base_path.."FGCHANGES/scripts/Helpers.lua")

-- ------------------------------------------------------

local font_zoom             = 1.5
local subtitle_color        = {1,1,1,1} -- white text by default
local subtitle_stroke_color = {0,0,0,1} -- black stroke around text by default

local audio_path    = base_path .. "FGCHANGES/media/my-heart-almost-stood-still.ogg"
local subtitle_path

local max_subt_width = (_screen.w-64) / font_zoom

-- ------------------------------------------------------

-- get parser helper function
local ParseFile = dofile(base_path.."FGCHANGES/scripts/subtitle-parsers/srt-parser.lua")
local subtitle_data

local LoadSubtitleFile = function(filename)
   subtitle_path = ("%sFGCHANGES/media/subtitles/%s"):format(base_path, filename)

   -- parse subtitle file, get data
   subtitle_data = ParseFile(subtitle_path)
end

-- ------------------------------------------------------

local time_at_start
local subtitle_ref, audio_ref, countdown_ref, cursor_sfx_ref, cursor_triangle_ref, choice_af_ref
local choices_refs = {}

-- ------------------------------------------------------
local subtitle_choices = {
   {
      file="en",
      label="English"
   },
   {
      file="es-MX",
      label="Español",
      subLabel="(Latin America)"
   },
   {
      file="fr",
      label="Français"
   },
   {
      file="jp",
      label="日本語"
   },
   {
      file="it",
      label="Italiano"
   },
   {
      file="ru",
      label="Русский"
   },

}

local subtitle_choice = 1

local function InputHandler( event )
   if event.type ~= "InputEventType_FirstPress" then return end

   if event.GameButton == "MenuLeft" then
      choices_refs[subtitle_choice]:playcommand("LoseFocus")
      subtitle_choice = subtitle_choice - 1
      if (subtitle_choice==0) then subtitle_choice=#subtitle_choices end
      choices_refs[subtitle_choice]:playcommand("GainFocus")
      cursor_sfx_ref:play()
      cursor_triangle_ref:playcommand("Move")

   elseif event.GameButton == "MenuRight" then
      choices_refs[subtitle_choice]:playcommand("LoseFocus")
      subtitle_choice = subtitle_choice + 1
      if (subtitle_choice>#subtitle_choices) then subtitle_choice=1 end
      choices_refs[subtitle_choice]:playcommand("GainFocus")
      cursor_sfx_ref:play()
      cursor_triangle_ref:playcommand("Move")

   end

end

-- ------------------------------------------------------
local timer_done = false

local UpdateTimer = function(af)
   if type(time_at_start)~="number" then return false end

   local time = GetTimeSinceStart() - time_at_start
   local timer_text = math.round(10 - time)

   if (timer_text > 0) then
      countdown_ref:settext( timer_text )
   else
      LoadSubtitleFile( subtitle_choices[subtitle_choice].file..".my-heart-almost-stood-still.srt" )
      countdown_ref:visible(false)
      for i=1,#subtitle_choices do
         choices_refs[i]:visible(false)
      end
      af:playcommand("Play")
      af:playcommand("HideQuad")
      choice_af_ref:visible(false)
      timer_done = true
   end
end

-- ------------------------------------------------------

local subtitle_index = 1
local set = false  -- when false, the subtitle_actor has an empty string as its text

-- custom Update function is used to keep track of which subtitle to show
local UpdateSubtitles = function()
   if not subtitle_data then return false end

   -- no more subtitles to show
   if not (subtitle_data[subtitle_index] and subtitle_data[subtitle_index].Start and subtitle_data[subtitle_index].End) then
      return false
   end

   -- -------------------------
   local time = GetTimeSinceStart() - time_at_start

   if not set and time >= subtitle_data[subtitle_index].Start then
      subtitle_ref:settext(subtitle_data[subtitle_index].Text)
      set = true

   elseif set and time >= subtitle_data[subtitle_index].End then
      subtitle_ref:settext("")
      set = false
      subtitle_index = subtitle_index + 1
   end
end

-- ------------------------------------------------------

local Update = function(af)
   if (not timer_done) then
      UpdateTimer(af)
   else
      UpdateSubtitles(af)
   end
end

-- ------------------------------------------------------

local af = Def.ActorFrame{}

-- sleep for a Very Long While so that the FGCHANGE stays alive when nothing else is tweening
af[#af+1] = Def.Actor({ InitCommand=function(self) self:sleep(999999) end })

-- black Quad serving two purposes
-- 1. the initial fullscreen-covering fade-to-black
-- 2. fullscreen dark backdrop for letter/pillar-boxing needs in case the video file
--    is not the same aspect ratio as StepMania
af[#af+1] = Def.Quad{
   InitCommand=function(self) self:FullScreen():diffuse(0,0,0,0) end,
   OnCommand=function(self)
      -- fade Quad in, covering the UI, giving an appearance of fading to black
      self:smooth(0.333):diffusealpha(1)
      self:queuecommand("Next")
   end,
   NextCommand=function(self)
      self:GetParent():queuecommand("HideUI")
   end,
   HideQuadCommand=function(self)
      self:smooth(1):diffusealpha(0)
   end
}

-- ------------------------------------------------------
-- reference: https://quietly-turning.github.io/Lua-For-SM5/LuaAPI#Actors-ActorSound
local audio_actor = Def.Sound{ File=audio_path }
audio_actor.InitCommand=function(self) audio_ref = self end

-- reference: https://quietly-turning.github.io/Lua-For-SM5/LuaAPI#Actors-BitmapText
local subtitle_actor = LoadFont("Common normal")

local countdown_timer = LoadFont("Common bold")
countdown_timer.InitCommand=function(self)
   countdown_ref = self
   self:halign(1):valign(0):xy(_screen.w-32, 10):zoom(1)
   self:settext('10')
end

-- ------------------------------------------------------

af.OnCommand=function(self)
   SCREENMAN:GetTopScreen():AddInputCallback( InputHandler )
   self:queuecommand("StartUpdate")
end

af.HideUICommand=function(self)
   helpers.HideUI()
end

af.StartUpdateCommand=function(self)
   time_at_start = GetTimeSinceStart()
   self:SetUpdateFunction( Update )
end

af.PlayCommand=function(self)
   time_at_start = GetTimeSinceStart()
   audio_ref:play()
end

-- ------------------------------------------------------

subtitle_actor.InitCommand=function(self)
   subtitle_ref = self
   self:Center():wrapwidthpixels(max_subt_width):zoom(font_zoom)
   self:vertalign(top):y(170)
   self:diffuse(subtitle_color):strokecolor(subtitle_stroke_color)
end

-- ------------------------------------------------------

af[#af+1] = audio_actor
af[#af+1] = subtitle_actor
af[#af+1] = countdown_timer


local choice_af = Def.ActorFrame({})
choice_af.InitCommand=function(self)
   choice_af_ref = self
end
choice_af.HideCommand=function(self) end

choice_af[#choice_af+1] = LoadActor("./sfx/cursor.ogg")..{
   InitCommand=function(self) cursor_sfx_ref = self end
}

choice_af[#choice_af+1] = LoadActor("./img/choose-subtitle-language.png")..{
   InitCommand=function(self) self:Center():zoom(0.333) end,
   HideCommand=function(self) self:visible(false) end
}



choice_af[#choice_af+1] = LoadActor("./img/cursor-triangle.png")..{
   InitCommand=function(self)
      cursor_triangle_ref = self
      self:zoom(0.5):queuecommand("Move")
   end,
   MoveCommand=function(self)
      self:x(choices_refs[subtitle_choice]:GetX())
      self:y(choices_refs[subtitle_choice]:GetY()-47)
      self:queuecommand("Bump")
   end,
   BumpCommand=function(self)
      self:finishtweening()
      self:smooth(0.1):y( self:GetY()-3 )
      self:smooth(0.1):y( self:GetY()+3)
   end,
}

for i,v in ipairs(subtitle_choices) do
   choice_af[#choice_af+1] = Def.ActorFrame({
      name=v.file.."-choice",

      InitCommand=function(self)
         choices_refs[i] = self
         self:x(_screen.cx + (((i-1)%3)-1)*200)
         self:y( (math.floor((i-1)/3)*100) + 170)
         if (i==1) then self:queuecommand("GainFocus") end
      end,

      LoadActor("./img/choice-bg.png")..{
         Name="choice-stroke",
         InitCommand=function(self)
            self:diffuse(1, 1, 1, 1)
            self:zoomto(176, 76):visible(false)
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
      },

      LoadActor("./img/choice-bg.png")..{
         Name="choice-bg",
         InitCommand=function(self)
            self:diffuse(color("94a3b8"))
            self:zoom(0.333)
         end,
         GainFocusCommand=function(self)
            self:diffuse(color("#4f46e5"))
         end,
         LoseFocusCommand=function(self)
            self:diffuse(color("94a3b8"))
         end
      },
      LoadFont("Common normal")..{
         Text=v.label,
         InitCommand=function(self)
            self:diffuse(0,0,0,1):zoom(1.5)
            if (v.subLabel ~= nil) then
               self:y(-7)
            end
         end,
         GainFocusCommand=function(self) self:diffuse(1,1,1,1) end,
         LoseFocusCommand=function(self) self:diffuse(0,0,0,1) end,
      },
      LoadFont("Common normal")..{
         Text=v.subLabel,
         Condition=v.subLabel ~= nil,
         InitCommand=function(self)
            self:diffuse(0,0,0,1):zoom(0.9):y(15)
         end,
         GainFocusCommand=function(self) self:diffuse(1,1,1,1) end,
         LoseFocusCommand=function(self) self:diffuse(0,0,0,1) end,
      }
   })
end

af[#af+1] = choice_af

return af