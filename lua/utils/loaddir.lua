local loaddir = {}

loaddir.all = function(dir,base,exclude,callback)
    exclude = {}
    exclude["init"] = true
    --above line tells the function to ignore a file named init
    if dir and string.sub(dir, 1, 1) == "@" then
        dir = string.sub(dir,2)
    end
local ret = {}

  if not handle then
    Log.fmt_error("Error loading directory '%s'", dir)

    return
  end

  local name, typ, success, req, ext, res

  while handle do
    name, typ = vim.loop.fs_scandir_next(handle)

    if not name then
      -- Done, nothing left
      break
    end

    ext = vim.fn.fnamemodify(name, ":e")
    req = vim.fn.fnamemodify(name, ":r")

    if ((ext == "lua" and typ == "file") or (typ == "directory")) and not exclude[req] then
      success, res = pcall(require, base .. req)

      if success then
        ret[req] = res

        if callback and type(callback) == "function" then
          callback(res)
        end
      else
        Log.fmt_error("Error loading module '%s': %s", req, res)
      end
    end
  end

  return ret

   end
return loaddir

