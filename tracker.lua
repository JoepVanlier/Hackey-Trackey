-- Copyright (c) Joep Vanlier 2018
--
--    Permission is hereby granted, free of charge, to any person obtaining
--    a copy of this software and associated documentation files (the "Software"),
--    to deal in the Software without restriction, including without limitation
--    the rights to use, copy, modify, merge, publish, distribute, sublicense,
--    and/or sell copies of the Software, and to permit persons to whom the Software
--    is furnished to do so, subject to the following conditions:
--
--    The above copyright notice and this permission notice shall be included in
--    all copies or substantial portions of the Software.
--
--    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
--    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
--    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
--    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
--    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
--    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
--    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--
--    A lightweight LUA tracker for REAPER
--
--    Simply highlight a MIDI item and start the script.
--    This will bring up the MIDI item as a tracked sequence.
--
--    Work in progress. Input not yet implemented.
--

tracker = {}
tracker.eps = 1e-3
tracker.fov = {}
tracker.fov.scrollx = 0
tracker.fov.scrolly = 0
tracker.fov.width = 16
tracker.fov.height = 16
tracker.fov.abswidth = 450

tracker.trackFX = 1           -- Do we also want to track the automation?
tracker.hex = 1
tracker.preserveOff = 1
tracker.xpos = 1
tracker.ypos = 1
tracker.xint = 0
tracker.page = 4
tracker.lastVel = 96
tracker.lastEnv = 1
tracker.envShape = 1
tracker.rowPerQn = 4

tracker.cp = {}
tracker.cp.xstart = -1
tracker.cp.ystart = -1
tracker.cp.xstop = -1
tracker.cp.ystop = -1
tracker.cp.all = 0

tracker.outChannel = 1
tracker.magicOverlap = 10 --13.37

tracker.selectionBehavior = 0
tracker.transpose = 3
tracker.advance = 1

tracker.channels = 16 -- Max channel (0 is not shown)
tracker.displaychannels = 15
tracker.colors = {}
tracker.colors.selectcolor = {.7, 0, .5, 1}
tracker.colors.textcolor = {.7, .8, .8, 1}
tracker.colors.headercolor = {.5, .5, .8, 1}
tracker.colors.linecolor = {.1, .0, .4, .4}
tracker.colors.linecolor2 = {.3, .0, .6, .4}
tracker.colors.linecolor3 = {.4, .1, 1, 1}
tracker.colors.linecolor4 = {.2, .0, 1, .5}
tracker.colors.copypaste = {5.0, .7, 0.1, .2}
tracker.hash = 0

tracker.envShapes = {}
tracker.envShapes[0] = 'Lin'
tracker.envShapes[1] = 'S&H'
tracker.envShapes[2] = 'Exp'

tracker.hint = '';

keys = {}
--                    CTRL  ALT SHIFT Keycode
keys.left         = { 0,    0,  0,    1818584692 } -- <-
keys.right        = { 0,    0,  0,    1919379572 } -- ->
keys.up           = { 0,    0,  0,    30064 }      -- /\
keys.down         = { 0,    0,  0,    1685026670 } -- \/
keys.off          = { 0,    0,  0,    45 }         -- -
keys.delete       = { 0,    0,  0,    6579564 }    -- Del
keys.home         = { 0,    0,  0,    1752132965 } -- Home
keys.End          = { 0,    0,  0,    6647396 }    -- End
keys.toggle       = { 0,    0,  0,    32 }         -- Space
keys.playfrom     = { 0,    0,  0,    13 }         -- Enter
keys.insert       = { 0,    0,  0,    6909555 }    -- Insert
keys.remove       = { 0,    0,  0,    8 }          -- Backspace
keys.pgup         = { 0,    0,  0,    1885828464 } -- Page up
keys.pgdown       = { 0,    0,  0,    1885824110 } -- Page down
keys.undo         = { 1,    0,  0,    26 }         -- CTRL + Z
keys.redo         = { 1,    0,  1,    26 }         -- CTRL + SHIFT + Z
keys.beginBlock   = { 1,    0,  0,    2 }          -- CTRL + B
keys.endBlock     = { 1,    0,  0,    5 }          -- CTRL + E
keys.cutBlock     = { 1,    0,  0,    24 }         -- CTRL + X
keys.pasteBlock   = { 1,    0,  0,    22 }         -- CTRL + V
keys.copyBlock    = { 1,    0,  0,    3 }          -- CTRL + C
keys.shiftup      = { 0,    0,  1,    43 }         -- SHIFT + Num pad+
keys.shiftdown    = { 0,    0,  1,    45 }         -- SHIFT + Num pad-
keys.octaveup     = { 1,    0,  0,    30064 }      -- CTRL + /\
keys.octavedown   = { 1,    0,  0,    1685026670 } -- CTRL + \/
keys.envshapeup   = { 1,    0,  1,    30064 }      -- CTRL + SHIFT + /\
keys.envshapedown = { 1,    0,  1,    1685026670 } -- CTRL + SHIFT + /\

--

-- Base pitches
keys.pitches = {}
keys.pitches.z = 24-12
keys.pitches.x = 26-12
keys.pitches.c = 28-12
keys.pitches.v = 29-12
keys.pitches.b = 31-12
keys.pitches.n = 33-12
keys.pitches.m = 35-12
keys.pitches.s = 25-12
keys.pitches.d = 27-12
keys.pitches.g = 30-12
keys.pitches.h = 32-12
keys.pitches.j = 34-12
keys.pitches.q = 36-12
keys.pitches.w = 38-12
keys.pitches.e = 40-12
keys.pitches.r = 41-12
keys.pitches.t = 43-12
keys.pitches.y = 45-12
keys.pitches.u = 47-12
keys.pitches.i = 48-12
keys.pitches.o = 50-12
keys.pitches.p = 52-12

keys.octaves = {}
keys.octaves['0'] = 0
keys.octaves['1'] = 1
keys.octaves['2'] = 2
keys.octaves['3'] = 3
keys.octaves['4'] = 4
keys.octaves['5'] = 5
keys.octaves['6'] = 6
keys.octaves['7'] = 7
keys.octaves['8'] = 8
keys.octaves['9'] = 9

local function print(...)
  if ( not ... ) then
    reaper.ShowConsoleMsg("nil value\n")
    return
  end
  reaper.ShowConsoleMsg(...)
  reaper.ShowConsoleMsg("\n")
end

function alpha(color, a)
  return { color[1], color[2], color[3], color[4] * a }
end

function tracker:initColors()
  tracker.colors.linecolors  = alpha( tracker.colors.linecolor, 1.3 )
  tracker.colors.linecolor2s = alpha( tracker.colors.linecolor2, 1.3 )
  tracker.colors.linecolor3s = alpha( tracker.colors.linecolor3, 0.5 )    
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent, maxindent, verbose)
  if ( type(tbl) == "table" ) then 
    if not maxindent then maxindent = 2 end
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      local formatting = string.rep(" ", indent) .. k .. ": "
      if type(v) == "table" then
        if ( indent < maxindent ) then
          print(formatting)
          tprint(v, indent+1, maxindent)
        end
      else
        -- Hide the functions in shared.lua for clarity
        if ( not verbose ) then
          if type(v) == 'boolean' then
            print(formatting .. tostring(v))
          elseif type(v) == 'number' then
            print(formatting .. tostring(v))
          elseif (type(v) == 'userdata') and ( v.y ) then
            print(formatting .. " " .. tostring(v) .. ": ".. "x: "..v.x..", y: "..v.y)
          else
            print(formatting .. tostring(v))
          end
        end
      end
    end
  else
    if ( type(tbl) == "function" ) then 
      print('Function supplied to tprint instead of table')
    end
  end
end 

local function validHex( char )
  hex = {'A','B','C','D','E','F','a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}
  for i,v in pairs(hex) do
    if ( char == v ) then
      return true
    end
  end
  return false
end

------------------------------
-- Pitch => note
------------------------------
function tracker:generatePitches()
  local notes = { 'C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-' }
  local pitches = {}
  j = 12
  for i = 0,10 do
    for k,v in pairs(notes) do
      pitches[j] = v..i
      j = j + 1
    end
  end
  self.pitchTable = pitches
end

function namerep(str)
  str = str:gsub(" / ", "/")
  str = str:gsub("GUI", "")
  
  return str
end

------------------------------
-- Link GUI grid to data
------------------------------
function tracker:linkData()

  local fx        = self.fx
  
  -- Here is where the linkage between the display and the actual data fields in "tracker" is made
  local colsizes  = {}
  local datafield = {}
  local idx       = {}
  local padsizes  = {}  
  local headers   = {}
  local grouplink = {}    -- Stores what other columns are linked to this one (some act as groups)
  local hints     = {}
  
  if ( fx.names ) then
    for j = 1,#fx.names do
      datafield[#datafield+1] = 'fx1'
      idx[#idx+1]             = j
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 0
      grouplink[#grouplink+1] = {1}
      headers[#headers+1]     = 'FX'
      hints[#hints+1]         = namerep(fx.names[j])
      
      datafield[#datafield+1] = 'fx2'
      idx[#idx+1]             = j
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 2
      grouplink[#grouplink+1] = {-1}
      headers[#headers+1]     = ''
      hints[#hints+1]         = namerep(fx.names[j])
    end
  end
  
  datafield[#datafield+1] = 'legato'
  idx[#idx+1]             = 0
  colsizes[#colsizes+1]   = 1
  padsizes[#padsizes+1]   = 1
  grouplink[#grouplink+1] = {0}
  headers[#headers+1]     = string.format( 'L' )
  hints[#hints+1]         = 'Legato toggle'
  
  for j = 1,self.displaychannels do
    -- Link up the note fields
    datafield[#datafield+1] = 'text'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 3
    padsizes[#padsizes + 1] = 1
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {1, 2}
    else
      grouplink[#grouplink+1] = {0}    
    end
    headers[#headers + 1]   = string.format(' Ch%2d', j)
    hints[#hints+1]         = string.format('Note channel %2d', j)
    
    -- Link up the velocity fields
    datafield[#datafield+1] = 'vel1'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 1
    padsizes[#padsizes + 1] = 0
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {-1, 1}
    else
      grouplink[#grouplink+1] = {1}
    end
    headers[#headers + 1]   = ''    
    hints[#hints+1]         = string.format('Velocity channel %2d', j) 
    
    -- Link up the velocity fields
    datafield[#datafield+1] = 'vel2'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 1
    padsizes[#padsizes + 1] = 2
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {-2, -1}
    else       
      grouplink[#grouplink+1] = {-1}    
    end
    headers[#headers + 1]   = ''     
    hints[#hints+1]         = string.format('Velocity channel %2d', j) 
  end
  local link = {}
  link.datafields = datafield
  link.headers    = headers
  link.padsizes   = padsizes
  link.colsizes   = colsizes
  link.idxfields  = idx
  link.grouplink  = grouplink
  link.hints      = hints
  self.link       = link
end

function tracker:grabLinkage()
  local link = self.link
  return link.datafields, link.padsizes, link.colsizes, link.idxfields, link.headers, link.grouplink, link.hints
end

------------------------------
-- Establish what is plotted
------------------------------
function tracker:updatePlotLink()
  local plotData = {}
  local originx = 35
  local originy = 35
  local dx = 8
  local dy = 20
  plotData.barpad = 10
  plotData.itempadx = 5
  plotData.itempady = 3
  -- How far are the row indicators from the notes?
  plotData.indicatorShiftX = 3 * dx + 2 * plotData.itempadx
  plotData.indicatorShiftY = dy + plotData.itempady

  self.extracols = {}
  local datafields, padsizes, colsizes, idxfields, headers, grouplink, hints = self:grabLinkage()
  self.max_xpos = #headers
  self.max_ypos = self.rows
  
  -- Generate x locations for the columns
  local fov = self.fov
  local xloc = {}
  local xwidth = {}
  local xlink = {}
  local dlink = {}
  local glink = {}
  local header = {}
  local description = {}
  local x = originx
--  for j = fov.scrollx+1,math.min(#colsizes,fov.width+fov.scrollx) do
  local q
  for j = fov.scrollx+1,#colsizes do
    xpred = x + colsizes[j] * dx + padsizes[j] * dx
    if ( xpred > fov.abswidth ) then
      break;
    end
    xloc[#xloc + 1] = x
    xwidth[#xwidth + 1] = colsizes[j] * dx + padsizes[j]
    xlink[#xlink + 1] = idxfields[j]
    dlink[#dlink + 1] = datafields[j]
    glink[#glink + 1] = grouplink[j]
    header[#header + 1] = headers[j]
    description[#hints + 1] = hints[j]
    x = x + colsizes[j] * dx + padsizes[j] * dx
    q = j
  end
  fov.width = q-fov.scrollx
  plotData.xloc = xloc
  plotData.xwidth = xwidth
  plotData.totalwidth = 400 --x - padsizes[#padsizes] * dx - colsizes[#colsizes] * dx
  plotData.xstart = originx
  -- Variable dlink indicates what field the data can be found
  -- Variable xlink indicates the index that is being displayed
  plotData.dlink = dlink
  plotData.xlink = xlink
  plotData.glink = glink
  plotData.headers = header
  plotData.description = hints
  
  -- Generate y locations for the columns
  local yloc = {}
  local yheight = {}
  local y = originy
  for j = 0,math.min(self.rows-1, fov.height-1) do
    yloc[#yloc + 1] = y
    yheight[#yheight + 1] = 0.7 * dy
    y = y + dy
  end
  plotData.yloc = yloc
  plotData.yheight = yheight
  plotData.yshift = 0.2 * dy
  plotData.totalheight = y - originy
  plotData.ystart = originy
  
  self.plotData = plotData
end

------------------------------
-- Cursor and play position
------------------------------
function tracker:normalizePositionToSelf(cpos)
  local loc = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
  local loc2 = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH") 
  local row = ( cpos - loc ) * self.rowPerSec
  row = row - self.fov.scrolly
  local norm =  row / math.min(self.rows, self.fov.height)
  
  return norm
end

function tracker:getCursorLocation()
  return self:normalizePositionToSelf( reaper.GetCursorPosition() )
end

function tracker:getPlayLocation()
  if ( reaper.GetPlayState() == 0 ) then
    return self:getCursorLocation()
  else
    return self:normalizePositionToSelf( reaper.GetPlayPosition() )
  end
end

local function triangle( xc, yc, size, ori )
    local gfx = gfx
    ori = ori or 1
    gfx.line(xc-size,yc-ori*size,xc,yc+ori*size)
    gfx.line(xc,yc+ori*size,xc+size,yc-ori*size)
    gfx.line(xc+size,yc-ori*size,xc-size,yc-ori*size)
end

local function gmin( list )
  local c = 0
  for i,v in pairs( list ) do
    if ( v < c ) then
      c = v
    end
  end
  return c
end

local function gmax( list )
  local c = 0
  for i,v in pairs( list ) do
    if ( v > c ) then
      c = v
    end
  end
  return c
end

local function clamp( min, max, val )
  if ( val > max ) then
    return max
  elseif ( val < min ) then
    return min
  else
    return val
  end
end

------------------------------
-- Draw the GUI
------------------------------
function tracker:printGrid()
  local tracker   = tracker
  local colors    = tracker.colors
  local gfx       = gfx
  local channels  = self.displaychannels
  local rows      = self.rows
  local fov       = self.fov
  
  local plotData  = self.plotData
  local xloc      = plotData.xloc
  local xwidth    = plotData.xwidth
  local yloc      = plotData.yloc
  local yheight   = plotData.yheight
  
  local relx = tracker.xpos-fov.scrollx
  local rely = tracker.ypos-fov.scrolly
  
  gfx.set(table.unpack(colors.selectcolor))
  gfx.rect(xloc[relx], yloc[rely]-plotData.yshift, xwidth[relx], yheight[rely])
  
  local dlink         = plotData.dlink
  local xlink         = plotData.xlink
  local glink         = plotData.glink
  local description   = plotData.description
  local headers       = plotData.headers
  local tw            = plotData.totalwidth
  local th            = plotData.totalheight
  local itempadx      = plotData.itempadx
  local itempady      = plotData.itempady
  local scrolly       = fov.scrolly
  
  -- Render in relative FOV coordinates
  local data      = self.data
  for y=1,#yloc do
    gfx.y = yloc[y]
    gfx.x = xloc[1] - plotData.indicatorShiftX
    local absy = y + scrolly
    gfx.set(table.unpack(colors.headercolor))    
    gfx.printf("%3d", absy)
    local c1, c2
    if ( (((absy-1)/4) - math.floor((absy-1)/4)) == 0 ) then
      c1 = colors.linecolor2
      c2 = colors.linecolor2s
    else
      c1 = colors.linecolor
      c2 = colors.linecolors
    end
    gfx.set(table.unpack(c1))
    gfx.rect(xloc[1] - itempadx, yloc[y] - plotData.yshift, tw, yheight[1] + itempady)
    gfx.set(table.unpack(c2))
    gfx.rect(xloc[1] - itempadx, yloc[y] - plotData.yshift, tw, 1)
    gfx.rect(xloc[1] - itempadx, yloc[y] - plotData.yshift, 1, yheight[y])
    gfx.rect(xloc[1] - itempadx + tw + 0, yloc[y] - plotData.yshift, 1, yheight[y] + itempady)    
    for x=1,#xloc do
      gfx.x = xloc[x]
      gfx.set(table.unpack(colors.textcolor))
      gfx.printf("%s", data[dlink[x]][rows*xlink[x]+absy-1])
    end
  end
  
  -- Field descriptor
  gfx.x = plotData.xstart
  gfx.y = yloc[#yloc] + 1 * yheight[1] + itempady
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf("%s", description[relx])
  
  str = string.format("Oct [%d] Adv [%d] Env [%s]", self.transpose, self.advance, tracker.envShapes[tracker.envShape])
  gfx.x = plotData.xstart + tw - 8.2 * string.len(str)
  gfx.y = yloc[#yloc] + 1 * yheight[1] + itempady
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf(str)

  --[[--
  -- Octave
  gfx.x = plotData.xstart + tw + itempadx * 2
  gfx.y = yloc[1] + 1 * yheight[1] + itempady
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf("Octave: %d", self.transpose)
  
  -- Advance
  gfx.x = plotData.xstart + tw + itempadx * 2
  gfx.y = yloc[1] + 3 * yheight[1] + itempady
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf("Advance: %d", self.advance)  
  
  -- Rows / Qn
  gfx.x = plotData.xstart + tw + itempadx * 2
  gfx.y = yloc[1] + 5 * yheight[1] + itempady
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf("Resolution: %d", self.rowPerQn)    
  --]]--
  
  -- Draw the headers so we don't get lost :)
  gfx.set(table.unpack(colors.headercolor))
  gfx.y = yloc[1] - plotData.indicatorShiftY

  for x=1,#xloc do
    gfx.x = xloc[x]
    gfx.printf("%s", headers[x])
  end
  
  ------------------------------
  -- Clipboard block drawing
  ------------------------------
  local cp = self.cp
  if ( cp.ystart > 0 ) then
    local xl  = clamp(1, fov.width,  cp.xstart - fov.scrollx)
    local xe  = clamp(1, fov.width,  cp.xstop  - fov.scrollx)  
    local yl  = clamp(1, fov.height, cp.ystart - fov.scrolly)
    local ye  = clamp(1, fov.height, cp.ystop  - fov.scrolly)
    local xmi = clamp(1, fov.width,  xl + gmin(glink[xl]))
    local xma = clamp(1, fov.width,  xe + gmax(glink[xe]))
    gfx.set(table.unpack(colors.copypaste))    
    if ( cp.all == 0 ) then
      gfx.rect(xloc[xmi], yloc[yl] - plotData.yshift, xloc[xma] + xwidth[xma] - xloc[xmi], yloc[ye]-yloc[yl]+yheight[ye] )
    else
      gfx.rect(xloc[1] - itempadx, yloc[yl] - plotData.yshift, tw, yloc[ye]-yloc[yl]+yheight[ye] )
    end
  end
    
  ------------------------------
  -- Play location indicator
  ------------------------------    
  local playLoc = self:getPlayLocation()
  local xc = xloc[1] - .5 * plotData.indicatorShiftX
  local yc = yloc[1] - .8 * plotData.indicatorShiftY  
  if ( playLoc < 0 ) then   
      gfx.set(table.unpack(colors.linecolor3s))     
      triangle(xc, yc+1, 3, -1)        
      gfx.set(table.unpack(colors.linecolor3))
      triangle(xc, yc, 5, -1)
  else
    if ( playLoc > 1 ) then
      gfx.set(table.unpack(colors.linecolor3s))
      triangle(xc, yc-1, 3, 1)           
      gfx.set(table.unpack(colors.linecolor3))
      triangle(xc, yc, 5, 1)    
    else
      gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * playLoc - itempady - 1, tw, 1)
    end
  end
  local markerLoc = self:getCursorLocation()
  if ( markerLoc > 0 and markerLoc < 1 ) then
    gfx.set(table.unpack(colors.linecolor4))
    gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * self:getCursorLocation() - itempady - 1, tw, 1)
  end
end

-- Returns fieldtype, channel and row
function tracker:getLocation()
  local plotData  = self.plotData
  local dlink     = plotData.dlink
  local xlink     = plotData.xlink
  local relx      = tracker.xpos - tracker.fov.scrollx
  
  return dlink[relx], xlink[relx], tracker.ypos - 1
end

function tracker:placeOff()
  local rows      = self.rows
  local notes     = self.notes
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart 
  
  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()
  
  -- Note off is only sensible for note fields
  local idx = chan*rows+row
  local note = noteGrid[idx]
  local start = noteStart[idx]
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) ) then  
    -- If there is no note here add a marker for the note off event
    if ( not note ) then
      ppq = self:rowToPpq(row)
      self:addNoteOFF(ppq, chan)
      return
    else
      if ( note > -1 ) then
        -- We need to check whether the note we are about to delete or shorten was already terminated by an OFF
        -- In this case, we need to add a new OFF symbol at that location to not lose that one.
        local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
        local lastend = self:ppqToRow(endppqpos)
        if ( noteGrid[chan*rows+lastend] and ( noteGrid[chan*rows+lastend] < 0 ) ) then
          ppq = self:rowToPpq(lastend)
          self:addNoteOFF(ppq, chan)
        end
               
        if ( start ) then
          -- If it was the start of a new note previously, that means a legato'd bit may have to be undone
          if ( chan == 1 ) then
            if ( row > 0 ) then
              if ( self.legato[row] > -1 ) then
                local prevnote = noteGrid[idx-1]
                if ( prevnote and ( prevnote > -1 ) ) then
                  local p2, v2, startppq2, endppq2 = table.unpack( notes[prevnote] )
                  endppq2 = endppq2-self.magicOverlap
                  reaper.MIDI_SetNote(self.take, prevnote, nil, nil, nil, endppq2, nil, nil, nil, true)
                end
              end
            end
          end
        
          if ( row > 0 ) then
            local chk = noteGrid[idx-1]
            if ( not chk or ( chk < 0 ) ) then
              ppq = self:rowToPpq(row)
              self:addNoteOFF(ppq, chan)
            end
          else
            ppq = self:rowToPpq(row)
            self:addNoteOFF(ppq, chan)
          end
          
          -- If there is no note at the end
          self:deleteNote(chan, row)
        else
          local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
         
          -- Make sure that the current note is resized accordingly
          ppq = self:rowToPpq(row)          
          reaper.MIDI_SetNote(self.take, note, nil, nil, startppqpos, ppq, nil, nil, nil, true)
        end
      end
    end
  end
  self.ypos = self.ypos + self.advance
end

---------------------
-- Shift operator
---------------------
function tracker:shiftAt( x, y, shift )
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local noteStart = self.data.noteStart  
  local notes = self.notes
  
  local chan = idxfields[x]
  local selected = noteStart[ chan*self.rows + y - 1 ]
  
  if ( selected ) then
    local note = notes[selected]
    if ( datafields[x] == 'text' ) then
      -- Note
      local pitch, vel, startppqpos, endppqpos = table.unpack( note )
      reaper.MIDI_SetNote(self.take, selected, nil, nil, nil, nil, nil, pitch+shift, nil, true) 
    elseif ( datafields[x] == 'vel1' ) or ( datafields[x] == 'vel2' ) then
      -- Velocity
      local pitch, vel, startppqpos, endppqpos = table.unpack( note )
      reaper.MIDI_SetNote(self.take, selected,   nil, nil, nil, nil, nil, nil, vel+shift, true)     
    end
  end
end

function tracker:shiftup()
  local cp = self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift operation")
  reaper.MarkProjectDirty(0)
  
  if ( cp.ystop == -1 ) then
    self:shiftAt( tracker.xpos, tracker.ypos, 1 )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, 1 )
      end
    end
  end
  reaper.MIDI_Sort(self.take)
end

function tracker:shiftdown()
  local cp = self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift operation")
  reaper.MarkProjectDirty(0)
  
  if ( cp.ystop == -1 ) then  
    self:shiftAt( tracker.xpos, tracker.ypos, -1 )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, -1 )
      end
    end
  end
  reaper.MIDI_Sort(self.take)
end

function tracker:addNote(startrow, endrow, chan, pitch, velocity)
  local startppqpos = self:rowToPpq(startrow)
  local endppqpos   = self:rowToPpq(endrow)

  if ( self.legato[endrow] > -1 ) then
    endppqpos = endppqpos + tracker.magicOverlap
  end

  reaper.MIDI_InsertNote( self.take, false, false, startppqpos, endppqpos, chan, pitch, velocity, true )
end

---------------------
-- Add note
---------------------
function tracker:createNote( inChar )

  if ( not inChar or ( inChar > 256 ) ) then
    return
  end

  local char      = string.lower(string.char(inChar))
  local data      = self.data
  local notes     = self.notes
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local rows      = self.rows
  local singlerow = self:rowToPpq(1)

  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()
  local noteToEdit = noteStart[rows*chan+row]
  local noteToInterrupt
  if ( row > 0 ) then
    noteToInterrupt = noteGrid[rows*chan+row-1]
  else
    noteToInterrupt = noteGrid[rows*chan+row]
  end
  
   -- What are we manipulating here?
  if ( ftype == 'text' ) then
    local note = keys.pitches[char]
    if ( note ) then
      -- Note is present, we are good to go!
      local pitch = note + tracker.transpose * 12
      
      -- Is there already a note starting here? Simply change the note.
      if ( noteToEdit ) then
        reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, pitch, nil, true)
      else
        -- No note yet? See how long the new note can get. Note that we have to ignore any note
        -- we might be interrupting (placed in the middle of)
        local k = row+1
        while( k < rows ) do
          if ( noteGrid[rows*chan+k] and not ( noteGrid[rows*chan+k] == noteToInterrupt ) ) then
            break;
          end
          k = k + 1
        end       

        -- Create the new note!
        self:addNote(row, k, chan, pitch, self.lastVel)
      
        local extraDeletion
        if ( noteGrid[rows*chan+k] ) then
          if ( noteGrid[rows*chan+k] < -1 ) then    
            extraDeletion = noteGrid[rows*chan+k]
            self:deleteNote(chan, k)
          end
        end
        
        -- If we interrupted a note, that note needs to be shortened / removed!
        -- If we overwrote an OFF marker that was still here, then it needs to be removed as well. 
        if ( noteToInterrupt ) then
          -- Note
          if ( noteToInterrupt > -1 ) then
            -- Shorten the note we are interrupting
            local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToInterrupt] )
            endppqpos = self:rowToPpq(row)
            
            -- Check if we are at a legato point. Since we are interrupting a note, 
            -- we have to maintain additional overlap
            if ( chan == 1 ) then
              local legato = self.legato
              if ( legato[row] and ( legato[row] > -1 ) ) then
                endppqpos = endppqpos + tracker.magicOverlap          
              end
            end
            
            -- Set the new note length
            reaper.MIDI_SetNote(self.take, noteToInterrupt, nil, nil, nil, endppqpos, nil, nil, nil, true)
          end
          
          -- Were we overwriting an OFF marker?
          if ( noteToInterrupt < -1 ) then
            self:deleteNote(chan, row)
          end
        end
      end
      self.ypos = self.ypos + self.advance
    else
      local octave = keys.octaves[char]
      if ( octave ) then
        if ( noteToEdit ) then
          local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )
          pitch = pitch - math.floor(pitch/12)*12 + (octave+1) * 12        
          reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, pitch, nil, true)
        end
        self.ypos = self.ypos + self.advance
      end
    end
  elseif ( ( ftype == 'vel1' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )
      local newvel = tracker:editVelField( vel, 1, char )
      self.lastVel = newvel
      reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, nil, newvel, true)
    end
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'vel2' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )    
      local newvel = tracker:editVelField( vel, 2, char )      
      self.lastVel = newvel      
      reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, nil, newvel, true)
      self.ypos = self.ypos + self.advance
    end
  elseif ( ( ftype == 'fx1' ) and validHex( char ) ) then
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos))
    env = env or self.lastEnv
    local newEnv = tracker:editEnvField( env, 1, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)
    self.ypos = self.ypos + self.advance
    self.lastEnv = newEnv
  elseif ( ( ftype == 'fx2' ) and validHex( char ) ) then
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos))
    env = env or self.lastEnv  
    local newvel = tracker:editEnvField( env, 2, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)    
    self.ypos = self.ypos + self.advance
    self.lastEnv = newEnv
  elseif ( ftype == 'legato' ) then
    if ( char == '1' ) then
      self:addLegato( row )
    elseif ( char == '0' ) then
      self:deleteLegato( row )
    elseif ( char == '.' ) then
      self:deleteLegato( row )    
    end
    self.ypos = self.ypos + self.advance
  end  
end

--------------------------
-- Delay deletion because otherwise we get sorting
-- issues with our matrix going out of date
--------------------------
function tracker:clearDeleteLists()
  tracker.deleteNotes = {}
  tracker.deleteText = {}
end

function tracker:clearInsertLists()
  tracker.insertTxt = {}
end

function tracker:SAFE_InsertTextSysexEvt(ppq, txtType, str)
  table.insert( tracker.insertTxt, {ppq, txtType, str} )
end

function tracker:SAFE_DeleteNote( take, note )
  tracker.deleteNotes[note] = note
end

function tracker:SAFE_DeleteText( take, txt )
  tracker.deleteText[txt] = txt
end

function orderedpairs(inTable, order)
  if ( not inTable ) then
    print( "Warning! Error in iterator: passed nil to spairs" )
    return function() return nil end
  end

  local keys = {}
  for k in pairs(inTable) do table.insert(keys, k) end
  table.sort(keys, function(a,b) return a > b end)

  local i = 0
  return function()
    i = i + 1
    if ( keys[i] ) then
      return keys[i], inTable[keys[i]]
    end
  end
end

function tracker:insertNow( )
  for i,v in pairs( tracker.insertTxt ) do
    reaper.MIDI_InsertTextSysexEvt(self.take, false, false, v[1], v[2], v[3])
  end
end

function tracker:deleteNow( )
  local deleteNotes = self.deleteNotes
  local deleteText  = self.deleteText
  local i

  for i,v in orderedpairs(deleteNotes) do
    reaper.MIDI_DeleteNote(self.take, v)
  end
  for i,v in orderedpairs(deleteText) do
    reaper.MIDI_DeleteTextSysexEvt(self.take, v)
  end    
end

---------------------
-- Check whether the previous note can grow if this one would be gone
-- Shift indicates that the fields downwards of row will go up
-- legatoWasOff indicates that the old note end position was capped by
-- a custom OFF and therefore set to not be legato despite what the field
-- says.
---------------------
function tracker:checkNoteGrow(notes, noteGrid, rows, chan, row, singlerow, noteToDelete, shift, legatoWasOff)
  local modify = 0
  local offset = shift or 0
  if ( row > -1 ) then
    local noteToResize = noteGrid[rows*chan+row - 1]
          
    if ( noteToResize and ( noteToResize > -1 ) ) then
      local k = row+1
      while( k < rows ) do
        idx = rows*chan+k
        if ( noteGrid[idx] and ( not ( noteGrid[idx] == noteToDelete ) ) ) then
          break;
        end
        k = k + 1
      end
      local resize = k-row

      -- If we are the last note, then it may go to the end of the track, hence only subtract
      -- the shift offset if we are not the last note in the pattern
      local magic = 0
      if ( k < rows ) then
        resize = resize - offset
        -- We might want to add some extra for legato. Note that coming from an OFF symbol,
        -- we need to take into account that these have forced legato offs.
        if ( legatoWasOff ) then
          magic = self:legatoResize(0, -1, self.legato[k])        
        else
          magic = self:legatoResize(0, self.legato[row], self.legato[k])
        end
      end
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToResize] )
      reaper.MIDI_SetNote(self.take, noteToResize, nil, nil, startppqpos, self:clampPpq( endppqpos + singlerow * resize + magic ), nil, nil, nil, true)
      
      -- Is there an OFF symbol at this location?
      if ( k < rows ) then
        if ( noteGrid[rows*chan+k] < -1 ) then
          tracker:deleteNote(chan, k)
        end
      end
    end
  end
end

function tracker:legatoResize(endppqpos, oldLegato, newLegato)
  if ( ( newLegato > -1 ) and ( oldLegato < 0 ) ) then
    endppqpos = endppqpos + tracker.magicOverlap
  elseif ( ( newLegato < 0 ) and ( oldLegato > -1 ) ) then
    endppqpos = endppqpos - tracker.magicOverlap
  end
  return endppqpos
end

---------------------
-- Shrink a note
---------------------
function tracker:shrinkNote(chan, row, size)
  local notes     = self.notes
  local singlerow = self:rowToPpq(1)
  local noteGrid  = self.data.note
  local rows      = self.rows
  local note      = noteGrid[ rows * chan + row ]
  
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local endrow = math.floor(self:ppqToRow( endppqpos ))
  
  -- Is it the last note with an open end, then stay that way.
  -- There is nothingness outside our pattern! :)
  if ( endppqpos <= self:rowToPpq( self.rows-1 ) ) then
    if ( chan == 1 ) then
      local legato = self.legato
      
      -- Check if it's legato at the old end position!
      local oldLegato = legato[endrow]
      local newLegato = legato[endrow-1]
      endppqpos = self:legatoResize(endppqpos, oldLegato, newLegato)      
    end
    reaper.MIDI_SetNote(self.take, note, nil, nil, startppqpos, endppqpos - singlerow, nil, nil, nil, true)
  end
end

---------------------
-- Grow a note
---------------------
function tracker:growNote(chan, row, size)
  local notes     = self.notes
  local singlerow = self:rowToPpq(1)
  local noteGrid  = self.data.note
  local rows      = self.rows
  local note      = noteGrid[ rows * chan + row ]
  
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local endrow = math.floor(self:ppqToRow( endppqpos ))
  
  -- Is it the last note with an open end, then stay that way.
  -- There is nothingness outside our pattern! :)
  if ( endppqpos <= self:rowToPpq( self.rows-1 ) ) then
  
    if ( chan == 1 ) then
      local legato = self.legato
      
      -- Check if it's legato at the old end position!
      local oldLegato = legato[endrow]
      local newLegato = legato[endrow+1]
      endppqpos = self:legatoResize(endppqpos, oldLegato, newLegato)
    end
    
    reaper.MIDI_SetNote(self.take, note, nil, nil, startppqpos, endppqpos + singlerow, nil, nil, nil, true)
  end
end

---------------------
-- Backspace
---------------------
function tracker:backspace()
  local data      = self.data
  local rows      = self.rows
  local notes     = self.notes
  local singlerow = self:rowToPpq(1)

  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()
  
   -- What are we manipulating here?
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) ) then
    local noteGrid = data.note
    local noteStart = data.noteStart          
    local lastnote
    local note = noteGrid[rows*chan+row]
    local noteToDelete = noteStart[rows*chan+row]
    
    -- Note == -1 is a natural OFF (based on the previous note), hence note < 0 as criterion
    -- since removing this would lead to a necessary check for elongation of the previous note
    if ( noteToDelete or ( note and note < 0 ) ) then    
      -- Are we on the start of a note or an OFF symbol? This would mean that the previous note can grow
      -- Check whether there is a note before this, and elongate it until the next blockade
      if ( note < 0 ) then
        -- OFFs are special, in the sense that they block the legato extension. This means 
        -- that we should set the final flag to one to convey this to checkNoteGrow
        self:checkNoteGrow(notes, noteGrid, rows, chan, row, singlerow, noteStart[rows*chan+row], 1,   1)
      else
        self:checkNoteGrow(notes, noteGrid, rows, chan, row, singlerow, noteStart[rows*chan+row], 1)      
      end
    elseif ( note and ( note > -1 ) ) then
      -- We are in the middle of a note, so it must get smaller
      self:shrinkNote(chan, row, 1)
      lastnote = note
    end         
          
    -- Everything below this note has to shift one up
    for i = row,rows-1 do
      local note = noteGrid[rows*chan+i]
      if ( note ~= lastnote ) then
        if ( note ) then
          self:shiftNote(chan, i, -1)
        end
      end
      lastnote = note
    end
    
    -- Were we on a note start or a custom OFF? ==> Kill it
    if ( noteToDelete or ( note and ( note < -1 ) ) ) then
      self:deleteNote(chan, row, -1)
    end
  elseif ( ftype == 'legato' ) then
    local lastleg = false
    local legato = self.legato
    for i = rows-1,row,-1 do
      self:setLegato( i, lastleg )
      lastleg = legato[i]>-1
    end
  else
    print( "FATAL ERROR IN TRACKER.LUA: unknown field?" )
    return
  end
end

---------------------
-- Add OFF flag
---------------------
function tracker:addNoteOFF(ppq, channel) 
  -- Is it within pattern range?
  if ( ppq < self:rowToPpq( self.rows - 1 ) ) then
    reaper.MIDI_InsertTextSysexEvt(self.take, false, false, ppq, 1, string.format('OFF%2d', channel))
  end
end

function printbool( bool )
  if ( bool ) then
    if ( bool == true ) then
      print( "true" )
    else
      print( "false" )
    end
  else
    print("false")
  end
end

---------------------
-- Delete note
---------------------
-- The shift argument can be used if the row below the row at which things are being deleted
-- have to be interpreted as being shifted by a note (legacy).
function tracker:deleteNote(channel, row, shiftIn)
  local rows      = self.rows
  local notes     = self.notes
  local noteGrid  = self.data.note
  local shift     = shiftIn or 0
  local singlerow = self:rowToPpq(1)

  -- Deleting note requires some care, in some cases, there may be an OFF trigger which needs to be stored separately
  -- since we don't want them disappearing with the notes.
  noteToDelete = noteGrid[rows*channel+row]
  if ( tracker.preserveOff == 1 ) then
    if ( noteToDelete ) then
      if ( noteToDelete > -1 ) then
        -- We are deleting a note
  
        -- We need a noteOFF iff
        --   - There is no note on the previous row
        local shouldBeEmpty1
        if ( row > 0 ) then 
          shouldBeEmpty1 = noteGrid[rows*channel+row-1]
          shouldBeEmpty1 = shouldBeEmpty1 and ( shouldBeEmpty1 > -1 )
        end
              
        --   - There is no note where the current note currently ends
        local shouldBeEmpty2
        local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToDelete] )
        local endrow = self:ppqToRow(endppqpos)
        shouldBeEmpty2 = noteGrid[rows*channel+endrow]
        shouldBeEmpty2 = shouldBeEmpty2 and ( shouldBeEmpty2 > -1 )
              
        --   - The current note ended before the end of the pattern
        -- This one is automatically fulfilled because events outside of the time range get deleted by reaper
  
        if ( ( not shouldBeEmpty1 ) and ( not shouldBeEmpty2 ) ) then
          -- We need an explicit OFF symbol. We need to store this separately!
          tracker:addNoteOFF(endppqpos + shift * singlerow, channel)      
        end
        self:SAFE_DeleteNote(self.take, noteToDelete)      
      else
        -- We are deleting a custom OFF symbol
        if ( noteToDelete < -1 ) then
          -- It is an OFF
          local offidx = self:gridValueToOFFidx( noteToDelete )
          self:SAFE_DeleteText(self.take, offidx)
        end
      end
    end
  else
    -- No off preservation, just delete it.
    self:SAFE_DeleteNote(self.take, noteToDelete)
  end
end


---------------------
-- Delete
---------------------
function tracker:delete()
  local data      = self.data
  local rows      = self.rows
  local notes     = self.notes
  local singlerow = self:rowToPpq(1)
  local modify    = 0

  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()
  
  -- What are we manipulating here?
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) ) then
    local noteGrid = data.note
    local noteStart = data.noteStart
  
    -- OFF marker
    if ( noteGrid[rows*chan+row] and ( noteGrid[rows*chan+row] < 0 ) ) then
      -- Check whether the previous note can grow now that this one is gone
      tracker:checkNoteGrow(notes, noteGrid, rows, chan, row, singlerow, nil, nil, 1)
      if ( noteGrid[rows*chan+row] < -1 ) then
        self:deleteNote(chan, row)
      end
    end
    
    -- Note that we look at note start here.
    -- This means that this deleteNote call can never conflict with the deleteNote
    -- call that may arise from deleting an OFF marker.
    local noteToDelete = noteStart[rows*chan+row]
    if ( noteToDelete ) then
      reaper.MarkProjectDirty(0)    
      self:checkNoteGrow(notes, noteGrid, rows, chan, row, singlerow, noteToDelete)
      self:deleteNote(chan, row)
    end
  elseif ( ftype == 'legato' ) then
    self:deleteLegato(row)
  elseif ( ftype == 'fx1' or ftype == 'fx2' ) then
    self:deleteEnvPt(chan, self:toSeconds(row) )
  else
    print( "FATAL ERROR IN TRACKER.LUA: unknown field?" )
    return
  end  
end

---------------------
-- Shift an OFF field
---------------------
function tracker:gridValueToOFFidx(gridvalue)
  return - gridvalue - 2
end

---------------------------------------------------------------------------------------------------
-- Shifts note or OFFs at particular position
-- WARNING: this function should only be used at the end or when it is guaranteed that no more
-- MIDI editing will take place, since it will invalidate the notes matrices
---------------------------------------------------------------------------------------------------
function tracker:shiftNote(chan, row, shift) 
  local txtList     = self.txtList
  local singlerow   = self:rowToPpq(1)
  local noteGrid    = self.data.note
  local rows        = self.rows
  local gridValue   = noteGrid[rows*chan+row]

  if ( gridValue > -1 ) then
    -- It is a note
    local notes = self.notes
    local magicOverlap = self.magicOverlap
    local pitch, vel, startppqpos, endppqpos = table.unpack( notes[gridValue] )
    local wasLegatoTransition = self.legato[self:ppqToRow(endppqpos)]
    local newEnd = endppqpos + shift*singlerow
    local isLegatoTransition = self.legato[self:ppqToRow(newEnd)]
    
    -- Is it the last note with an open end, then stay that way.
    -- There is nothingness outside our pattern! :)
    if ( endppqpos > self:rowToPpq( self.rows-1 ) ) then
      if ( shift < 0 ) then
        newEnd = endppqpos
      end
    else
      -- Is it a legato note?
      if ( chan == 1 ) then     
        newEnd = self:legatoResize(newEnd, wasLegatoTransition, isLegatoTransition)
      end
    end
    
    if ( row < rows ) then
      reaper.MIDI_SetNote(self.take, gridValue, nil, nil,startppqpos + shift*singlerow, newEnd, nil, nil, nil, true)
    else
      self:deleteNote(chan, row)
    end
  end
  if ( gridValue < -1 ) then
    -- It is an OFF
    local offidx = self:gridValueToOFFidx( gridValue )
    local ppq = table.unpack( txtList[offidx] )
    if ( row < rows ) then
      reaper.MIDI_SetTextSysexEvt(self.take, offidx, nil, nil, ppq + shift*singlerow, nil, "", true)
    else
      self:SAFE_DeleteText(self.take, offidx)
    end
  end
end

---------------------
-- Insert
---------------------
function tracker:insert()
  local data      = self.data
  local singlerow = self:rowToPpq(1)
  local rows     = self.rows
  
  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()  
  
  -- What are we manipulating here?
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) ) then
    local noteGrid = data.note
    local noteStart= data.noteStart    
    local notes    = self.notes
    
    local elongate
    -- Are we inside a note? ==> It needs to be elongated!    
    if ( not noteStart[rows*chan+row] ) then
      elongate = noteGrid[rows*chan+row]
      if ( elongate ) then        
        if ( elongate < -1 ) then
          -- It was an explicit OFF. Shift it!
          -- Note that this means that the previous note cannot be an actual note
          -- Note that the deletion is safe, since an insert can at most drop one MIDI element at once
          self:shiftNote(chan, row, 1)
        end
        
        -- Was the previous row a note? Then we must elongate
        if ( row > 0 ) then
          elongate = noteGrid[rows*chan+row - 1]
          if ( elongate and elongate > -1 ) then
            -- Let's elongate the note by a row!
            self:growNote( chan, row-1 )
          end
        end        
      end
    else
      -- We are at a note start... maybe there is a previous note who wants to be elongated?
      if ( row > 1 ) then
        local note = noteGrid[rows*chan+row-1]
        if ( note and ( note > -1 ) ) then
          self:growNote( chan, row-1 )
        end
      end
    end

    -- Everything below this note has to go one shift down
    local lastnote = elongate
    for i = row,rows-1 do
      local note = noteGrid[rows*chan+i]
      if ( note ~= lastnote ) then
        if ( note ) then
          -- Shift it!
          self:shiftNote(chan, i, 1)
        end
      end
      lastnote = note
    end
  elseif ( ftype == 'legato' ) then
    local lastleg = false
    for i = row,rows-1 do
      self:setLegato( i, lastleg )
      lastleg = self.legato[i]>-1
    end
  else
    print( "FATAL ERROR IN TRACKER.LUA: unknown field?" )
    return
  end
end


------------------------------
-- Force selector in range
------------------------------
function tracker:forceCursorInRange()
  local fov = self.fov
  if ( self.xpos < 1 ) then
    self.xpos = 1
  end
  if ( self.ypos < 1 ) then
    self.ypos = 1
  end
  if ( self.xpos > self.max_xpos ) then
    self.xpos = math.floor( self.max_xpos )
  end
  if ( self.ypos > self.max_ypos ) then
    self.ypos = math.floor( self.max_ypos )
  end
  -- Is the cursor off fov?
  if ( ( self.ypos - fov.scrolly ) > self.fov.height ) then
    self.fov.scrolly = self.ypos - self.fov.height
  end
  if ( ( self.ypos - fov.scrolly ) < 1 ) then
    self.fov.scrolly = self.ypos - 1
  end
  -- Is the cursor off fov?
  if ( ( self.xpos - fov.scrollx ) > self.fov.width ) then
    self.fov.scrollx = self.xpos - self.fov.width
    self:updatePlotLink()
  end
  if ( ( self.xpos - fov.scrollx ) < 1 ) then
    self.fov.scrollx = self.xpos - 1
    self:updatePlotLink()
  end    
end

function tracker:toSeconds(row)
  return row / self.rowPerSec
end

function tracker:rowToPpq(row)
  return row * self.ppqPerRow
end

function tracker:ppqToRow(ppq)
  return math.floor( ppq / self.ppqPerRow )
end

function tracker:rowToAbsPpq(row)
  return row * self.ppqPerRow + self.minppq
end

function tracker:toQn(seconds)
  return self.rowPerQn * seconds / self.rowPerSec
end

------------------------------
-- Determine timing info
-- returns true if something changed
------------------------------
function tracker:getRowInfo()
    -- How many rows do we need?
    local ppqPerQn = reaper.MIDI_GetPPQPosFromProjQN(self.take, 1) - reaper.MIDI_GetPPQPosFromProjQN(self.take, 0)
    local ppqPerSec = 1.0 / ( reaper.MIDI_GetProjTimeFromPPQPos(self.take, 1) - reaper.MIDI_GetProjTimeFromPPQPos(self.take, 0) )
    local mediaLength = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    
    self.length   = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    self.position = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
    
    self.maxppq   = ppqPerSec * self.length
    self.minppq   = ppqPerSec * self.position
    
    self.qnCount = mediaLength * ppqPerSec / ppqPerQn
    self.rowPerPpq = self.rowPerQn / ppqPerQn
    self.ppqPerRow = 1 / self.rowPerPpq
    self.rowPerSec = ppqPerSec * self.rowPerQn / ppqPerQn
    local rows = math.floor( self.rowPerQn * self.qnCount )
    
    -- Do not allow zero rows in the tracker!
    if ( rows < self.eps ) then
      reaper.SetMediaItemInfo_Value(self.item, "D_LENGTH", self:toSeconds(1) )
      rows = 1
    end
    
    if ( ( self.rows ~= rows ) or ( self.ppqPerQn ~= ppqPerQn ) ) then
      self.rows = rows
      self.qnPerPpq = 1 / ppqPerQn      
      self.ppqPerQn = ppqPerQn
      return true
    else
      return false
    end
end

------------------------------
-- MIDI => Tracking
------------------------------
-- Check if a space in the column is already occupied
function tracker:isFree(channel, y1, y2, treatOffAsFree)
  local rows = self.rows
  local notes = self.data.note
  local offFree = treatOffAsFree or 1
  --offFree = 1
  for y=y1,y2 do
    -- Occupied
    if ( notes[rows*channel+y] ) then
      if ( offFree == 1 ) then
        -- -1 indicates an OFF, which is considered free when treatOffAsFree is on :)
        if ( ( notes[rows*channel+y] > -1 ) or ( notes[rows*channel+y] < -1 ) ) then
          return false
        end
      else
        return false
      end
    end
  end
  return true
end

-- Assign a note that is already in the MIDI data
function tracker:assignFromMIDI(channel, idx)
  local pitchTable = self.pitchTable
  local rows = self.rows
  
  local notes = self.notes
  local starts = self.noteStarts
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[idx] ) 
  local ystart = math.floor( startppqpos * self.rowPerPpq + self.eps )

  -- Is this a legato note? Pretend it is shorter.
  if ( channel == 1 ) then
    local endrow = math.floor( endppqpos * self.rowPerPpq ) 
    if ( self.legato[endrow] and self.legato[endrow] > -1 ) then
      endppqpos = endppqpos - tracker.magicOverlap
    end
  end
  local yend = math.floor( endppqpos * self.rowPerPpq - self.eps )
  
  -- This note is not actually present
  if ( ystart > self.rows-1 ) then
    return true
  end
  if ( ystart < -self.eps ) then
    return true
  end
  if ( yend > self.rows - 1 ) then
    yend = self.rows
  end
  
  -- Add the note if there is space on this channel, otherwise return false
  local data = self.data
  if ( self:isFree( channel, ystart, yend ) ) then
    data.text[rows*channel+ystart]      = pitchTable[pitch]
    data.vel1[rows*channel+ystart]      = self:velToField(vel, 1)
    data.vel2[rows*channel+ystart]      = self:velToField(vel, 2)    

    data.noteStart[rows*channel+ystart] = idx
    for y = ystart,yend,1 do
      data.note[rows*channel+y] = idx
    end
    if ( yend+1 < rows ) then
      if ( self:isFree( channel, yend+1, yend+1, 1 ) ) then
        data.text[rows*channel+yend+1] = 'OFF'
        data.note[rows*channel+yend+1] = -1
      end
    end
    return true
  else
    return false
  end  
end

-- Assign off locations
function tracker:assignOFF(channel, idx)
  local data = self.data
  local rows = self.rows
  local txtList = self.txtList
  
  local ppq = table.unpack( txtList[idx] )
  local row = math.floor( ppq * self.rowPerPpq )
  data.text[rows*channel + row] = 'OFC'
  data.note[rows*channel + row] = -idx - 2
end

------------------------
-- Helper functions
------------------------
local function round(x)
  if x%2 ~= 0.5 then
    return math.floor(x+0.5)
  end
  return x-0.5
end

-- (255/127)
hexdec = 1 --255/127
function tracker:velToField( vel, id )
  return string.sub( string.format('%02X', math.floor(vel*hexdec) ), id, id )
end

function tracker:editVelField( vel, id, val )
  -- Convert to Hex first
  local newvel = string.format('%2X', math.floor(vel*hexdec) )
  -- Replace the digit in question
  newvel = newvel:sub( 1, id-1 ) .. val ..  newvel:sub( id+1 )
  newvel = math.floor( tonumber( "0x"..newvel ) / hexdec )
  newvel = clamp(1, 127, newvel)
  return newvel
end

function tracker:editEnvField( vel, id, val )
  -- Convert to Hex first
  local newvel = string.format('%2X', math.floor(vel*255) )
  -- Replace the digit in question
  newvel = newvel:sub( 1, id-1 ) .. val ..  newvel:sub( id+1 )
  newvel = math.floor( tonumber( "0x"..newvel ) / hexdec )
  newvel = clamp(0, 255, newvel)
  newvel = newvel / 255
  return newvel
end

------------------------------
-- Internal data initialisation
-----------------------------
function tracker:initializeGrid()
  local x, y
  local data = {}
  data.noteStart = {}
  data.note = {}
  data.text = {}
  data.vel1 = {}
  data.vel2 = {}    
  data.legato = {}
  self.legato = {}
  data.fx1 = {}
  data.fx2 = {}
  local channels = self.channels
  local rows = self.rows
  for x=0,channels-1 do
    for y=0,rows-1 do
      data.note[rows*x+y]   = nil
      data.text[rows*x+y]   = '...'
      data.vel1[rows*x+y]   = '.'
      data.vel2[rows*x+y]   = '.'      
    end
  end
  
  if ( self.fx.names ) then
    for y=0,rows-1 do
      for x=1,#self.fx.names do
        data.fx1[rows*x+y]   = '.'
        data.fx2[rows*x+y]   = '.'
      end
    end
  end
  
  for y=0,rows do
    self.legato[y] = -1
    data.legato[y] = '.' 
  end
  
  self.data = data
end

function tracker:deleteLegato( row, skipMarker )
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local notes     = self.notes
  local rows      = self.rows

  local idx = self.legato[row]
  if ( idx and idx > -1 ) then
      -- If we delete a legato, check whether there is a note transition next to it, and shorten
      -- that note transition if required.
        
    local npos = rows+row - 1
    local noteOfInterest = noteGrid[npos]
    if ( noteOfInterest and noteStart[npos+1] ) then
      if ( ( noteOfInterest > -1 ) and ( noteStart[npos+1] > -1 ) ) then
        local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteOfInterest] )
        reaper.MIDI_SetNote(self.take, noteOfInterest, nil, nil, nil, endppqpos - tracker.magicOverlap, nil, nil, nil, true)
      end
    end
    if ( not skipMarker ) then
      self:SAFE_DeleteText(self.take, idx)
    end
  end
end

function tracker:setLegato( row, newlegato, skipMarker )
  local legato = self.legato
  if ( ( newlegato == true ) and ( legato[row] == -1 ) ) then
    self:addLegato( row, skipMarker )
  elseif ( ( newlegato == false ) and ( legato[row] > -1 ) ) then
    self:deleteLegato( row, skipMarker )
  end
end

function tracker:addLegato( row, skipMarker )
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local notes     = self.notes
  local rows      = self.rows

  local npos = rows+row-1
  if ( self.legato[row] == -1 ) then
    -- If we add a legato, where there was none, we need to check whether there is a note switch next to it
    -- if so, extend that one.
    local noteOfInterest = noteGrid[npos]
    if ( noteOfInterest and noteStart[npos+1] ) then
      if ( ( noteOfInterest > -1 ) and ( noteStart[npos+1] > -1 ) ) then
        local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteOfInterest] )
        reaper.MIDI_SetNote(self.take, noteOfInterest, nil, nil, nil, endppqpos + tracker.magicOverlap, nil, nil, nil, true)
      end
    end
    
    if ( not skipMarker ) then
      -- Mark it
      local ppq = self:rowToPpq(row)
      self:SAFE_InsertTextSysexEvt(ppq, 1, 'LEG')
    end
  end
end

function tracker:readLegato( ppqpos, i )
  local data    = self.data
  local row     = self:ppqToRow(ppqpos)
  local legato  = self.legato
  data.legato[row] = "1"
  legato[row] = i
end

-----------------------------
-- Merge problematic overlaps
-----------------------------
function tracker:mergeOverlaps()
  -- Grab the notes and store them in channels
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)

  lastpitch = -1;
  
  -- Fetch the notes
  -- We only have potential mergers in channel 1 (the legato channel) and at most one.
  -- Only adjacent notes will be merged.
  local ch1notes = {}
  for i=0,notecntOut do
    local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(self.take, i)
    if ( retval == true ) then
      if ( chan == 1 ) then
        if ( lastpitch == pitch ) then
          if ( startppqpos < lastend ) then
            -- Kill this one
            reaper.MIDI_SetNote(self.take, i-1, nil, nil, nil, endppqpos, nil, nil, nil, true)
            tracker:SAFE_DeleteNote( self.take, i )
          end
        end
        lastpitch = pitch;
        lastend = endppqpos;
      end
    end
  end
end

--function tracker:getParam
--number retval, number minval, number maxval = reaper.TrackFX_GetParam(MediaTrack track, integer fx, integer param)

function tracker:createDefaultEnvelopes()
  local fxcnt = reaper.TrackFX_GetCount(self.track)
  for fidx = 0,fxcnt-1 do
    local pcnt = reaper.TrackFX_GetNumParams(self.track, fidx)
    for pidx = 0,pcnt-1 do
      local retval, name = reaper.TrackFX_GetParamName(self.track, fidx, pidx, '')
      print(name)
      local envelope = reaper.GetFXEnvelope(self.track, fidx, pidx, false)
    end
  end
end

function tracker:findMyAutomation(envelope)
  for i=0,reaper.CountAutomationItems(envelope) do
    local pos = reaper.GetSetAutomationItemInfo(envelope, i, "D_POSITION", 1, false)
    local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", 1, false)    
    if ( self.position == pos ) then
      if ( self.length ~= length ) then
        local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", self.length, true)    
      end
    
      -- Found it!
      return i
    end
  end
  return nil
end

function tracker:deleteEnvPt(fxid, t1, t2)
  local fx      = self.fx
  local envidx  = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  local tend    = t2 or t1 + self:toSeconds(1)
  
  reaper.DeleteEnvelopePointRangeEx(envidx, autoidx, t1, tend - tracker.eps)
end

function tracker:getEnvIdx(fxid, time)
  local fx = self.fx
  local envidx = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  local loc = time or .1
  loc = loc + self.position
  
  local ptidx = reaper.GetEnvelopePointByTimeEx(envidx, autoidx, loc+tracker.enveps)

  -- Are we close enough to consider this our envelope point?
  if ( ptidx ) then
    local retval, atime = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
    if ( math.abs(atime - loc) < 2 * tracker.enveps ) then
      found = 1
      loc = atime
      return ptidx, loc
    end
  end
  return nil, loc
end

function tracker:getEnvPt(fxid, time)
  local fx = self.fx
  local envidx = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  
  ptidx = self:getEnvIdx(fxid, time)
  if ( ptidx ) then
    local retval, atime, value, shape, tension = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
    return atime, value, shape, tension
  end
end

tracker.enveps = 1e-4
---------------------------------
function tracker:addEnvPt(fxid, time, value, shape)
  local fx = self.fx
  local envidx = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]

  if ( not envidx or not autoidx ) then
    print("FATAL: FX channel does not exist?")
    return
  end
  
  local loc = time or .1
  loc = loc + self.position  
  local val = value or 5
  local envShape = shape or 0
  local envTension = nil
    
  ptidx, loc = self:getEnvIdx(fxid, time)
  if ( ptidx ) then
    reaper.SetEnvelopePointEx(envidx, autoidx, ptidx, loc, val, envShape, envTension, false, true)
  else
    reaper.InsertEnvelopePointEx(envidx, autoidx, loc, val, envShape, 0.5, false, true)     
  end
  
  reaper.Envelope_SortPointsEx(envidx, autoidx)
end
---------------------------------

tracker.autoCleanup = 1
function tracker:consolidateAutomation(envelope)
  for i=0,reaper.CountAutomationItems(envelope) do
    local pos = reaper.GetSetAutomationItemInfo(envelope, i, "D_POSITION", 1, false)
    local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", 1, false)  
    
    -- We overlap yes
    if ( ( pos >= self.position ) and ( pos < ( self.position + self.length ) ) ) then
      -- Copy all the events
    
      if ( tracker.autoCleanup ) then
      end
    end   
  end
end

---------------------------------
-- Construct or fetch automation envelopes associated with this pattern
---------------------------------
function tracker:getTakeEnvelopes()

  self.fx = {}
  if ( self.trackFX == 1 ) then
    local autoidxs = {}
    local envelopeidxs = {}
    local names = {}
  
    local cnt = reaper.CountTrackEnvelopes(self.track)
    local autoidx = nil
    for i = 0,cnt-1 do
      local envelope = reaper.GetTrackEnvelope(self.track, i)
      local retval, name = reaper.GetEnvelopeName(envelope, '')
      
      autoidx = self:findMyAutomation( envelope )
      if ( not autoidx ) then
        autoidx = reaper.InsertAutomationItem(envelope, -1, self.position, self.length)
        
        -- Consolidate all automation curves into this one and clean up
      end     
      
      envelopeidxs[#envelopeidxs + 1] = envelope
      autoidxs[#autoidxs + 1] = autoidx
      names[#names + 1] = name
    end
    
    self.fx.envelopeidx = envelopeidxs
    self.fx.autoidx = autoidxs
    self.fx.names   = names
  end 
end

-- Add envelope node
--  self:addEnvPt(2, .23, 1)


function tracker:updateEnvelopes()
  local rows = self.rows
  local data = self.data
  if ( self.fx.names ) then
    for ch=1,#self.fx.names do
      for i=0,rows-1 do
        local atime, value, shape, tension = self:getEnvPt(ch, self:toSeconds(i))
        if ( value ) then
          local hexEnv = string.format('%2X', math.floor(value*255) )
--          data.shape
          data.fx1[rows*ch+i] = hexEnv:sub(1,1)
          data.fx2[rows*ch+i] = hexEnv:sub(2,2)
        end
      end
    end
  end
end

--------------------------------------------------------------
-- Update function
-- heavy-ish, avoid calling too often (only on MIDI changes)
--------------------------------------------------------------
function tracker:update()
  local reaper = reaper
  if ( self.take and self.item ) then 
  
    self:getRowInfo()
    self:getTakeEnvelopes()
    self:linkData()
    self:updatePlotLink()
    self:initializeGrid()
    self:updateEnvelopes()
    
    -- Remove duplicates potentially caused by legato system
    self:clearDeleteLists()
    self:mergeOverlaps()
    self:deleteNow()
    reaper.MIDI_Sort(self.take)
    
    -- Grab the notes and store them in channels
    local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    local i
    if ( retval > 0 ) then
      -- Find the OFF markers and place them first. They could have only come from the tracker sytem
      -- so don't worry too much.
      local offs = {}
      self.txtList = offs
      for i=0,textsyxevtcntOut do
        local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
        if ( typeidx == 1 ) then
          if ( string.sub(msg,1,3) == 'OFF' ) then
            -- If it crashes here, OFF-like events with invalid data were added by something
            local substr = string.sub(msg,4,5)
            local channel = tonumber( substr )
            offs[i] = {ppqpos}
            self:assignOFF(channel, i)
          end
          if ( string.sub(msg,1,3) == 'LEG' ) then
            offs[i] = {ppqpos}
            self:readLegato(ppqpos, i)
          end
        end
      end
    
      -- Fetch the notes
      local channels = {}
      channels[0] = {}
      local notes = {}
      for i=0,notecntOut do
        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(self.take, i)
        if ( retval == true ) then
          if ( not channels[chan] ) then
            channels[chan] = {}
          end
          notes[i] = {pitch, vel, startppqpos, endppqpos}
          channels[chan][#(channels[chan])+1] = i
        end
      end
      self.notes = notes
    
      -- Assign the tracker assigned channels first
      local failures = {}
      for channel=1,self.channels do
        if ( channels[channel] ) then
          for i,note in pairs( channels[channel] ) do
            if ( self:assignFromMIDI(channel,note) == false ) then
              -- Did we fail? Store the note for a second attempt at placement later
              failures[#failures + 1] = note
            end
          end
        end
      end
      
      -- Things in channel zero are new and need to be reassigned!
      for i,note in pairs( channels[0] ) do
        failures[#failures + 1] = note
      end
      
      if ( #failures > 0 ) then
        -- We are going to be changing the data, so add an undo point
        reaper.Undo_OnStateChange2(0, "Tracker: Channel reassignment")
        reaper.MarkProjectDirty(0)
      end
      
      -- Attempt to find a channel for them
      local ok = 0
      local maxChannel = self.channels
      for i,note in pairs(failures) do
        local targetChannel = 1
        local done = false
        while( done == false ) do
          if ( self:assignFromMIDI(targetChannel,note) == true ) then
            reaper.MIDI_SetNote(self.take, note, nil, nil, nil, nil, targetChannel, nil, nil, true)
            done = true
            ok = ok + 1
          else
            --reaper.ShowMessageBox(string msg, string title, integer type)
            print("Warning: A note that should have been assigned was shifted")
            targetChannel = targetChannel + 1
            if ( targetChannel > maxChannel ) then 
              done = true
            end
          end
        end
      end

      -- Failed to place some notes
      if ( ok < #failures ) then
        print( "WARNING: FAILED TO PLACE SOME OF THE NOTES IN THE TRACKER" )
      end
      
      if ( channels[0] ) then
        reaper.MIDI_Sort(self.take)
      end
    end
  end
end

------------------------------
-- Selection management
-----------------------------
function tracker:setItem( item )
  self.item = item
end

function tracker:setTake( take )
  -- Only switch if we're actually changing take
  if ( self.take ~= take ) then
    if ( reaper.TakeIsMIDI( take ) == true ) then
      self.take = take
      self.track = reaper.GetMediaItem_Track(self.item)
      -- Store note hash (second arg = notes only)
      self.hash = reaper.MIDI_GetHash( self.take, false, "?" )
      self:update()
      return true
    end
  end
  return false
end

-- I wish I knew of a cleaner way to do this. This hack tests
-- whether the mediaItem still exists by calling it in a protected call
-- if GetActiveTake fails, the user deleted the mediaItem and we must
-- close the tracker window.
function tracker:testGetTake()
  reaper.GetActiveTake(tracker.item)
end

------------------------------
-- Check for note changes
-----------------------------
function tracker:checkChange()
  local take
  if not pcall( self.testGetTake ) then
    return false
  end
  take = reaper.GetActiveTake(self.item)
  self.track = reaper.GetMediaItem_Track(self.item)
  
  if ( not take ) then
    return false
  end
  if ( reaper.TakeIsMIDI( take ) == true ) then
    if ( tracker:setTake( take ) == false ) then
      -- Take did not change, but did the note data?
      local retval, currentHash = reaper.MIDI_GetHash( self.take, false, "?" )
      if ( retval == true ) then
        if ( ( currentHash ~= self.hash ) or ( self.modified == 1 ) ) then
          self.hash = currentHash
          self:update()
        end
      end
    end
  else
    return false
  end
  
  return true
end

tracker.cp.xstart = -1
tracker.cp.ystart = -1
tracker.cp.xstop = -1
tracker.cp.ystop = -1
tracker.cp.all = 0

function tracker:selectMIDIItems()
  -- MIDI EDITOR
  --40010  Edit: Copy
  --40011  Edit: paste
  --40012  Edit: Cut
  --40214  Edit: unselect all
  
  -- MAIN WINDOW
  -- 40698  Edit -> Copy items
  -- 40699  Edit -> Cut items
  
  -- Deselect all
  reaper.MIDI_SelectAll(self.take, false)
end

-- For later, when we want to share clipboard data between trackers
function serializeTable(val, name, depth)
    depth = depth or 0

    local tmp = string.rep(" ", depth)
    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" 
        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, depth + 1) .. ","
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    end

    return tmp
end

-- A list of the channels is maintained so that we can verify that the paste
-- list is compatible.
function tracker:addChannelToClipboard(clipboard, channel)
  if ( not clipboard.channels ) then
    clipboard.channels = {}
  end
  clipboard.channels[#clipboard.channels + 1] = {}
  clipboard.channels[#clipboard.channels + 1].fieldtype = channel
end

function tracker:addNoteToClipboard(clipboard, note)
  if ( not clipboard.channels[#clipboard.channels].notes ) then
    clipboard.channels[#clipboard.channels].notes = {}
  end
  clipboard.channels[#clipboard.channels].notes[#clipboard.channels[#clipboard.channels].notes+1] = note
end

function tracker:addTxtToClipboard(clipboard, txt)
  if ( not clipboard.channels[#clipboard.channels].notes ) then
    clipboard.channels[#clipboard.channels].txts = {}
  end
  clipboard.channels[#clipboard.channels].txts[#clipboard.channels[#clipboard.channels].txts+1] = txt 
end

-- TO DO clipboard functionality
function tracker:myClippy()
  local newclipboard = {}
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local notes     = self.notes
  local txtList   = self.txtList
  local rows      = self.rows
  
  local chan = idxfields[x]
  local selected = noteStart[ chan*self.rows + y - 1 ]
  local note = notes[selected]
   
  -- All we should be copying is note starts and note stops
  local jx = cp.xstart
  while ( jx < cp.xstop ) do
    self:addChannelToClipboard( newclipboard, datafields[jx] )
    for jy = cp.ystart, cp.ystop do
      if ( ( datafields[jx] == 'text' ) or ( datafields[jx] == 'vel1' ) or ( datafields[jx] == 'vel2' ) ) then
        local chan = idxfields[jx]
        local loc = chan * rows + jy
        if ( noteStart[ loc ] ) then
          -- A note
          self:addNoteToClipboard( newclipboard, jx, fieldtype, notes[ noteStart[loc] ] )
          
        elseif ( noteGrid[ loc ] < -1 ) then
          -- An OFF symbol
          local offidx = self:gridValueToOFFidx( noteGrid[loc] )
          self:addTxtToClipboard( newclipboard, txtList[ offidx ] )
        end
      end
    end
    if ( datafields[jx] == 'text' ) then
      jx = jx + 2
    elseif ( datafields[jx] == 'vel1' ) then
      jx = jx + 1
    end
    jx = jx + 1
  end
  
  clipboard = newclipboard
end

function tracker:beginBlock()
  local cp = self.cp
  if ( cp.ystart == self.ypos ) then
    cp.all = 1 - cp.all
  end
  cp.xstart = self.xpos
  cp.ystart = self.ypos  
  if ( cp.ystart > cp.ystop ) then
    cp.ystop  = self.ypos
  end
  if ( cp.xstart > cp.xstop ) then
    cp.xstop  = self.xpos
  end  
end

function tracker:endBlock()
  local cp = self.cp
  if ( self.ypos < cp.ystart ) then
    self:resetBlock()
  end
  if ( ( cp.ystop == self.ypos ) and ( cp.xstop == self.xpos ) ) then
    cp.all = 1 - cp.all
  end
  cp.xstop = self.xpos  
  cp.ystop = self.ypos
end

function tracker:resetBlock()
  local cp = self.cp
  cp.ystart  = -1
  cp.ystop   = -1
  cp.all     =  0
  cp.xstart  = -1
  cp.xstop   = -1    
end

function tracker:cutBlock()
  self:resetBlock()
end
function tracker:pasteBlock()
  self:resetBlock()
end
function tracker:copyBlock()
  self:resetBlock()
end

local function togglePlayPause()
  local reaper = reaper
  local state = 0
  local HasState = reaper.HasExtState("PlayPauseToggle", "ToggleValue")

  if HasState == 1 then
    state = reaperGetExtState("PlayPauseToggle", "ToggleValue")
  end
    
  if ( state == 0 ) then
    reaper.Main_OnCommand(40044, 0)
  else
    reaper.Main_OnCommand(40073, 0)
  end
end

local function inputs( name )
  -- Bitmask oddly enough doesn't behave as expected
  local control = gfx.mouse_cap & 4
  if ( control > 0 ) then control = 1 end  
  local shift   = gfx.mouse_cap & 8
  if ( shift > 0 ) then shift = 1 end
  local alt     = gfx.mouse_cap & 16
  if ( alt > 0 ) then alt = 1 end

  local checkMask = keys[name]
  if ( checkMask[1] == control ) then
    if ( checkMask[2] == alt ) then
      if ( checkMask[3] == shift ) then
        if ( lastChar == checkMask[4] ) then
          return true
        end
      end
    end
  end
  
  return false
end

function tracker:setOutChannel( ch )
  if not pcall( self.testGetTake ) then
    return false
  end

  if ( self.item ) then
    local retval, str = reaper.GetItemStateChunk( self.item, "zzzzzzzzz")

    if ( not string.find( str, "OUTCH" ) ) then
      local strOut = string.gsub(str, "<SOURCE MIDI", "<SOURCE MIDI\nOUTCH 1")
      reaper.SetItemStateChunk( self.item, strOut )
    end
  end
end

------------------------------
-- Main update loop
-----------------------------
local function updateLoop()
  local tracker = tracker

  if ( tracker.outChannel ) then
    --reaper.GetItemStateChunk ( tracker.item, "OUTCH", false )
    tracker:setOutChannel()
  end

  tracker:clearDeleteLists()
  tracker:clearInsertLists()

  -- Check if the note data or take changed, if so, update the note contents
  if ( not tracker:checkChange() ) then
    gfx.quit()
    return
  end

  -- Maintain the loop until the window is closed or escape is pressed
  lastChar = gfx.getchar()
  
  -- Check if the length changed, if so, update the time data
  if ( tracker:getRowInfo() == true ) then
    tracker:update()
  end  

if ( lastChar ~= 0 ) then
  --print(lastChar)
end
  local modified = 0
  if inputs('left') then
    tracker.xpos = tracker.xpos - 1
  elseif inputs('right') then
    tracker.xpos = tracker.xpos + 1
  elseif inputs('up') then
    tracker.ypos = tracker.ypos - 1
  elseif inputs('down') then
    tracker.ypos = tracker.ypos + 1
  elseif inputs('off') then
    modified = 1
    reaper.Undo_OnStateChange2(0, "Tracker: Place OFF")
    reaper.MarkProjectDirty(0)    
    tracker:placeOff()
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  elseif inputs('delete') then
    modified = 1
    reaper.Undo_OnStateChange2(0, "Tracker: Delete (Del)")
    tracker:delete()
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  elseif inputs('home') then
    tracker.ypos = 0
  elseif inputs('End') then
    tracker.ypos = tracker.rows
  elseif inputs('toggle') then
    togglePlayPause()
  elseif inputs('playfrom') then
    local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
    local loc = reaper.AddProjectMarker(0, 0, tracker:toSeconds(tracker.ypos-1), 0, "", -1)
    reaper.GoToMarker(0, loc, 0)
    reaper.DeleteProjectMarker(0, loc, 0)
    togglePlayPause()
  elseif inputs('insert') then
    modified = 1
    reaper.Undo_OnStateChange2(0, "Tracker: Insert")
    reaper.MarkProjectDirty(0)
    tracker:insert()
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  elseif inputs('remove') then
    modified = 1
    reaper.Undo_OnStateChange2(0, "Tracker: Backspace")
    reaper.MarkProjectDirty(0)  
    tracker:backspace()
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  elseif inputs('pgup') then
    tracker.ypos = tracker.ypos - tracker.page
  elseif inputs('pgdown') then
    tracker.ypos = tracker.ypos + tracker.page  
  elseif inputs('undo') then
    modified = 1
    reaper.Undo_DoUndo2(0) 
  elseif inputs('redo') then
    modified = 1  
    reaper.Undo_DoRedo2(0)  
  elseif inputs('beginBlock') then
    tracker:beginBlock()
  elseif inputs('endBlock') then
    tracker:endBlock()
  elseif inputs('cutBlock') then
    modified = 1  
    tracker:cutBlock()
  elseif inputs('pasteBlock') then
    modified = 1
    tracker:pasteBlock()
  elseif inputs('copyBlock') then
    tracker:copyBlock()  
  elseif inputs('shiftup') then
    modified = 1
    tracker:shiftup()
  elseif inputs('shiftdown') then
    modified = 1
    tracker:shiftdown()
  elseif inputs('octaveup') then
    tracker.transpose = tracker.transpose + 1
  elseif inputs('octavedown') then
    tracker.transpose = tracker.transpose - 1  
  elseif inputs('envshapeup') then
    tracker.envShape = tracker.envShape + 1
    if ( tracker.envShape > #tracker.envShapes ) then
      tracker.envShape = 0
    end
  elseif inputs('envshapedown') then
    tracker.envShape = tracker.envShape - 1
    if ( tracker.envShape < 0 ) then
      tracker.envShape = #tracker.envShapes
    end    
  elseif ( lastChar == 0 ) then
    -- No input
  elseif ( lastChar == -1 ) then      
    -- Closed window
  elseif ( gfx.mouse_cap == 0 ) then
    -- Notes here
    modified = 1
    reaper.Undo_OnStateChange2(0, "Tracker: Add note / Edit volume")
    reaper.MarkProjectDirty(0)  
    tracker:createNote(lastChar)
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  end
  
  tracker:forceCursorInRange()
  tracker:printGrid()
  gfx.update()
  tracker:insertNow()
  
  -- Remove duplicates potentially caused by legato system
  if ( modified == 1 ) then
    tracker:clearDeleteLists()
    tracker:mergeOverlaps()
    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
    tracker.hash = math.random()
  end
  
  if lastChar ~= 27 and lastChar ~= -1 then
    reaper.defer(updateLoop)
  else
    gfx.quit()
  end
end

local function Main()
  local tracker = tracker
  tracker.tick = 0
  tracker:generatePitches()
  tracker:initColors()
  gfx.init("Hackey Trackey v0.8", 450, 385, 0, 200, 200)
  
  local reaper = reaper
  if ( reaper.CountSelectedMediaItems(0) > 0 ) then
    local item = reaper.GetSelectedMediaItem(0, 0)
    local take = reaper.GetActiveTake(item)
    if ( reaper.TakeIsMIDI( take ) == true ) then
      tracker:setItem( item )
      tracker:setTake( take )
      reaper.defer(updateLoop)
    end
  end
end

Main()
