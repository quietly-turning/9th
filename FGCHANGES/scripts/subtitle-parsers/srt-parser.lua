-- reference: https://www.matroska.org/technical/subtitles.html#srt-subtitles

-- ------------------------------------------------------
-- StrToSecs converts a stringified timestamp formatted like "00:02:15.10"
-- and returns it as a numeric value of seconds

local function StrToSecs(s)
   local hour, min, sec = s:match("(%d+):(%d%d):(%d%d%.%d+)")
   hour = hour or 0
   min  = min  or 0
   sec  = sec  or 0
   return ((hour*60*60)+(min*60)+(sec))
end
-- ------------------------------------------------------

local RageFile =
{
   READ       = 1,
   WRITE      = 2,
   STREAMED   = 4,
   SLOW_FLUSH = 8,
}
-- ------------------------------------------------------


local ParseFile = function( file_path )
   local file = RageFileUtil.CreateRageFile()

   if not file:Open(file_path, RageFile.READ) then
      lua.ReportScriptError( string.format("ReadFile(%s): %s",file_path,file:GetError()) )
      file:destroy()
      return { }  -- return a blank table
   end

   local events = {}
   local line_num = 0

   while not file:AtEOF() do
      local line = file:GetLine()
      line_num = line_num+1

      if line_num == 1 then
         -- UTF-8 "byte order mark" EFBBBF is typically (but not always!) the first three bytes of the file
         -- see: https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8
         if line:byte(1)==239 and line:byte(2)==187 and line:byte(3)==191 then
            -- skip it if we find it
            line = string.char(line:byte(4))
         end
      end

      if line ~= "" then
         if tonumber(line) ~= nil then
            -- advance GetLine to read the timestamp
            line = file:GetLine()
            line_num = line_num+1

            -- standardize begin/end timestamps to use periods
            line = line:gsub(",", ".")

            if line:match("%d%d:%d%d:%d%d%.%d%d%d %-%-%> %d%d:%d%d:%d%d%.%d%d%d") then

               local start, finish = line:match("(%d%d:%d%d:%d%d%.%d%d%d) %-%-%> (%d%d:%d%d:%d%d%.%d%d%d)")

               -- advance GetLine to read the subtitle text
               line = file:GetLine()
               line_num = line_num+1
               local text = line

               -- advance GetLine to read either the 2nd line of subtitle text
               -- or an empty line indicating we should move onto the next subtitle unit
               line = file:GetLine()
               line_num = line_num+1

               while line ~= "" do
                  text = ("%s\n%s"):format(text, line)

                  -- continue advancing GetLine until we get a line that's an empty string
                  line = file:GetLine()
                  line_num = line_num+1
               end

               table.insert(events, {Start=StrToSecs(start), End=StrToSecs(finish), Text=text})

            else
               lua.ReportScriptError( ("Error parsing %s\n   line %d: Couldn't parse start and finish time."):format(file_path, line_num) )
            end
         end
      -- else
      --   empty line, no action needed. proceed to next iteration of while-loop
      end
   end


   file:Close()
   file:destroy()

   return events
end

return ParseFile