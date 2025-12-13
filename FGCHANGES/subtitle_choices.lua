local base_path = GAMESTATE:GetCurrentSong():GetSongDir()

return {
   {
      file="en",
      label="English",
      font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path),
   },
   {
      file="es-MX",
      label="Español",
      subLabel="(Latin America)",
      font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path),
   },
   {
      file="fr",
      label="Français",
      font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path),
   },
   {
      file="it",
      label="Italiano",
      font=("%sFGCHANGES/fonts/Noto Sans 40px/_Noto Sans 40px.ini"):format(base_path),
   },
   {
      file="jp",
      label="日本語",
      font=("%sFGCHANGES/fonts/Noto Sans JP 20px/_Noto Sans JP 20px.ini"):format(base_path),
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="ko",
      label="한국어",
      font=("%sFGCHANGES/fonts/Noto Sans KR 20px/_Noto Sans KR 20px.ini"):format(base_path),
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="zh-HANS",
      label="简体中文",
      font=("%sFGCHANGES/fonts/Noto Sans SC 20px/_Noto Sans SC 20px.ini"):format(base_path),
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="zh-HANT",
      label="繁體中文",
      font=("%sFGCHANGES/fonts/Noto Sans TC 20px/_Noto Sans TC 20px.ini"):format(base_path),
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="th",
      bakedFile="th/thai-subtitles.png",
      label="ภาษาไทย",
      font=("%sFGCHANGES/fonts/Noto Sans Thai 20px/_Noto Sans Thai 20px.ini"):format(base_path),
   },
   {
      file="vn",
      label="Tiếng Việt",
      font=("%sFGCHANGES/fonts/Noto Sans VN 40px/_Noto Sans VN 40px.ini"):format(base_path),
   },
   {
      file="ru",
      label="русский",
      font=("%sFGCHANGES/fonts/Noto Sans RU 40px/_Noto Sans RU 40px.ini"):format(base_path),
   },
}