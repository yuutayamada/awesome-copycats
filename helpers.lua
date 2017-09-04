function clean(string)
  s = string.gsub(string, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

function whereis_app(app)
  local fh = io.popen('which ' .. app)
  s = clean(fh:read('*a'))

  if s == "" then return nil else return s end
  return s
end

function file_exists(file)
  local cmd = "/bin/bash -c 'if [ -e " .. file .. " ]; then echo true; fi;'"
  local fh = io.popen(cmd)

  s = clean(fh:read('*a'))

  if s == 'true' then return true else return nil end
end

function change_bg(wallpaper_dir, wallpaper_cmd)
  if whereis_app('feh') then
    mytimer = timer { timeout = 0 }
    mytimer:connect_signal("timeout",
                           function()
                             -- tell awsetbg to randomly choose a wallpaper from your wallpaper directory
                             if file_exists(wallpaper_dir) then
                               os.execute(wallpaper_cmd)
                             end
                             -- stop the timer (we don't need multiple instances running at the same time)
                             mytimer:stop()
                             -- define the interval in which the next wallpaper change should occur in seconds
                             -- (in this case anytime between 10 and 20 minutes)
                             x = math.random(600, 1200)
                             --restart the timer
                             mytimer.timeout = x
                             mytimer:start()
    end)
    -- initial start when rc.lua is first run
    mytimer:start()
  end
end
