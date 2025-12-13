-- ------------------------------------------------------
-- load helpers

local base_path = GAMESTATE:GetCurrentSong():GetSongDir()
local helpers = dofile(base_path.."FGCHANGES/scripts/Helpers.lua")

-- ------------------------------------------------------

local subtitle_color        = {1,1,1,1} -- white text by default

-- subtitle_path and audio_path will be set when countdown timer ends, signifying players have made their choices
local audio_path, subtitle_path

-- -------------------------------------------------------------------------------

local font_zoom      = 0.6
local max_subt_width = (_screen.w-64) / font_zoom

-- -------------------------------------------------------------------------------
-- A RANT ABOUT USING THE "(doubleres)" TEXTURE HINT IN FONTS
--
-- I ended up needing to use a mixture of "doubleres" fonts and non-doubleres-fonts
-- in this project.  bitmap fonts in stepmania need a "pixel width" per-character.
-- for example, in "_Noto Sans 40px.ini", I need to specify that "E" is 17px wide
-- while "l" is 6px wide, so stepmania knows how to draw text.
--
-- when you add "(doubleres)" to your filename, stepmania's RageBitmapTexture.cpp code
-- will *effectively* draw the asset at half-the-size-with-twice-the-detail,
-- useful for modern LCD displays that perform pixel-doubling ("retina displays" as branded by Apple)
--
-- and with doubleres BitmapTexts, per-character-pixel-widths need to be halved,
-- meaning that if "e" is 18px wide as a 40px-font, it's 9px wide as a 20px-doubleres-font.
--
-- when "d" is 19px wide as a 40px-font, should you round down to 9 or up to 10 as a 20px-doubleres-font?
--
-- in practice, I found this loss-of-precision limiting.  the 20px-doubleres-font looked uglier because
-- I couldn't get the kerning right.  so I didn't use "(doubleres)" in the filename for Noto Sans 40px.
--
-- the monospaced fonts used in this stepchart (like Chinese and Japanese) have characters that are ALL
-- the same pixel width and happen to all be 40px (because I made them that way), which cleanly divides
-- in half to 20, so I'm leaving the "(doubleres)" texture hint intact there.
--
-- this is not to suggest you should do similarly in your stepchart-scripting-efforts,
-- it's just what I found worked for this project's needs.   quietly-turning

local doubleres = {
   ["zh-HANS"]=true,
   ["zh-HANT"]=true,
   jp=true,
   th=true,
   ko=true,
}
-- -------------------------------------------------------------------------------


-- ------------------------------------------------------

-- get parser helper function
local ParseFile = dofile(base_path.."FGCHANGES/scripts/subtitle-parsers/srt-parser.lua")
local subtitle_data

local LoadSubtitleFile = function(audioFilename, subtitleFilename)
   subtitle_path = ("%sFGCHANGES/media/subtitles/%s/%s"):format(base_path, audioFilename, subtitleFilename)

   -- parse subtitle file, get data
   subtitle_data = ParseFile(subtitle_path)
end

-- ------------------------------------------------------

local time_at_start
local subtitle_ref, audio_ref, countdown_ref

-- ------------------------------------------------------

-- reference: https://quietly-turning.github.io/Lua-For-SM5/LuaAPI#Actors-BitmapText

local en_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini" })
local sc_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans SC 20px/_Noto Sans SC 20px.ini" })
local tc_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans TC 20px/_Noto Sans TC 20px.ini" })
local jp_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini" })
local ko_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans KR 20px/_Noto Sans KR 20px.ini" })
local ru_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans RU 40px/_Noto Sans RU 40px.ini" })
local vn_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans VN 40px/_Noto Sans VN 40px.ini" })


-- as of November 2025, ITGm's Font.cpp doesn't appear to support superimposing diacritics over alphabet characters,
-- leaving written languages like Thai script unable to render in a BitmapText.  for now, recourse is to support
-- entire lines of subtitles baked into sprite frames
local th_subtitle_actor = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans Thai 20px/_Noto Sans Thai 20px.ini" })
local th_bakedSubtitle_actor = LoadActor(base_path.."FGCHANGES/media/subtitles/_prebaked/th/thai-subtitles 3x10 (doubleres).png")

-- ------------------------------------------------------
local subtitle_choice
local subtitle_choices = LoadActor("./subtitle_choices.lua")
local InputHandler, choices_af, GetSubtitleChoice = unpack(LoadActor("./subtitle_choices_af.lua", {base_path, subtitle_choices, doubleres}))

-- ------------------------------------------------------
local timer_done = false
local timer_start_seconds = 10

local UpdateTimer = function(af)
   if type(time_at_start)~="number" then return false end

   local time = GetTimeSinceStart() - time_at_start
   local timer_text = math.round(timer_start_seconds - time)

   -- time still remaining on countdown timer; update it
   if (timer_text > 0) then
      countdown_ref:settext( timer_text )


   -- countdown timer has ended
   -- load subtitle and audio files based on player choices
   else
      subtitle_choice = subtitle_choices[GetSubtitleChoice()]

      local audioFilename    = "en-A"  -- TODO: don't hardcode
      local subtitleFilename = ("%s.my-heart-almost-stood-still.srt"):format(subtitle_choice.file)

      LoadSubtitleFile( audioFilename, subtitleFilename )
      audio_path    = base_path .. "FGCHANGES/media/audio/en-A.my-heart-almost-stood-still.ogg"
      audio_ref:playcommand("LoadFile")

      countdown_ref:visible(false)

      -- hide the ActorFrame containing all subtitle choices
      af:queuecommand("HideSubtitleChoices")

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
      local params = {}
      if subtitle_choice.bakedFile then
         params.frame = subtitle_index
      else
         params.text = subtitle_data[subtitle_index].Text
      end

      subtitle_ref:playcommand("SetText", params)
      set = true

   elseif set and time >= subtitle_data[subtitle_index].End then
      if subtitle_choice.bakedFile then
         subtitle_ref:visible(false)
      else
         subtitle_ref:playcommand("SetText", {text=""})
      end

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
local audio_actor = Def.Sound{}
audio_actor.InitCommand=function(self) audio_ref = self end
audio_actor.LoadFileCommand=function(self) self:load(audio_path) end

af[#af+1] = audio_actor


-- ------------------------------------------------------

local countdown_timer = Def.BitmapText({ File=base_path.."FGCHANGES/fonts/Noto Sans - Bold [digits] 40px/_Noto Sans Bold 40px.ini" })
countdown_timer.InitCommand=function(self)
   countdown_ref = self
   self:halign(1):valign(0):xy(_screen.w-32, 10):diffuse(0.7,0.7,0.7,1)
   self:settext(timer_start_seconds)
end

af[#af+1] = countdown_timer

-- ------------------------------------------------------
-- XXX: create one unique BitmapText actor per-glyph-set needed. :(
--
--      it doesn't seem possible to create a single "import" font from within a stepchart
--      that combines all custom-fonts-local-to-this-stepchart.  (if that were possible,
--      we could have a single BitmapText actor for subtitles that has all possible characters needed.)
--      but, it looks like specifying "import=" in a font's ini file is hardcoded to look
--      in the current theme's Fonts folder, which doesn't help us from the context of this stepchart.
--      https://github.com/itgmania/itgmania/blob/159391b8a244cffdde9366b97e6a2d03f9cfb6b8/src/Font.cpp#L831
--
--      thus...
--      [english, spanish, italian, french] characters get a BitmapText actor,
--      simplified chinese characters get a BitmapText actor,
--      Vietnamese characters get a BitmapText actor,
--      etc.

local subtitle_actors = {
   {file="en", actor=en_subtitle_actor},
   {file="sc", actor=sc_subtitle_actor},
   {file="tc", actor=tc_subtitle_actor},
   {file="jp", actor=jp_subtitle_actor},
   {file="th", actor=th_bakedSubtitle_actor},
   {file="ko", actor=ko_subtitle_actor},
   {file="ru", actor=ru_subtitle_actor},
   {file="vn", actor=vn_subtitle_actor},
}

for subtitle_actor in ivalues(subtitle_actors) do
   subtitle_actor.actor.InitCommand=function(self) self:animate(false) end

   subtitle_actor.actor.PlayCommand=function(self)
      -- if this is the BitmapText actor we want to use for subtitles, set it up!
      if (subtitle_choice.font == subtitle_actor.actor.File) or (subtitle_choice.bakedFile and subtitle_choice.file==subtitle_actor.file) then
         subtitle_ref = self

         if subtitle_choice.bakedFile then

         else
            self:zoom( doubleres[subtitle_actor.file] and (font_zoom * 2) or font_zoom)
            self:wrapwidthpixels(max_subt_width)
         end

         self:Center()
         self:vertalign(top):y(170)
         self:diffuse(subtitle_color)

         if subtitle_choice.Setup then
            subtitle_choice.Setup(self)
         end

      -- otherwise (e.g. the player chooses Simplified Chinese, and this BitmapText actor has latin characters loaded) hibernate it!
      else
         self:hibernate(math.huge)
      end
   end

   subtitle_actor.actor.SetTextCommand=function(self, params)
      if subtitle_choice.font == subtitle_actor.actor.File then
         if subtitle_choice.bakedFile then
            self:setstate(params.frame-1):queuecommand("Show")
         else
            self:settext(params.text)
         end
      end
   end

   subtitle_actor.actor.ShowCommand=function(self) self:visible(true) end

   af[#af+1] = subtitle_actor.actor
end

-- ------------------------------------------------------

af[#af+1] = choices_af

return af