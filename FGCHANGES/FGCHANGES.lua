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

-- reference: https://quietly-turning.github.io/Lua-For-SM5/LuaAPI#Actors-BitmapText
local en_subtitle_actor = LoadFont("Common normal")
local sc_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans SC 20px/_Noto Sans SC 20px.ini" })
local tc_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans TC 20px/_Noto Sans TC 20px.ini" })
local jp_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini" })
local th_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans Thai 20px/_Noto Sans Thai 20px.ini" })

-- ------------------------------------------------------
local subtitle_choices = {
   {
      file="en",
      label="English",
      subtitleActor=en_subtitle_actor,
      characterSet="en",
   },
   {
      file="es-MX",
      label="Español",
      subLabel="(Latin America)",
      subtitleActor=en_subtitle_actor,
      characterSet="en",
   },
   {
      file="fr",
      label="Français",
      subtitleActor=en_subtitle_actor,
      characterSet="en",
   },
   {
      file="jp",
      label="日本語",
      subtitleActor=jp_subtitle_actor,
      characterSet="jp",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="it",
      label="Italiano",
      subtitleActor=en_subtitle_actor,
      characterSet="en",
   },
   {
      file="ru",
      label="Русский",
      subtitleActor=en_subtitle_actor,
      characterSet="en",
   },
   {
      file="zh-HANS",
      label="简体中文",
      subtitleActor=sc_subtitle_actor,
      characterSet="sc",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="zh-HANT",
      label="繁體中文",
      subtitleActor=tc_subtitle_actor,
      characterSet="tc",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="th",
      label="ภด่",
      subtitleActor=th_subtitle_actor,
      characterSet="th",
      -- Setup=function(self) self:halign(0):addx(-200) end,
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

      -- hide the ActorFrame containing all subtitle choices
      choice_af_ref:queuecommand("Hide")

      af:playcommand("Play")
      af:playcommand("HideQuad")
      timer_done = true
   end
end

-- ------------------------------------------------------

local subtitle_index = 1
local set = false  -- when false, the subtitle_actor has an empty string as its text

-- custom Update function is used to keep track of which subtitle to show
local UpdateSubtitles = function()
   if not subtitle_data then return false end
   if not subtitle_ref  then return false end

   -- no more subtitles to show
   if not (subtitle_data[subtitle_index] and subtitle_data[subtitle_index].Start and subtitle_data[subtitle_index].End) then
      return false
   end

   -- -------------------------
   local time = GetTimeSinceStart() - time_at_start

   if not set and time >= subtitle_data[subtitle_index].Start then
      subtitle_ref:playcommand("SetText", {text=subtitle_data[subtitle_index].Text})
      set = true

   elseif set and time >= subtitle_data[subtitle_index].End then
      subtitle_ref:playcommand("SetText", {text=""})
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

af[#af+1] = audio_actor
af[#af+1] = countdown_timer

-- ------------------------------------------------------
-- XXX: clunky Lua to create one unique BitmapText actor per-glyph-set needed. :(
--      it doesn't seem possible to create a single "import" font from within a stepchart
--      that combines all custom-fonts-local-to-this-stepchart.  (if that were possible,
--      we could have a single BitmapText actor for subtitles that has all possible characters needed.)
--      but, it looks like specifying "import=" in a font's ini file is hardcoded to look
--      in the current theme's Fonts folder, which doesn't help us from the context of this stepchart.
--      https://github.com/itgmania/itgmania/blob/159391b8a244cffdde9366b97e6a2d03f9cfb6b8/src/Font.cpp#L831

local subtitle_actors = {
   {characterSet="en", actor=en_subtitle_actor},
   {characterSet="sc", actor=sc_subtitle_actor},
   {characterSet="tc", actor=tc_subtitle_actor},
   {characterSet="jp", actor=jp_subtitle_actor},
   {characterSet="th", actor=th_subtitle_actor},
   --{characterSet="ko", actor=ko_subtitle_actor},
}

for subtitle_actor in ivalues(subtitle_actors) do

   subtitle_actor.actor.PlayCommand=function(self)
      -- if this is the BitmapText actor we want to use for subtitles, set it up!
      if subtitle_choices[subtitle_choice].characterSet == subtitle_actor.characterSet then
         subtitle_ref = self

         self:Center()
         self:zoom(font_zoom)
         self:wrapwidthpixels(max_subt_width)
         self:vertalign(top):y(170)
         self:diffuse(subtitle_color)
         self:strokecolor(subtitle_stroke_color)

         if subtitle_choices[subtitle_choice].Setup then
            subtitle_choices[subtitle_choice].Setup(self)
         end

      -- otherwise (e.g. the player chooses Simplified Chinese, and this BitmapText actor has latin characters loaded) hibernate it!
      else
         self:hibernate(math.huge)
      end
   end

   subtitle_actor.actor.SetTextCommand=function(self, params)
      self:settext(params.text)
   end

   af[#af+1] = subtitle_actor.actor
end

-- ------------------------------------------------------
-- subtitle choices
-- TODO: move this to its own AF

local choice_af = Def.ActorFrame({})
choice_af.InitCommand=function(self)
   choice_af_ref = self
end
choice_af.HideCommand=function(self)
   self:hibernate(math.huge)
end

choice_af[#choice_af+1] = LoadActor("./sfx/cursor.ogg")..{
   InitCommand=function(self) cursor_sfx_ref = self end,
   HideCommand=function(self) self:hibernate(math.huge) end
}

choice_af[#choice_af+1] = LoadActor("./img/choose-subtitle-language.png")..{
   InitCommand=function(self) self:Center():zoom(0.333) end,
   HideCommand=function(self) self:hibernate(math.huge) end
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

      -- TODO: don't rely on SL's Common normal
      --       replace with custom bundled font
      LoadFont("Common normal")..{
         Condition=v.characterSet=="en",
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

      -- simplified chinese
      Def.BitmapText{
         File=base_path.."FGCHANGES/fonts/Noto Sans SC 20px/_Noto Sans SC 20px.ini",
         Condition=v.characterSet=="sc",
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

      -- traditional chinese
      Def.BitmapText{
         File=base_path.."FGCHANGES/fonts/Noto Sans TC 20px/_Noto Sans TC 20px.ini",
         Condition=v.characterSet=="tc",
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

      -- japanese
      Def.BitmapText{
         File=base_path.."FGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini",
         Condition=v.characterSet=="jp",
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

      -- thai
      Def.BitmapText{
         File=base_path.."FGCHANGES/fonts/Noto Sans Thai 20px/_Noto Sans Thai 20px.ini",
         Condition=v.characterSet=="th",
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