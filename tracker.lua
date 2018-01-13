-- A lightweight LUA tracker for REAPER
--
-- Simply highlight a MIDI item and start the script.
-- This will bring up the MIDI item as a tracked sequence
--
-- Work in progress. Input not yet implemented.

tracker = {}
tracker.eps = 1e-3
tracker.fov = {}
tracker.fov.scrollx = 0
tracker.fov.scrolly = 0
tracker.fov.width = 8
tracker.fov.height = 16

tracker.xpos = 1
tracker.ypos = 1
tracker.xint = 0
tracker.page = 4
tracker.channels = 16
tracker.displaychannels = 8
tracker.selectcolor = {.7, 0, .5, 1}
tracker.textcolor = {.7, .8, .8, 1}
tracker.headercolor = {.5, .5, .8, 1}
tracker.linecolor = {.1, .0, .4, .4}
tracker.linecolor2 = {.3, .0, .6, .4}
tracker.linecolor3 = {.4, .1, 1, 1}
tracker.linecolor4 = {.2, .0, 1, .5}
tracker.hash = 0

local function print(...)
  if ( not ... ) then
    reaper.ShowConsoleMsg("nil value\n")
    return
  end
  reaper.ShowConsoleMsg(...)
  reaper.ShowConsoleMsg("\n")
end

------------------------------
-- Pitch => note
------------------------------
function tracker:generatePitches()
  local notes = { 'C-', 'C#', 'D-', 'D#', 'E-', 'F-', 'F#', 'G-', 'G#', 'A-', 'A#', 'B-' }
  local pitches = {}
  j = 0
  for i = 0,10 do
    for k,v in pairs(notes) do
      pitches[j] = v..i
      j = j + 1
    end
  end
  self.pitchTable = pitches
end

------------------------------
-- Link GUI grid to data
------------------------------
function tracker:linkData()
  -- Here is where the linkage between the display and the actual data fields in "tracker" is made
  -- TO DO: This probably doesn't need to be done upon scrolling.
  local colsizes = {}
  local datafield = {}
  local idx = {}
  local padsizes = {}  
  local headers = {}
  for j = 1,self.displaychannels do
    -- Link up the note fields
    datafield[#datafield+1] = 'text'
    idx[#idx+1] = j-1
    colsizes[#colsizes + 1] = 3
    padsizes[#padsizes + 1] = 1
    headers[#headers + 1] = string.format(' Ch%2d', j)
    
    -- Link up the velocity fields
    datafield[#datafield+1] = 'vel'
    idx[#idx+1] = j-1
    colsizes[#colsizes + 1] = 2
    padsizes[#padsizes + 1] = 2   
    headers[#headers + 1] = ''     
  end
  local link = {}
  link.datafields = datafield
  link.headers    = headers
  link.padsizes   = padsizes
  link.colsizes   = colsizes
  link.idxfields  = idx
  self.link = link
end

function tracker:grabLinkage()
  local link = self.link
  return link.datafields, link.padsizes, link.colsizes, link.idxfields, link.headers
end

------------------------------
-- Establish what is plotted
------------------------------
function tracker:updatePlotLink()
  local plotData = {}
  local originx = 40
  local originy = 40
  local dx = 8
  local dy = 20
  plotData.barpad = 10
  plotData.itempadx = 5
  plotData.itempady = 3
  -- How far are the row indicators from the notes?
  plotData.indicatorShiftX = 3 * dx + 2 * plotData.itempadx
  plotData.indicatorShiftY = dy + plotData.itempady

  self.extracols = {}
  self.max_xpos = 2 * self.displaychannels + #self.extracols
  self.max_ypos = self.rows

  local datafields, padsizes, colsizes, idxfields, headers = self:grabLinkage()
  
  -- Generate x locations for the columns
  local fov = self.fov
  local xloc = {}
  local xwidth = {}
  local xlink = {}
  local dlink = {}
  local header = {}
  local x = originx
  for j = fov.scrollx+1,math.min(#colsizes,fov.width+fov.scrollx) do
    xloc[#xloc + 1] = x
    xwidth[#xwidth + 1] = colsizes[j] * dx + padsizes[j]
    xlink[#xlink + 1] = idxfields[j]
    dlink[#dlink + 1] = datafields[j]
    header[#header + 1] = headers[j]
    x = x + colsizes[j] * dx + padsizes[j] * dx
  end
  plotData.xloc = xloc
  plotData.xwidth = xwidth
  plotData.totalwidth = x - padsizes[#padsizes] * dx - colsizes[#colsizes]*dx
  plotData.xstart = originx
  -- Variable dlink indicates what field the data can be found
  -- Variable xlink indicates the index that is being displayed
  plotData.dlink = dlink
  plotData.xlink = xlink
  plotData.headers = header
  
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
  
  if ( cpos < loc ) then
    cpos = loc;
  end
  if ( cpos > loc2 ) then
    cpos = loc2;
  end
  return ( cpos - loc ) * self.rowPerSec / self.rows
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

------------------------------
-- Draw the GUI
------------------------------
function tracker:printGrid()
  local tracker   = tracker
  local gfx       = gfx
  local channels  = self.displaychannels
  local rows      = self.rows
  local text      = self.text
  local vel       = self.vel
  local fov       = self.fov
  
  local plotData  = self.plotData
  local xloc      = plotData.xloc
  local xwidth    = plotData.xwidth
  local yloc      = plotData.yloc
  local yheight   = plotData.yheight
  
  local relx = tracker.xpos-fov.scrollx
  local rely = tracker.ypos-fov.scrolly
  gfx.set(table.unpack(self.selectcolor))
  gfx.rect(xloc[relx], yloc[rely]-plotData.yshift, xwidth[relx], yheight[rely])
  
  local dlink     = plotData.dlink
  local xlink     = plotData.xlink
  local headers   = plotData.headers
  local tw        = plotData.totalwidth
  local itempadx  = plotData.itempadx
  local itempady  = plotData.itempady
  local scrolly   = fov.scrolly
  
  -- Render in relative FOV coordinates
  for y=1,#yloc do
    gfx.y = yloc[y]
    gfx.x = xloc[1] - plotData.indicatorShiftX
    local absy = y + scrolly
    gfx.set(table.unpack(self.headercolor))    
    gfx.printf("%3d", absy)
    if ( (((absy-1)/4) - math.floor((absy-1)/4)) == 0 ) then
      gfx.set(table.unpack(tracker.linecolor2))
    else
      gfx.set(table.unpack(tracker.linecolor))
    end
    gfx.rect(xloc[1] - itempadx, yloc[y] - plotData.yshift, tw, yheight[1] + itempady)
    for x=1,#xloc do
      gfx.x = xloc[x]
      gfx.set(table.unpack(tracker.textcolor))
      gfx.printf("%s", self[dlink[x]][rows*xlink[x]+absy-1])
    end
  end
  
  -- Draw the headers so we don't get lost :)
  gfx.set(table.unpack(self.headercolor))
  gfx.y = yloc[1] - plotData.indicatorShiftY

  for x=1,#xloc do
    gfx.x = xloc[x]
    gfx.printf("%s", headers[x])
  end
  
  gfx.set(table.unpack(tracker.linecolor3))
  gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * self:getPlayLocation() - itempady, tw, 1)
  gfx.set(table.unpack(tracker.linecolor4))
  gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * self:getCursorLocation() - itempady, tw, 1)
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
    self.xpos = self.max_xpos
  end
  if ( self.ypos > self.max_ypos ) then
    self.ypos = self.max_ypos
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

------------------------------
-- Determine timing info
-- returns true if something changed
------------------------------
function tracker:getRowInfo()
    -- How many rows do we need?
    local ppqPerQn = reaper.MIDI_GetPPQPosFromProjQN(self.take, 1)
    local ppqPerSec = 1.0 / reaper.MIDI_GetProjTimeFromPPQPos(self.take, 1)
    local mediaLength = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    
    self.qnCount = mediaLength * ppqPerSec / ppqPerQn
    self.rowPerQn = 4
    local rows = self.rowPerQn * self.qnCount
    
    -- Do not allow zero rows in the tracker!
    if ( rows < self.eps ) then
      reaper.SetMediaItemInfo_Value(self.item, "D_LENGTH", 1 / ( self.rowPerQn / ppqPerQn * ppqPerSec ) )
      rows = 1
    end
    
    if ( ( self.rows ~= rows ) or ( self.ppqPerQn ~= ppqPerQn ) ) then
      self.rows = rows
      self.qnPerPpq = 1 / ppqPerQn
      self.rowPerPpq = self.rowPerQn / ppqPerQn
      self.rowPerSec = ppqPerSec * self.rowPerQn / ppqPerQn
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
function tracker:isFree(channel, y1, y2)
  local rows = self.rows
  local notes = self.note
  for y=y1,y2 do
    -- Occupied
    if ( notes[rows*channel+y] ) then
      return false
    end
  end
  return true
end

-- Assign a note that is already in the MIDI data
function tracker:assignFromMIDI(channel, idx)
  local pitchTable = self.pitchTable
  local rows = self.rows
  
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[idx] ) 
  local ystart = math.floor( startppqpos * self.rowPerPpq + self.eps )
  local yend = math.ceil( endppqpos * self.rowPerPpq - self.eps )
  
  -- This note is not actually present
  if ( ystart > self.rows-1 ) then
    return true
  end
  
  -- Is the space for the note free on this channel?
  if ( self:isFree( channel, ystart, yend ) ) then
    self.text[rows*channel+ystart] = pitchTable[pitch]
    self.vel[rows*channel+ystart]  = string.format('%2d', vel )  
    for y = ystart,yend,1 do      
      self.note[rows*channel+y] = idx      
    end
    --print("NOTE "..self.pitchTable[pitch] .. " on channel " .. channel .. " from " .. ystart .. " to " .. yend)    
    return true
  else
    return false
  end  
end

------------------------------
-- Internal data initialisation
-----------------------------
function tracker:initializeGrid()
  local x, y
  self.note = {}
  self.text = {}
  self.vel = {}
  local channels = self.channels
  local rows = self.rows
  for x=0,channels-1 do
    for y=0,rows-1 do
      self.note[rows*x+y] = nil
      self.text[rows*x+y] = '...'
      self.vel[rows*x+y] = '..'
    end
  end
end

------------------------------
-- Update function
-- heavy-ish, avoid calling too often
-----------------------------
function tracker:update()
  local reaper = reaper
  if ( self.take and self.item ) then
    self:getRowInfo()
    self:linkData()
    self:updatePlotLink()
    self:initializeGrid()
    
    -- Grab the notes and store them in channels
    local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    if ( retval > 0 ) then
      local channels = {}
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
    
      -- Go through the channels in reverse order (this way tracker assigned notes are typically first)
      local failures = {}
      for channel=#channels,0,-1 do
        for i,note in pairs( channels[channel] ) do
          if ( self:assignFromMIDI(channel,note) == false ) then
            -- Did we fail? Store the note for a second attempt at placement later
            failures[#failures + 1] = note
          end
        end
      end
      
      -- Attempt to find a channel for them
      local ok = 0
      local maxChannel = self.channels
      for i,note in pairs(failures) do
        local targetChannel = 0
        local done = false
        while( ( targetChannel < maxChannel ) and ( done == false ) ) do
          if ( self:assignFromMIDI(targetChannel,note) == true ) then
            done = true
            ok = ok + 1
          else
            targetChannel = targetChannel + 1
          end
        end
      end

      -- Failed to place some notes
      if ( ok < #failures ) then
        print( "WARNING: FAILED TO PLACE SOME OF THE NOTES IN THE TRACKER" )
      end
      
    end
  end
  local pitchSymbol = self.pitchTable[pitchOut]
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
      -- Store note hash (second arg = notes only)
      self.hash = reaper.MIDI_GetHash( self.take, true, "?" )
      self:update()
      return true
    end
  end
  return false
end

------------------------------
-- Check for note changes
-----------------------------
function tracker:checkChange()
  local take = reaper.GetActiveTake(self.item)
  if ( reaper.TakeIsMIDI( take ) == true ) then
    if ( tracker:setTake( take ) == false ) then
      -- Take did not change, but did the note data?
      local retval, currentHash = reaper.MIDI_GetHash( self.take, true, "?" )
      if ( retval == true ) then
        if ( currentHash ~= self.hash ) then
          self.hash = currentHash
          self:update()
        end
      end
    end
  end
end

------------------------------
-- Main update loop
-----------------------------
local function updateLoop()
  local tracker = tracker

  -- Maintain the loop until the window is closed or escape is pressed
  local char = gfx.getchar()
  
  -- Check if the length changed, if so, update the time data
  if ( tracker:getRowInfo() == true ) then
    tracker:update()
  end
  
  -- Check if the note data or take changed, if so, update the note contents
  tracker:checkChange()

--[[-- 
if ( char ~= 0 ) then
  print(char)
end
--]]--
 
  if char == 1818584692 then
    tracker.xpos = tracker.xpos - 1
  elseif char == 1919379572 then
    tracker.xpos = tracker.xpos + 1
  elseif char == 30064 then
    tracker.ypos = tracker.ypos - 1
  elseif char == 1685026670 then
    tracker.ypos = tracker.ypos + 1
  elseif char == 6579564 then 
    -- Delete
  elseif char == 1752132965 then
    -- Home
  elseif char == 6647396 then
    -- End
  elseif char == 32 then
    -- Space
  elseif char == 6909555 then
    -- Insert
  elseif char == 8 then
    -- Backspace    
  elseif char == 1885828464 then
    -- Pg Up
    tracker.ypos = tracker.ypos - tracker.page
  elseif char == 1885824110 then
    -- Pg Down
    tracker.ypos = tracker.ypos + tracker.page    
  end
  
  tracker:forceCursorInRange()
  tracker:printGrid()
  gfx.update()
   
  if char ~= 27 and char ~= -1 then
    reaper.defer(updateLoop)
  else
    gfx.quit()
  end
end

local function Main()
  local tracker = tracker
  tracker.tick = 0
  tracker:generatePitches()
  gfx.init("Hackey Trackey v0.1", 640, 480, 0, 200, 200)
  
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
