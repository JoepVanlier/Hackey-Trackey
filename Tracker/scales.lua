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
  --HarmMinor     = {2, 1, 2, 2, 1, 3, 1},
  --MelMinor      = {2, 1, 2, 2, 2, 2, 1},
  Dorian        = {2, 1, 2, 2, 2, 1, 2},
  Phrygian      = {1, 2, 2, 2, 1, 2, 2},
  Lydian        = {2, 2, 2, 1, 2, 2, 1},
  Mixolydian    = {2, 2, 1, 2, 2, 1, 2},
--  Locrian    = {1, 2, 2, 1, 2, 2, 2} -- Too esoteric  
}

scales.names = {
  [1] = 'Major',
  [2] = 'Minor',
  [3] = 'Dorian',
  [4] = 'Phrygian',
  [5] = 'Lydian',
  [6] = 'Mixolydian',
  --[7] = 'HarmMinor',
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

  ['MinMaj7th']  = 'mM7',
  ['Min7th']     = 'm7',
  ['Dim7th']     = 'dim7',
  ['HDim7th']    = 'm7b5', -- Half diminished
  ['Min6th']     = 'm6',
  ['Min9th']     = 'm9',
  ['MinAdd9th']  = 'mAdd9',
  ['Min11th']    = 'mAdd11',
  ['Min13th']    = 'mAdd13',
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

-- Chords for heightened interest
  ['Dom7th']     = { {1, 0}, {3, 0}, {5, 0}, {7,-1} },
  ['Maj7th']     = { {1, 0}, {3, 0}, {5, 0}, {7, 0} },
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

  ['MinMaj7th']  = { {1, 0}, {3,-1}, {5, 0}, {7, 0} },
  ['Min7th']     = { {1, 0}, {3,-1}, {5, 0}, {7,-1} },
  ['Dim7th']     = { {1, 0}, {3,-1}, {5,-1}, {7,-2} },
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
  
  return self.noteLUT[root] .. "Unknown"
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
    
    -- Secondary dominant
    -- Get the scale for this one and determine the fifth of that scale
    local domScale = scales:generateScale(i, scale)
    progression[i].notes[3] = { domScale[1+4], domScale[3+4], domScale[5+4], domScale[7+4] }
    progression[i].names[3] = self:identifyChord(progression[i].notes[3], progression[i].notes[3][1])
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
  self.root = root
  
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
  self.picked = {}
  self.picked.name = scales.progressions[scaleName][tone].names[row]
  self.picked.notes = scales.progressions[scaleName][tone].notes[row]
--  print( self.picked.name )
end

function scales.initialize( )
  scales:generateAbsChords()
  scales:setScale(1)
  scales:switchRoot(1)
  
  return scales
end
