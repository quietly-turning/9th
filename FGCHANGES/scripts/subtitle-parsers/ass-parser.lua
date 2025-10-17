-- reference: http://www.tcax.org/docs/ass-specs.htm
-- reference: https://www.matroska.org/technical/subtitles.html#ssaass-subtitles

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
-- based on global split() from _fallback/Scripts/00 init.lua
-- hackishly modified to include a numeric "stop" value
-- as in: stop splitting the provided `text` if you've already split `stop` number of times

local function split(delimiter, text, stop)
  local list = {}
  local pos = 1

  if type(stop)~="number" then stop=9999 end

  while 1 do
    local first,last = string.find(text, delimiter, pos)
    if first then
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
      -- if we've reach our limit of splits
      -- insert the remaining string until its end and break
      if #list >= stop-1 then
        table.insert(list, string.sub(text, pos))
        break
      end
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
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

  local tbl = { }
  local current = tbl

  while not file:AtEOF() do
    local line = file:GetLine()

    --ignore lines that begin with a semicolon as comments
    if not line:find("^%s*;") then

      -- is this a section?
      local sec = line:match( "^%[(.+)%]" )
      if sec then

        -- normalize to lowercase for easier comparison
        sec = sec:lower()

        -- is this a section we're interested in?
        if (sec=="v4+ styles" or sec=="v4 styles+" or sec=="events") then

          -- if this section doesn't exist, create it
          tbl[sec] = tbl[sec] and tbl[sec] or { }
          current = tbl[sec]

          -- if it was a section header, the very next line should contain comma-delimited
          -- format info for this section.  start by getting that line.
          line = file:GetLine()

          -- if it's the line with format info
          if line:find("^%s*Format:") then
            -- remove the "Format:" text
            line, _ = line:gsub("^%s*Format:", "")
            -- and split the remaining string on commas into an array
            current.Format = split(",", line)
          else
            lua.ReportScriptError( ("'Format:' line not found under '[%s]' section in %s"):format(sec, file_path) )
          end
        end

      else
        if (current.Format ~= nil) then

          if current.Data == nil then current.Data = {} end

          -- remove the "Dialogue:" text
          -- line, _ = line:gsub("^%s*%w+:%s?", "")
          line, _ = line:gsub("^%s*Dialogue:%s*", "")

          -- remove metadata wrapped in curly braces
          -- FIXME: there's useful positioning data in here we shouldn't just throw out!
          line, _ = line:gsub("{.-}","")


          local chunks = split(",", line, #current.Format)
          local t = {}

          for i,chunk in ipairs(chunks) do
            -- remove leading whitespace
            local k, _ = current.Format[i]:gsub("^%s*","")

            -- convert stringified timestamp to number of seconds
            if k=="Start" or k=="End" then
              t[k] = StrToSecs(chunk)

            -- cast stringified layer value to number
            elseif k=="Layer" then
              t[k] = tonumber(chunk)

            -- convert \N to unicode newline
            elseif k=="Text" then
              t[k] = chunk:gsub("\\N","\n")

            -- store as string
            else
              t[k] = chunk
            end
          end

          table.insert(current.Data, t)
        end
      end
    end
  end

  file:Close()
  file:destroy()

  if tbl.events and type(tbl.events)=="table" then
    if tbl.events.Data and #tbl.events.Data > 0 then
      -- tbl.events.Data is the relevant data we want to return to SM5
      return tbl.events.Data

    else
      lua.ReportScriptError(("Subtitle parsing error:\n'[Events]' section successfully found in %s, but dialogue lines not parsed correctly.\n\n"):format(file_path))
      return false
    end
  end

  lua.ReportScriptError(("Subtitle parsing error:\n'[Events]' section could not be found in %s.\n\n"):format(file_path))
  return false
end

return ParseFile