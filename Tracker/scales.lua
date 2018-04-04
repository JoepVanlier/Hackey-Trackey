--[[
@noindex
]]--

-- These are scale/chord aware helper functions for the chord toolbar in Hackey Trackey

-- Scales
scales = {}

local function print(...)
  if ( not ... ) then
    reaper.ShowConsoleMsg("nil value\n")
    return
  end
  reaper.ShowConsoleMsg(...)
  reaper.ShowConsoleMsg("\n")
end

scales.intervals = {
  Major         = {2, 2, 1, 2, 2, 2, 1}, -- Ionian
  Minor         = {2, 1, 2, 2, 1, 2, 2}, -- Aeolian
  HarmMinor     = {2, 1, 2, 2, 1, 3, 1},
  --MelMinor      = {2, 1, 2, 2, 2, 2, 1},
  Dorian        = {2, 1, 2, 2, 2, 1, 2},
  Phrygian      = {1, 2, 2, 2, 1, 2, 2},
  Lydian        = {2, 2, 2, 1, 2, 2, 1},
  Mixolydian    = {2, 2, 1, 2, 2, 1, 2},
--  Locrian    = {1, 2, 2, 1, 2, 2, 2} -- Too esoteric  
}

-- Scales for which to include 11th and 13th chords
scales.inc13th = { ['Major']=1, ['Minor']=1, ['HarmMinor']=1 }

scales.names = {
  [1] = 'Major',
  [2] = 'Minor',
  [3] = 'HarmMinor',  
  [4] = 'Dorian',
  [5] = 'Phrygian',
  [6] = 'Lydian',
  [7] = 'Mixolydian',
  --[8] = 'MelMinor'
}

local min7b5    = 'HDim7th'
--prog = {}
--prog.Major      = { {'Maj', 'Maj7th'},   {'Min', 'Min7th'},  {'Min', 'Min7th'}, {'Maj', 'Maj7th'}, {'Maj', 'Dom7th'},   {'Min', 'Min7th'},    {'Dim', min7b5} }
--prog.Minor      = { {'Min', 'Min7th'},   {'Dim', min7b5},    {'Maj', 'Maj7th'}, {'Min', 'Min7th'}, {'Min', 'Min7th'},   {'Maj', 'Maj7th'},    {'Maj', 'Dom7th'} }
--prog.HarmMinor  = { {'Min', 'Maj7th'},   {'Dim', min7b5},    {'Aug7th5'},       {'Min', 'Min7th'}, {'Maj', 'Dom7th'},   {'Maj', 'Maj7th'},    {'Dim', 'Dim7th'} }
--prog.MelMinor   = { {'Min', 'Maj7th'},   {'Min', 'Min7th'},  {'Aug7th5'},       {'Maj', 'Dom7th'}, {'Maj', 'Dom7th'},   {'Dim', min7b5},      {'Dim', min7b5} }

-- Structure
scales.chordTree = { 
  ['Major'] = {
    ['Major'] = {
      { 'Maj',    '' },
    },
    ['7th'] = {
      { 'Maj7th',   'Maj7' },
      { 'Aug7th5',  'Aug7th5' },      
      { '7th9',     '7th9' },    
      { '7th11',    '7th11' },
      { 'Maj7th11', 'Maj7th11' },    
    },
    ['Aug'] = {
      { 'Aug',      'aug' },
    },
    ['9th'] = {
      { '9th',      '9th' },
      { 'Maj9th',   'Maj9th' },
      { 'Add9th',   'Add9th' },            
    },
    ['6th'] = {
      { 'Dom6th',   'Dom6th' },
    },
    ['11th'] = {
      { '11th',     '11th' },
    },
    ['13th'] = {
      { '13th',     '13th' },
      { 'Maj13th',  'Maj13th' },
    },
  },
  ['Minor'] = {
      ['Min'] = {
        { 'Min',      'm' },
      },  
      ['Dim'] = {
        { 'Dim',      'dim' },
      },
      ['7th'] = {
        { 'Min7th',   'm7' },
        { 'Dim7th',   'dim7' },
        { 'HDim7th',  'HDim7' },
      },
      ['6th'] = {
        { 'Min6th',   'm6' },
      },
      ['9th'] = {
        { 'Min9th',   'm9' },
        { 'MinAdd9th','mAdd9' },
      },
      ['11th'] = {
        { 'Min11th',  'm11' },
      },
      ['13th'] = {
        { 'Min13th',  'm13' },
      },
  },
  ['5th'] = {
      ['5th'] = {
        { '5th',      '5th' },
      },
  },
  ['Sus4'] = {
      ['Sus4'] = {
        { 'Sus4',     'Sus4' },
      },
  },
  ['Sus2'] = {
      ['Sus2'] = {
        { 'Sus2',     'Sus2' },
      },
  },
}

scales.chordDisplay = {
  ['Maj']        = '',
  ['Min']        = 'm',
  ['Dim']        = 'dim',
  ['Aug']        = 'aug',
  ['Sus4']       = 'sus4',
  ['Sus2']       = 'sus2',
  ['5th']        = '-5',

-- Chords for heightened interest
  ['Dom7th']     = '7',
  ['Maj7th']     = 'M7',
  ['Aug7th']     = 'aug7',
  ['Aug7th5']    = 'aug7b5', -- ??
  ['7th9']       = '7#9', --Hendrix chord
  ['7th11']      = '7#11',
  ['Maj7th11']   = 'M7-11',
  ['9th']        = '9',
  ['Maj9th']     = 'M9',
  ['Add9th']     = 'add9',
  ['Dom6th']     = '6',
  ['11th']       = '11',
  ['13th']       = '13',
  ['Maj13th']    = 'M13',

  ['MinMaj7th']     = 'mM7',
  ['MinMaj7thAdd9'] = 'mM7+9',  
  ['Min7th']        = 'm7',
  ['Dim7th']        = 'dim7',
  ['Dim9th']        = 'dim7add9',  
  ['HDim7th']       = 'm7b5', -- Half diminished
  ['Min6th']        = 'm6',
  ['Min9th']        = 'm9',
  ['MinAdd9th']     = 'mAdd9',
  ['Min11th']       = 'mAdd11',
  ['Min13th']       = 'mAdd13',
  ['Dim7thAdd9']    = 'dim7add9',
  
  ['M7Sus4']        = 'sus4?',
  ['7Sus4']         = '7sus4',
  ['dim7Sus4']      = 'd7s4',  
}

-- Basic chords expressed relative to a major scale.
-- Root note of the major scale for comparison has to be 1
scales.chords = {
  ['Maj']        = { {1, 0}, {3, 0}, {5, 0} },
  ['Min']        = { {1, 0}, {3,-1}, {5, 0} },
  ['Dim']        = { {1, 0}, {3,-1}, {5,-1} },
  ['Aug']        = { {1, 0}, {3, 0}, {5, 1} },
  ['Sus4']       = { {1, 0}, {4, 0}, {5, 0} },
  ['Sus2']       = { {1, 0}, {2, 0}, {5, 0} },
  ['5th']        = { {1, 0}, {5, 0} },

--  ['Sus4M7']       = { {1, 0}, {4, 0}, {5, 0}, {7, 0}, {9, 1} },
--  ['Sus4M7add9']       = { {1, 0}, {4, 0}, {5, 0}, {7, 0}, {9, 1} },

-- Suspended chord
  ['M7Sus4']       = { {1, 0}, {4, 0}, {5, 0}, {7, 0} },
  ['7Sus4']      = { {1, 0}, {4, 0}, {5, 0}, {7, -1} },
  ['dim7Sus4']      = { {1, 0}, {4, 0}, {5, -1}, {7, -1} },  

-- Chords for heightened interest
  ['Dom7th']     = { {1, 0}, {3, 0}, {5, 0}, {7,-1} },
  ['Maj7th']     = { {1, 0}, {3, 0}, {5, 0}, {7, 0} },
  ['Aug7th']     = { {1, 0}, {3, 0}, {5, 1}, {7, 0} },  
  ['Aug7th5']    = { {1, 0}, {3, 0}, {5, 1}, {7,-1} },
  ['7th9']       = { {1, 0}, {3, 0}, {5, 0}, {7,-1}, {9, 1} }, --Hendrix chord
  ['7th11']      = { {1, 0}, {3, 0}, {5, 0}, {7,-1}, {11, 1} },
  ['Maj7th11']   = { {1, 0}, {3, 0}, {5, 0}, {7, 0}, {9, 0}, {11, 1} },
  ['9th']        = { {1, 0}, {3, 0}, {5, 0}, {7,-1}, {9, 0} },
  ['Maj9th']     = { {1, 0}, {3, 0}, {5, 0}, {7, 0}, {9, 0} },
  ['Add9th']     = { {1, 0}, {3, 0}, {5, 0}, {9, 0} },
  ['Dom6th']     = { {1, 0}, {3, 0}, {5, 0}, {6, 0} },
  ['11th']       = { {1, 0}, {5, 0}, {7,-1}, {9, 0}, {11, 0} },
  ['13th']       = { {1, 0}, {3, 0}, {5, 0}, {7,-1}, {9, 0}, {13, 0} },
  ['Maj13th']    = { {1, 0}, {3, 0}, {5, 0}, {7, 0}, {9, 0}, {13, 0} },

  ['Dim9th']     = { {1, 0}, {3, -1}, {5, -1}, {7,-1}, {9, 0} },

  -- Relevant for harmonic minor
  ['MinMaj7th']  = { {1, 0}, {3,-1}, {5, 0}, {7, 0} },
  
   ['MinMaj7thAdd9'] = { {1, 0}, {3,-1}, {5, 0}, {7, 0}, {9, 0} },
  ['Min7th']     = { {1, 0}, {3,-1}, {5, 0}, {7,-1} },
  ['Dim7th']     = { {1, 0}, {3,-1}, {5,-1}, {7,-2} },
  ['Dim7thAdd9'] = { {1, 0}, {3,-1}, {5,-1}, {7,-2}, {9, 0} },  
  ['HDim7th']    = { {1, 0}, {3,-1}, {5,-1}, {7,-1} },
  ['Min6th']     = { {1, 0}, {3,-1}, {5, 0}, {6, 0} },
  ['Min9th']     = { {1, 0}, {3,-1}, {5, 0}, {7,-1}, {9, 0} },
  ['MinAdd9th']  = { {1, 0}, {3,-1}, {5, 0}, {9, 0} },
  ['Min11th']    = { {1, 0}, {3,-1}, {5, 0}, {7,-1}, {9, 0}, {11, 0} },
  ['Min13th']    = { {1, 0}, {3,-1}, {5, 0}, {7,-1}, {9, 0}, {11, 0}, {13, 0} },
}

-- Compute chords that we can use for easy comparison
-- We convert the chords that were expressed w.r.t. the major scale
-- into an absolute semitone scale. Note that 1 has to be the root
-- of the chord when comparing with these chords.
-- Also note that it does not recognize inversions.
function scales:absChords( )
  local chords = self.chords
  local absChords = {}
  
  -- Convert chords relative to major scale to absolute pitches
  -- 1 2 3 4 5 6 7 8 9 10 11 12
  -- 1   2   3 4   5    6     7
  local LUT = {}
  LUT[1] = 1
  LUT[2] = 3
  LUT[3] = 5
  LUT[4] = 6
  LUT[5] = 8
  LUT[6] = 10
  LUT[7] = 12 
  
  for i,v in pairs( chords ) do
    local nNotes = 0
    local curAbsChord = {}
    for j,w in pairs( v ) do
      curAbsChord[j] = LUT[chords[i][j][1]] + chords[i][j][2]
      nNotes = nNotes + 1
    end
    absChords[nNotes][#absChords[nNotes] + 1] = curAbsChord
  end
    
  self.absChords = absChords
end

scales.noteLUT = {
  [1] = 'C',
  [2] = 'C#',
  [3] = 'D',
  [4] = 'D#',
  [5] = 'E',
  [6] = 'F',
  [7] = 'F#',
  [8] = 'G',
  [9] = 'G#',
  [10] = 'A',
  [11] = 'A#',
  [12] = 'B',
  [13] = 'C',
  [14] = 'C#',
  [15] = 'D',
  [16] = 'D#',
  [17] = 'E',
  [18] = 'F',
  [19] = 'F#',
  [20] = 'G',
  [21] = 'G#',
  [22] = 'A',
  [23] = 'A#',
  [24] = 'B',
  [25] = 'C',
  [26] = 'C#',
  [27] = 'D',
  [28] = 'D#',
  [29] = 'E',
  [30] = 'F',
  [31] = 'F#',
  [32] = 'G',
  [33] = 'G#',
  
  
  ['C']  = 1,
  ['C#'] = 2,
  ['D']  = 3,
  ['D#'] = 4,
  ['E']  = 5,
  ['F']  = 6,
  ['F#'] = 7,
  ['G']  = 8,
  ['G#'] = 9,
  ['A']  = 10,
  ['A#'] = 11,
  ['B']  = 12,
}

function scales:generateChord(root, chordtype)
  local rootval   = notes[root or 0]
  local chord     = chords[chordtype]
  local LUT       = noteLUT.notes
  local pitches   = {}
  local notes     = {}
  for i = 1,#chord do
    local cPitch = fullscale[chord[i][1]]+chord[i][2]
    pitches[#pitches+1] = cPitch
    notes[#notes+1] = LUT[cPitch]
  end
  
  return notes, pitches
end

-- Needs sorted pitches
-- Give a few absolute pitches and the pitch of their root in absolute pitch (not relative to scale)
-- in order to identify the chord
function scales:identifyChord(pitches, root)
  local shifted = {}
  local chords = self.absChords
  local noteCount = #pitches  
  for i=1,noteCount do
    shifted[i] = pitches[i] - root + 1
  end
    
  -- Identify the chord
  for i,v in pairs(chords[noteCount]) do
    local isMatch = 1
    for j=1,noteCount do
      if ( v[j] ~= shifted[j] ) then
        isMatch = 0
      end
    end
    if ( isMatch == 1 ) then
      return self.noteLUT[root] .. scales.chordDisplay[i]
    end
  end
  --print("Failed match for ")
  --for i,v in pairs( shifted ) do
  --  print(v)
  --end

  return nil
end

function scales:generateScale(root, selectScale)
  local scale = {}
  local allowedNotes = {}
  local rootNote = root or 1

  -- Make a list of allowed notes
  local curScale = self.intervals[selectScale]
  for i=0,3 do
    local c = rootNote
    for j = 1,#curScale do
      scale[#scale+1] = 12*i+c
      allowedNotes[12*i+c] = 1
      c = c + curScale[j]
    end
  end
  
  return scale, allowedNotes
end

function scales:generateAbsChords( )
  local chords = self.chords
  local absChords = {}

  -- Convert chords relative to major scale to absolute pitches
  -- 1 2 3 4 5 6 7 8 9 10 11 12
  -- 1   2   3 4   5    6     7
  local LUT = {
    [1]  = 1,
    [2]  = 3,
    [3]  = 5,
    [4]  = 6,
    [5]  = 8,
    [6]  = 10,
    [7]  = 12,
    [8]  = 13,
    [9]  = 15,
    [10] = 17,
    [11] = 18,
    [12] = 20,
    [13] = 22,
    [14] = 24,
    [15] = 25,    
  }
  
  for i,v in pairs( chords ) do
    local nNotes = 0
    local curAbsChord = {}
    for j,w in pairs( v ) do
      curAbsChord[j] = LUT[w[1]] + w[2]
      nNotes = nNotes + 1
    end
    if ( not absChords[nNotes] ) then
      absChords[nNotes] = {}
    end
    absChords[nNotes][i] = curAbsChord
  end
    
  self.absChords = absChords
end

function scales:generateProgression( root, scale )
  local intervals  = scales.intervals
  local scaleNotes = scales.scales[scale]
  local progression = {}
  
  for i=1,7 do
    local base = i-1
    progression[i] = {}
    progression[i].notes = {}
    progression[i].names = {}
    progression[i].notes[1] = { scaleNotes[1+base], scaleNotes[3+base], scaleNotes[5+base] } --, scaleNotes[7+base
    progression[i].names[1] = self:identifyChord(progression[i].notes[1], progression[i].notes[1][1])
    progression[i].notes[2] = { scaleNotes[1+base], scaleNotes[3+base], scaleNotes[5+base], scaleNotes[7+base] } --, scaleNotes[7+base
    progression[i].names[2] = self:identifyChord(progression[i].notes[2], progression[i].notes[2][1])

    -- More specialized chords
    local n = 2      
    -- Add 11th and 13th chords for special ones
    if ( scales.inc13th[scale] ) then
      n = n + 1
      -- Suspended chords
      progression[i].notes[n] = { scaleNotes[1+base], scaleNotes[1+base] + 5, scaleNotes[5+base], scaleNotes[1+base]+10 }
      progression[i].names[n] = self:identifyChord(progression[i].notes[n], progression[i].notes[n][1])    

      -- add9
      n = n + 1
      progression[i].notes[n] = { scaleNotes[1+base], scaleNotes[3+base], scaleNotes[5+base], scaleNotes[7+base], scaleNotes[9+base] }
      progression[i].names[n] = self:identifyChord(progression[i].notes[n], progression[i].notes[n][1])        
    end
    
    n = n + 1
    -- Secondary dominant
    -- Get the scale for this one and determine the fifth of that scale
    local domScale = scales:generateScale(scaleNotes[1+base], scale)
    local shift = 4

    progression[i].notes[n] = { domScale[1+shift], domScale[3+shift], domScale[5+shift], domScale[7+shift] }
    progression[i].names[n] = self:identifyChord(progression[i].notes[n], progression[i].notes[n][1])    
  end
  
  return progression
end

function scales:getRootValue()
  return self.root
end

function scales:getRoot()
  return self.noteLUT[self.root]
end

function scales:getScaleValue()
  return self.curScale
end

function scales:getScale()
  return self.names[self.curScale]
end

function scales:getNote(note)
  return self.noteLUT[note]
end

function scales:scaleNotes()
  local curSc = self.scales[self.names[self.curScale]]
  local notes = ''
  for a = 1,7 do
    notes = notes .. self.noteLUT[curSc[a]] 
    if ( a < 7 ) then
      notes = notes .. ","
    end
  end
  return notes
end

function scales:getScaleNote(note)
  return self.noteLUT[self.scales[self.names[self.curScale]][note]]
end

function scales:pitchToNote(pitch)
  if ( self.noteLUT[pitch] ) then
    return self.noteLUT[pitch]
  else
    return "err"
  end
end

function scales:setScale(curscale)
  if ( not curscale ) then
    return
  end
  if ( curscale > #self.names ) then
    self.curScale = #self.names
  elseif ( curscale < 1 ) then
    self.curScale = 1
  else
    self.curScale = curscale
  end
end

function scales:switchRoot( root )
  self.root = self:wrapPitch(root-1)+1
  
  scales.scales = {}
  for i,v in pairs( scales.intervals ) do
    scales.scales[i] = scales:generateScale(self.root, i)
  end

  scales.progressions = {}
  for i,v in pairs( scales.intervals ) do
    scales.progressions[i] = scales:generateProgression(self.root, i)
  end
end

function scales:pickChord( scaleName, tone, row )
  if ( not self.picked ) then
    self.picked = {}
  end
  local oldName = self.picked.name
  local notes = scales.progressions[scaleName][tone].notes[row]
  self.picked.name = scales.progressions[scaleName][tone].names[row]
  self.picked.notes = {}
  if ( notes ) then
    for i = 1,8 do
      if ( notes[i] ) then
        self.picked.notes[i] = notes[i]
      end
    end
  end
  
  -- This chord slot is blank
  if ( not self.picked.name ) then
    return nil
  end
  
  local change = 0
  if ( self.picked.name ~= oldName ) then
    change = 1
  end

  return notes, change
end

function scales:wrapPitch(pitch)
  return pitch-12*math.floor(pitch/12)
end

function scales:shiftPitch(pitch, shift)
  local wPitch = scales:wrapPitch(pitch + 1)
  wPitch = wPitch + 12
  local base = pitch - wPitch

  local i = 0
  local sharp = 0
  while( i < 24 ) do
    i = i + 1
    local D = self.scales[self.names[self.curScale]][i] - wPitch
    
    -- We found the pitch exactly
    if ( self.scales[self.names[self.curScale]][i] == wPitch ) then
      break
    elseif ( D > 0 ) then
      -- Too high? Must be an accidental. Note that these will be lost over time since they have a tendency
      -- to snap to the scale with this approach
      sharp = 1
      i = i - 1
      break
    end
  end
  
  local newLoc = i+shift
  if ( newLoc < 1 ) then
    return self.scales[self.names[self.curScale]][newLoc+7] + base + sharp - 12
  else
    return self.scales[self.names[self.curScale]][newLoc] + base + sharp
  end
end

function scales:shiftRoot(pitch, shift)
  local wPitch = scales:wrapPitch(pitch+1)
  wPitch = wPitch+12
  local base = pitch - wPitch

  local i = 0
  local sharp = 0
  while( i < 24 ) do
    i = i + 1
    local D = self.scales[self.names[self.curScale]][i] - wPitch
    
    -- We found the pitch exactly
    if ( self.scales[self.names[self.curScale]][i] == wPitch ) then
      break
    elseif ( D > 0 ) then
      -- Too high? Must be an accidental. Note that these will be lost over time since they have a tendency
      -- to snap to the scale with this approach
      sharp = 1
      i = i - 1
      break
    end
  end

  local newScale = scales:generateScale(self.root+shift, scales.names[self.curScale])
  if ( i < 1 ) then
    return newScale[i+7] + base + sharp - 12
  else
    return newScale[i] + base + sharp
  end
end

function scales:similarityScore( notes )
  local nonSimilarity=10
  if ( self.picked ) then
    local lnotes = self.picked.notes
    for i=1,#notes do
      for j=1,#lnotes do
        if ( notes[i] and lnotes[j] ) then
          local dist = math.abs( self:wrapPitch(notes[i]) - self:wrapPitch(lnotes[j]) )
          if dist < nonSimilarity then
            nonSimilarity = dist
          end
        end
      end
    end
  else 
    return 1
  end
  
  return nonSimilarity
end

function scales.initialize( )
  scales:generateAbsChords()
  scales:setScale(1)
  scales:switchRoot(1)
  
  return scales
end
