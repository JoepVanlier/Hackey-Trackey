--[[
@noindex
]]--

-- This file is left for compatibility reasons.
local info = debug.getinfo(1,'S');
fn = info.source:gsub("hackey_trackey_tracker", "tracker")

dofile(fn:sub(2));

