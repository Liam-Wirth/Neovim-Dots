local tab = [[,tab:»■ ]]
local tab2 = [[,tab:→\ ]]
local tab3 = [[,tab:\ \ ]]
local extends = [[,extends:❯]]
local nbsp = [[,nbsp:␣]]
local precedes = [[,precedes:❮]]
vim.cmd("set listchars=eol:" .. "↩" .. tab2 .. extends .. precedes .. nbsp)
