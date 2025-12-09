return {
   {
      file="en",
      label="English",
      characterSet="en",
   },
   {
      file="es-MX",
      label="Español",
      subLabel="(Latin America)",
      characterSet="en",
   },
   {
      file="fr",
      label="Français",
      characterSet="en",
   },
   {
      file="it",
      label="Italiano",
      characterSet="en",
   },
   {
      file="jp",
      label="日本語",
      characterSet="jp",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="ko",
      label="한국어",
      characterSet="ko",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="zh-HANS",
      label="简体中文",
      characterSet="sc",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="zh-HANT",
      label="繁體中文",
      characterSet="tc",
      Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="th",
      bakedFile="th/thai-subtitles.png",
      label="ภาษาไทย",
      characterSet="th",
      -- Setup=function(self) self:halign(0):addx(-200) end,
   },
   {
      file="vn",
      label="Tiếng Việt",
      characterSet="vn",
   },
   {
      file="ru",
      label="русский",
      characterSet="ru",
   },
}