--[[
@description Hackey-Trackey: A tracker interface similar to Jeskola Buzz for MIDI and FX editing.
@author: Joep Vanlier
@provides
  scales.lua
  [main] .
@links
  https://github.com/joepvanlier/Hackey-Trackey
@license MIT
@version 1.44
@screenshot https://i.imgur.com/c68YjMd.png
@about 
  ### Hackey-Trackey
  #### What is it?
  A lightweight tracker plugin for REAPER 5.x and up. Hackey-Trackey is a small 
  tracker for visualizing and editing MIDI data within REAPER. Designed to mimick 
  the pattern editor of Jeskola Buzz, this tracker is meant to enable MIDI note 
  entry and effect automation in a tracked manner.
    
  ![Using Hackey Trackey](https://i.imgur.com/c68YjMd.png)
    
  #### What is it not?
  A sampler. Hackey-Trackey does not handle sample playback. For this you would 
  need to add an additional VST that handles sample playback.
  
  #### How do I use it?
  Select a MIDI object and start the script. Note that scripts can be bound to 
  shortcut keys, which I'd recommend if you're going to be using it. Hit F1 for 
  help on the keys. For more information, please look [here](https://github.com/joepvanlier/Hackey-Trackey).
  
  If you use this plugin and enjoy it let me/others know. If you run into any bugs
  and figure out a way to reproduce them, please open an issue on the plugin's
  github page [here](https://github.com/JoepVanlier/Hackey-Trackey/issues). I would
  greatly appreciate it!
  
  Happy trackin' :)
--]]

--[[
 * Changelog:
 * v1.44 (2018-05-02)
   + Added option to only listen (escape when record is on)
 * v1.43 (2018-05-02)
   + Add option for always record
 * v1.42 (2018-05-02)
   + Fixed bug in pattern length rendering and allow resizing of columns
 * v1.41 (2018-05-02)
   + Added option to follow what MIDI item is selected
 * v1.40 (2018-05-02)   
   + Added option to not resize the window when switching patterns
   + Added option to have properties stick to bottom
 * v1.39 (2018-05-02)
   + Fixed occasional bug in pattern resize operation (losing track of which MIDI take we were editing)
   + Fixed bug that occurred when leafing through patterns with a clipboard selection
 * v1.38 (2018-04-15)
   + Added sixth chords for the minor and major scale
 * v1.37 (2018-04-14)
   + Fixed bug that falsely allowed notes beyond end causing starting note in next column to switch column.
 * v1.36 (2018-04-04)
   + Minor bugfix when no options available yet
 * v1.35 (2018-04-04)
   + Repackaging scales lib
 * v1.34 (2018-03-31)
   + Added scale to cfg file so that it doesn't constantly reset
 * v1.33 (2018-03-31)
   + Added option to make transposition somewhat scale aware when harmonic helper is on.
     It will only use notes from the key then and shift accidentals w.r.t. thei root.
     Note however, that transposition like this will eventually lead to loss of accidentals 
     due to them snapping to the scale and there being no information whether they are 
     sharps of flats.
 * v1.32 (2018-03-31)
   + Added inversions (add ALT or SHIFT when clicking chords).
   + Added harmonic minor scale (sort of).
   + Fixed bugs regarding note insertion.
 * v1.31 (2018-03-30)
   + Show chord similarity index
 * v1.30 (2018-03-28)
   + Added ability to insert chords from harmony helper (CTRL + click). Fixed bug involving note insertion over OFC symbols.
 * v1.29 (2018-03-27)
   + Added option to show harmony helper (F9 to open, arm tracker with CTRL+R to hear the chords you click). Option to insert chords pending.
 * v1.28 (2018-03-24)
   + Started implementing scale helpers (WIP)
 * v1.27 (2018-03-22)
   + Fixed bug in copy/paste system when copying full rows
 * v1.26 (2018-03-18)
   + Fixed rare bug change in pattern length
 * v1.25 (2018-03-17)
   + Fixed issue with pasting block over pattern end giving nil problems
 * v1.24 (2018-03-17)
   + Allow pattern resize (click pattern length and type new value)
 * v1.23 (2018-03-12)
   + Persistent settings
   + Added MIDI panic button (F12)
   + Added STOP command (F8)
 * v1.22 (2018-03-04)
   + Fixed bug mouse interaction
   + Fixed bug titling the window
 * v1.21 (2018-03-03)
   + Added mouse interaction
 * v1.20 (2018-03-03)
   + Added buzz hotkeys
 * v1.19 (2018-02-27)
   + Fix loss of docking status
 * v1.18 (2018-02-27)
   + Merged pull request from r4dian with buzz theme (thanks r4dian!)
 * v1.17 (2018-02-19)
   + Fixed bug copy paste and delete block system
 * v1.16 (2018-02-17)
   + Added shift operator for automation FX
   + Fixed bug in FX copy/paste system
 * v1.15 (2018-02-17)
   + Added shift operator for CC channels
 * v1.14 (2018-02-16)
   + Store which CC tracks are open
   + Named CC tracks where available
 * v1.13 (2018-02-16)
   + Added multi CC extension (CTRL+ over MOD section switches to column view) 
   + Bugfix CCs
   + Bugfix interpolation on empty FX
 * v1.12 (2018-02-15)
   + Fixed rounding errors
 * v1.11 (2018-02-14)
   + Allow for pan and width to be set to left
 * v1.10 (2018-02-14)
   + Added tab and shift tab functionality for navigation
 * v1.09 (2018-02-13)
   + Added note delay
 * v1.08 (2018-02-11)
   + Added ability to play notes while entering them (hit CTRL + R to arm!)
 * v1.07 (2018-02-11)
   + Added column to program CC events
 * v1.06 (2018-02-03)
   + Bugfix: Made sure that if there is more than one OPT field (can happen after glue), the others get removed
 * v1.05 (2018-02-03)
   + Bugfix: Set out channel after channel duplication
 * v1.04 (2018-01-31)
   + Improve help a little bit
 * v1.03 (2018-01-30)
   + Make selection follow the MIDI item selected in the tracker upon switching
 * v1.02 (2018-01-30)
   + Fix such that duplicate patterns don't share the same automation pool ID
 * v1.01 (2018-01-28)
   + Added . as an alternative to Delete
   + Fixed issue with roundoff error when determining number of rows
 * v1.0 (2018-01-28)
   + Fixed bug with shift item up/down not being available
 * v0.99 (2018-01-28)
   + Show name of track the instance is on
   + Show the name of the MIDI take
   + Edit take name with CTRL+N
 * v0.98 (2018-01-28)
   + Store what settings we last worked with in the MIDI item
 * v0.97 (2018-01-28)
   + Forgot to turn off printKeys before committing
 * v0.96 (2018-01-28)
   + Added shortcut to duplicate pattern
 * v0.95 (2018-01-28)
   + Minor fix insert
 * v0.94 (2018-01-27)
   + Added help (F1)
 * v0.93 (2018-01-27)
   + Added ability to go to next/previous MIDI item on track (CTRL + -> and CTRL + <-)
 * v0.92 (2018-01-27)
   + Added option to change rows/measure (CTRL+ALT+up/down, CTRL+ALT+Enter to commit)
 * v0.91 (2018-01-27)
   + Fix legato issue when pasting clipboard data
   + Implemented cut (CTRL+X)
 * v0.90 (2018-01-27)
   + Implemented paste behaviour
 * v0.89 (2018-01-25)
   + Fixed issue in legato system
 * v0.88 (2018-01-25)
   + Bugfix clearBlock
   + Started work on copy behavior
   + Optional debug output   
 * v0.87 (2018-01-25)
   + Added mend block
   + Fixed bug in legato system when notes grew in channels larger than one
 * v0.86 (2018-01-25)
   + Added ReaPack header
--]]

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
--    A simple LUA tracker for REAPER. Simply highlight a MIDI item and start the 
--    script. This will bring up the MIDI item as a tracked sequence. For more 
--    information, please refer to the readme file.
--
--    If you use and/or enjoy this plugin or have a suggestion or bug report,
--    let me/others know.
--
--    Happy trackin'! :)

tracker = {}
tracker.name = "Hackey Trackey v1.44"

-- Map output to specific MIDI channel
--   Zero makes the tracker use a separate channel for each column. Column 
--   one being mapped to MIDI channel 2. Any other value forces the output on 
--   a specific channel.
tracker.outChannel = 1

-- MIDI device to play notes over
-- For me it was 6080 for Virtual MIDI keyboard and 6112 for ALL, but this may
-- be system dependent, I don't know.
tracker.playNoteCh = 6112

-- How much overlap is used for legato?
tracker.magicOverlap = 10

-- Enable FX automation?
tracker.trackFX = 1

-- Defaults
tracker.transpose = 3
tracker.advance = 1
tracker.showloop = 1

-- Set this to one if you want to see what keystrokes correspond to which keys
tracker.printKeys = 0

-- Set this to 1 if you want the selected MIDI item in the sequencer view to change 
-- when you change the selected pattern with CTRL + -> or CTRL + <-. This makes it 
-- easier to see which pattern you are editing. 
tracker.selectionFollows = 1

-- Field of view
tracker.fov = {}

-- Set this if you want a bigger or smaller maximum number of rows
tracker.fov.height = 32

-- Set this if you want a wider or narrower tracker screen
tracker.fov.abswidth = 450

-- Remember settings associated with a specific pattern? (octave, envelope and advance)
tracker.rememberSettings = 1

tracker.fov.scrollx = 0
tracker.fov.scrolly = 0

-- Slack used in notes and automation to check whether a point is the point specified
tracker.eps = 1e-3
tracker.enveps = 1e-4

-- If duplicationBehaviour is set to 1, then MIDI items are duplicated via reaper commands.
-- This means duplicated copies share the same automation pool for the automation takes. 
-- This means that if you change one pattern based on this pool, the other changes as well.
-- If duplicationBehavior is set to any other value, then the MIDI item is explicitly copied 
-- and the automation objects are created separately; making sure they have a new pool ID.
-- This prevents that the pattern automation has to be the same from that point.
tracker.duplicationBehaviour = 2

-- Do we want delays to be shown?
tracker.showDelays = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

-- Start by default in mono or multi-col CC mode
-- Mono-col (0) mode shows one column for the CC's that is always displayed
-- Multi-col (1) shows only specifically enabled CC's (Add new ones with CTRL + SHIFT + +)
-- Remove ones with CTRL + SHIFT + - (note that this deltes the CC data too)
tracker.modMode = 0

tracker.channels = 16 -- Max channel (0 is not shown)
tracker.displaychannels = 15

-- Plotting
tracker.grid = {}
tracker.grid.originx   = 35
tracker.grid.originy   = 35
tracker.grid.dx        = 8
tracker.grid.dy        = 20
tracker.grid.barpad    = 10
tracker.grid.itempadx  = 5
tracker.grid.itempady  = 3

tracker.scrollbar = {}
tracker.scrollbar.size = 10

tracker.zeroindexed = 1
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
tracker.newRowPerQn = 4
tracker.maxRowPerQn = 16

tracker.helpActive = 0
tracker.optionsActive = 0
tracker.helpwidth = 380
tracker.optionswidth = 370
tracker.scalewidth = 500
tracker.renaming = 0

tracker.onlyListen = 0

tracker.cp = {}
tracker.cp.lastShiftCoord = nil
tracker.cp.xstart = -1
tracker.cp.ystart = -1
tracker.cp.xstop = -1
tracker.cp.ystop = -1
tracker.cp.all = 0

tracker.showMod = 1
tracker.lastmodval = 0
tracker.lastmodtype = 1

tracker.selectionBehavior = 0
tracker.automationBug = 1 -- This fixes a bug in v5.70

-- Default configuration
tracker.cfg = {}
tracker.cfg.colorscheme = "buzz"
tracker.cfg.keyset = "default"
tracker.cfg.scaleActive = 0
tracker.cfg.autoResize = 1
tracker.cfg.followSelection = 0
tracker.cfg.stickToBottom = 0
tracker.cfg.colResize = 1
tracker.cfg.alwaysRecord = 0

tracker.binaryOptions = { 
    { 'autoResize', 'Auto Resize' }, 
    { 'followSelection', 'Follow Selection' }, 
    { 'stickToBottom', 'Info Sticks to Bottom' },
    { 'colResize', 'Adjust Column Count to Window' },
    { 'alwaysRecord', 'Always Enable Recording' },    
    }
    
tracker.colorschemes = {"default", "buzz", "it"}

function tracker:loadColors(colorScheme)
  -- If you come up with a cool alternative color scheme, let me know
  self.colors = {}
  local colorScheme = colorScheme or tracker.cfg.colorscheme
  if colorScheme == "default" then
  -- default
    self.colors.helpcolor    = {.8, .8, .9, 1}
    self.colors.helpcolor2   = {.7, .7, .9, 1}
    self.colors.selectcolor  = {1, 0, 1, 1}
    self.colors.textcolor    = {.7, .8, .8, 1}
    self.colors.headercolor  = {.5, .5, .8, 1}
    self.colors.linecolor    = {.1, .0, .4, .4}
    self.colors.linecolor2   = {.3, .0, .6, .4}
    self.colors.linecolor3   = {.4, .1, 1, 1}
    self.colors.linecolor4   = {.2, .0, 1, .5}
    self.colors.linecolor5   = {.3, .0, .6, .4}
    self.colors.loopcolor    = {.2, .3, .8, .5}
    self.colors.copypaste    = {5.0, .7, 0.1, .2}
    self.colors.scrollbar1   = {.2, .1, .6, 1.0}
    self.colors.scrollbar2   = {.1, .0, .3, 1.0}
    self.colors.changed      = {1.0, 0.1, 0.1, 1.0} 
    self.colors.changed2     = {0.0, 0.1, 1.0, .5} -- Only listening    
    self.colors.windowbackground = {0, 0, 0, 1}
  elseif colorScheme == "buzz" then
    -- Buzz
    self.colors.helpcolor        = {1/256*159, 1/256*147, 1/256*115, 1} -- the functions
    self.colors.helpcolor2       = {1/256*48, 1/256*48, 1/256*33, 1} -- the keys
    self.colors.selectcolor      = {1, 1, 1, 1} -- the cursor
    self.colors.textcolor        = {1/256*48, 1/256*48, 1/256*33, 1} -- main pattern data
    self.colors.headercolor      = {1/256*48, 1/256*48, 1/256*33, 1} -- column headers, statusbar etc
    self.colors.linecolor        = {1/256*218, 1/256*214, 1/256*201, 0} -- normal row
    self.colors.linecolor2       = {1/256*181, 1/256*189, 1/256*158, 0.4} -- beats (must not have 100% alpha as it's drawn over the cursor(!))
    self.colors.linecolor3       = {1/256*159, 1/256*147, 1/256*115, 1} -- scroll indicating trangle thingy
    self.colors.linecolor4       = {1, 1, 0, 1} -- Reaper edit cursor
    self.colors.linecolor5       = {1/256*159, 1/256*147, 1/256*115, 0.4} -- Bar start
    self.colors.loopcolor        = {1/256*48, 1/256*48, 1/256*33, 1} -- lines surrounding loop
    self.colors.copypaste        = {1/256*247, 1/256*247, 1/256*244, 0.66}  -- the selection (should be lighter(not alpha blanded) but is drawn over the data)
    self.colors.scrollbar1       = {1/256*48, 1/256*48, 1/256*33, 1} -- scrollbar handle & outline
    self.colors.scrollbar2       = {1/256*218, 1/256*214, 1/256*201, 1} -- scrollbar background
    self.colors.changed          = {1, 1, 0, 1} -- Uncommited resolution changes
    self.colors.changed2         = {0, .5, 1, .5} -- Only listening
    self.colors.windowbackground = {1/256*218, 1/256*214, 1/256*201, 1}
  elseif colorScheme == "it" then
    -- Reapulse Tracker (Impulse Tracker)
    self.colors.helpcolor        = {0, 0, 0, 1} -- the functions
    self.colors.helpcolor2       = {1/256*124, 1/256*88, 1/256*68, 1} -- the keys
    self.colors.selectcolor      = {1, 1, 1, 1} -- the cursor
    self.colors.textcolor        = {1, 1, 1, 1} --{1/256*60, 1/256*105, 1/256*59, 1} -- main pattern data (rows should all be darker & this should be green)
    self.colors.headercolor      = {0, 0, 0, 1} -- column headers, statusbar etc
    self.colors.linecolor        = {0,0,0, 0.6} -- normal row
    self.colors.linecolor2       = {1/256*52, 1/256*48, 1/256*44, 0.6} -- beats (must not have 100% alpha as it's drawn over the cursor(!))
    self.colors.linecolor3       = {1/256*180, 1/256*148, 1/256*120, 1} -- scroll indicating trangle thingy
    self.colors.linecolor4       = {1/256*204, 1/256*204, 1/256*68, 1} -- Reaper edit cursor
    self.colors.linecolor5       = {1/256*88, 1/256*64, 1/256*60, 0.6} -- Bar start
    self.colors.loopcolor        = {1/256*204, 1/256*204, 1/256*68, 1} -- lines surrounding loop
    self.colors.copypaste        = {1/256*24, 1/256*116, 1/256*44, 0.66}  -- the selection (should be lighter(not alpha blanded) but is drawn over the data)
    self.colors.scrollbar1       = {1/256*124, 1/256*88, 1/256*68, 1} -- scrollbar handle & outline
    self.colors.scrollbar2       = {1/256*180, 1/256*148, 1/256*120, 1} -- scrollbar background
    self.colors.changed          = {1, 1, 0, 1}
    self.colors.changed2         = {0, .5, 1, .5} -- Only listening
    self.colors.windowbackground = {1/256*180, 1/256*148, 1/256*120, 1}
  end
  -- clear colour is in a different format cos why not
  gfx.clear = tracker.colors.windowbackground[1]*256+(tracker.colors.windowbackground[2]*256*256)+(tracker.colors.windowbackground[3]*256*256*256)
end

-- Can customize the shortcut keys here, if they aren't working for you
-- If you come up with good alternate layouts (maybe based on impulse, screamtracker
-- or other language keyboards), please share them with me and I'll provide some form
-- of chooser here.

-- Default when no config file is present
keysets = { "default", "buzz" }
keys = {}

-- You can find the keycodes by setting printKeys to 1 and hitting any key.
function tracker:loadKeys( keySet )
  local keyset = keySet or tracker.cfg.keyset
  if keyset == "default" then
    --                    CTRL    ALT SHIFT Keycode
    keys.left           = { 0,    0,  0,    1818584692 }    -- <-
    keys.right          = { 0,    0,  0,    1919379572 }    -- ->
    keys.up             = { 0,    0,  0,    30064 }         -- /\
    keys.down           = { 0,    0,  0,    1685026670 }    -- \/
    keys.off            = { 0,    0,  0,    45 }            -- -
    keys.delete         = { 0,    0,  0,    6579564 }       -- Del
    keys.delete2        = { 0,    0,  0,    46 }            -- .
    keys.home           = { 0,    0,  0,    1752132965 }    -- Home
    keys.End            = { 0,    0,  0,    6647396 }       -- End
    keys.toggle         = { 0,    0,  0,    32 }            -- Space
    keys.playfrom       = { 0,    0,  0,    13 }            -- Enter
    keys.insert         = { 0,    0,  0,    6909555 }       -- Insert
    keys.remove         = { 0,    0,  0,    8 }             -- Backspace
    keys.pgup           = { 0,    0,  0,    1885828464 }    -- Page up
    keys.pgdown         = { 0,    0,  0,    1885824110 }    -- Page down
    keys.undo           = { 1,    0,  0,    26 }            -- CTRL + Z
    keys.redo           = { 1,    0,  1,    26 }            -- CTRL + SHIFT + Z
    keys.beginBlock     = { 1,    0,  0,    2 }             -- CTRL + B
    keys.endBlock       = { 1,    0,  0,    5 }             -- CTRL + E
    keys.cutBlock       = { 1,    0,  0,    24 }            -- CTRL + X
    keys.pasteBlock     = { 1,    0,  0,    22 }            -- CTRL + V
    keys.copyBlock      = { 1,    0,  0,    3 }             -- CTRL + C
    keys.shiftItemUp    = { 0,    0,  1,    43 }            -- SHIFT + Num pad +
    keys.shiftItemDown  = { 0,    0,  1,    45 }            -- SHIFT + Num pad -
    keys.scaleUp        = { 1,    1,  1,    267 }           -- CTRL + SHIFT + ALT + Num pad +
    keys.scaleDown      = { 1,    1,  1,    269 }           -- CTRL + SHIFT + ALT + Num pad -   
    keys.octaveup       = { 1,    0,  0,    30064 }         -- CTRL + /\
    keys.octavedown     = { 1,    0,  0,    1685026670 }    -- CTRL + \/
    keys.envshapeup     = { 1,    0,  1,    30064 }         -- CTRL + SHIFT + /\
    keys.envshapedown   = { 1,    0,  1,    1685026670 }    -- CTRL + SHIFT + /\
    keys.help           = { 0,    0,  0,    26161 }         -- F1
    keys.outchandown    = { 0,    0,  0,    26162 }         -- F2
    keys.outchanup      = { 0,    0,  0,    26163 }         -- F3
    keys.advancedown    = { 0,    0,  0,    26164 }         -- F4
    keys.advanceup      = { 0,    0,  0,    26165 }         -- F5
    keys.stop2          = { 0,    0,  0,    26168 }         -- F8
    keys.harmony        = { 0,    0,  0,    26169 }         -- F9
    keys.options        = { 0,    0,  0,    6697265 }       -- F11    
    keys.panic          = { 0,    0,  0,    6697266 }       -- F12
    keys.setloop        = { 1,    0,  0,    12 }            -- CTRL + L
    keys.setloopstart   = { 1,    0,  0,    17 }            -- CTRL + Q
    keys.setloopend     = { 1,    0,  0,    23 }            -- CTRL + W
    keys.interpolate    = { 1,    0,  0,    9 }             -- CTRL + I
    keys.shiftleft      = { 0,    0,  1,    1818584692 }    -- Shift + <-
    keys.shiftright     = { 0,    0,  1,    1919379572 }    -- Shift + ->
    keys.shiftup        = { 0,    0,  1,    30064 }         -- Shift + /\
    keys.shiftdown      = { 0,    0,  1,    1685026670 }    -- Shift + \/
    keys.deleteBlock    = { 0,    0,  1,    6579564 }       -- Shift + Del
    keys.resolutionUp   = { 1,    1,  0,    30064 }         -- CTRL + Alt + Up
    keys.resolutionDown = { 1,    1,  0,    1685026670 }    -- CTRL + Alt + Down
    keys.commit         = { 1,    1,  0,    13 }            -- CTRL + Alt + Enter
    keys.nextMIDI       = { 1,    0,  0,    1919379572.0 }  -- CTRL + ->
    keys.prevMIDI       = { 1,    0,  0,    1818584692.0 }  -- CTRL + <-
    keys.duplicate      = { 1,    0,  0,    4 }             -- CTRL + D
    keys.rename         = { 1,    0,  0,    14 }            -- CTRL + N
    keys.escape         = { 0,    0,  0,    27 }            -- Escape
    keys.toggleRec      = { 1,    0,  0,    18 }            -- CTRL + R
    keys.showMore       = { 1,    0,  0,    11 }            -- CTRL + +
    keys.showLess       = { 1,    0,  0,    13 }            -- CTRL + -
    keys.addCol         = { 1,    0,  1,    11 }            -- CTRL + Shift + +
    keys.remCol         = { 1,    0,  1,    13 }            -- CTRL + Shift + -
    keys.tab            = { 0,    0,  0,    9 }             -- Tab
    keys.shifttab       = { 0,    0,  1,    9 }             -- SHIFT + Tab
    
    help = {
      { 'Arrow Keys', 'Move' },
      { 'Insert/Backspace/-', 'Insert/Remove/Note OFF' },   
      { 'Del/.', 'Delete' }, 
      { 'Space/Return', 'Play/Play From' },
      { 'CTRL + L', 'Loop pattern' },
      { 'CTRL + Q/W', 'Loop start/end' },
      { 'Shift + +/-', 'Transpose selection' },
      { 'CTRL + B/E', 'Selection begin/End' },
      { 'SHIFT + Arrow Keys', 'Block selection' },
      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },
      { 'CTRL + I', 'Interpolate' },
      { 'Shift + Del', 'Delete block' },
      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' }, 
      { 'CTRL + ALT + Up/Down', '[Res]olution Up/Down' },
      { 'CTRL + ALT + Enter', '[Res]olution Commit' },  
      { 'CTRL + Up/Down', '[Oct]ave up/down' },
      { 'CTRL + Shift + Up/Down', '[Env]elope change' },
      { 'F4/F5', '[Adv]ance De/Increase' },
      { 'F2/F3', 'MIDI [out] down/up' },
      { 'F8/F11/F12', 'Stop / Options / Panic' },
      { 'CTRL + Left/Right', 'Switch MIDI item' },
      { 'CTRL + D', 'Duplicate pattern' },
      { 'CTRL + N', 'Rename pattern' },
      { 'CTRL + R', 'Play notes' },
      { 'CTRL + +/-', 'Advanced col options' },
      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },
      { '', '' },
      { 'Harmony helper', '' },      
      { 'F9', 'Toggle harmonizer' },
      { 'CTRL + Click', 'Insert chord' },
      { 'Alt', 'Invert first note' },
      { 'Shift', 'Invert second note' },
      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },
    }
    
  elseif keyset == "buzz" then
    --                    CTRL    ALT SHIFT Keycode
    keys.left           = { 0,    0,  0,    1818584692 }    -- <-
    keys.right          = { 0,    0,  0,    1919379572 }    -- ->
    keys.up             = { 0,    0,  0,    30064 }         -- /\
    keys.down           = { 0,    0,  0,    1685026670 }    -- \/
    keys.off            = { 0,    0,  0,    96 }            -- ` (should be 1 but whatever)
    keys.delete         = { 0,    0,  0,    6579564 }       -- Del
    keys.delete2        = { 0,    0,  0,    46 }            -- .
    keys.home           = { 0,    0,  0,    1752132965 }    -- Home
    keys.End            = { 0,    0,  0,    6647396 }       -- End
    keys.toggle         = { 0,    0,  0,    26165 }         -- f5 = play/pause
    keys.playfrom       = { 0,    0,  0,    26166 }         -- f6 = play here 
    keys.stop2          = { 0,    0,  0,    26168 }         -- f8 = Stop
    keys.harmony        = { 0,    0,  0,    26169 }         -- f9 = Harmony helper
    keys.options        = { 0,    0,  0,    6697265 }       -- f11 = Options
    keys.panic          = { 0,    0,  0,    6697266 }       -- f12 = MIDI Panic!
    keys.insert         = { 0,    0,  0,    6909555 }       -- Insert
    keys.remove         = { 0,    0,  0,    8 }             -- Backspace
    keys.pgup           = { 0,    0,  0,    1885828464 }    -- Page up
    keys.pgdown         = { 0,    0,  0,    1885824110 }    -- Page down
    keys.undo           = { 1,    0,  0,    26 }            -- CTRL + Z
    keys.redo           = { 1,    0,  1,    26 }            -- CTRL + SHIFT + Z
    keys.beginBlock     = { 1,    0,  0,    2 }             -- CTRL + B
    keys.endBlock       = { 1,    0,  0,    5 }             -- CTRL + E
    keys.cutBlock       = { 1,    0,  0,    24 }            -- CTRL + X
    keys.pasteBlock     = { 1,    0,  0,    22 }            -- CTRL + V
    keys.copyBlock      = { 1,    0,  0,    3 }             -- CTRL + C
    keys.shiftItemUp    = { 0,    0,  1,    43 }            -- SHIFT + Num pad+
    keys.shiftItemDown  = { 0,    0,  1,    45 }            -- SHIFT + Num pad-
    keys.octaveup       = { 0,    0,  0,    42 }            -- *
    keys.octavedown     = { 0,    0,  0,    47 }            -- /
    keys.scaleUp        = { 1,    1,  1,    267 }           -- CTRL + SHIFT + ALT + Num pad +
    keys.scaleDown      = { 1,    1,  1,    269 }           -- CTRL + SHIFT + ALT + Num pad -    
    keys.envshapeup     = { 1,    0,  1,    30064 }         -- CTRL + SHIFT + /\
    keys.envshapedown   = { 1,    0,  1,    1685026670 }    -- CTRL + SHIFT + /\
    keys.help           = { 0,    0,  0,    26161 }         -- F1
    keys.outchanup      = { 1,    0,  0,    30064 }         -- CTRL + UP   (Buzz = next instrument)
    keys.outchandown    = { 1,    0,  0,    1685026670 }    -- CTRL + DOWN (Buzz = prev instrument)
    keys.advancedown    = { 1,    0,  0,    26161 }         -- CTRL + F1 (in Buzz CTRL + -1 = sets step to 1, but that didn't work here)
    keys.advanceup      = { 1,    0,  0,    26162 }         -- CTRL + F2 (in Buzz CTRL + 2 = sets step to 2, but that didn't work here)
    keys.setloop        = { 1,    0,  0,    12 }            -- CTRL + L (no equiv, would be done in F4 seq view)
    keys.setloopstart   = { 1,    0,  0,    17 }            -- CTRL + Q (ditto)
    keys.setloopend     = { 1,    0,  0,    23 }            -- CTRL + W (ditto)
    keys.interpolate    = { 1,    0,  0,    9 }             -- CTRL + I
    keys.shiftleft      = { 0,    0,  1,    1818584692 }    -- Shift + <-
    keys.shiftright     = { 0,    0,  1,    1919379572 }    -- Shift + ->
    keys.shiftup        = { 0,    0,  1,    30064 }         -- Shift + /\
    keys.shiftdown      = { 0,    0,  1,    1685026670 }    -- Shift + \/
    keys.deleteBlock    = { 0,    0,  1,    6579564 }       -- Shift + Del
    keys.resolutionUp   = { 1,    1,  0,    30064 }         -- CTRL + Alt + Up    (no equiv, would be set in pattern properties)
    keys.resolutionDown = { 1,    1,  0,    1685026670 }    -- CTRL + Alt + Down  (ditto)
    keys.commit         = { 1,    1,  0,    13 }            -- CTRL + Alt + Enter (ditto)
    keys.nextMIDI       = { 0,    0,  0,    43 }            -- +
    keys.prevMIDI       = { 0,    0,  0,    45 }            -- -
    keys.duplicate      = { 1,    0,  1,    13 }            -- CTRL + Shift + Return = create copy
    keys.rename         = { 1,    0,  0,    8 }             -- CTRL + Backspace = pattern properties (where name is set)
    keys.escape         = { 0,    0,  0,    27 }            -- Escape
    keys.toggleRec      = { 0,    0,  0,    26167 }         -- f7 = record ...I wanted ALT + N = Play _N_otes, but it didn't work ¯\_(ツ)_/¯
    keys.showMore       = { 1,    0,  0,    11 }            -- CTRL + +
    keys.showLess       = { 1,    0,  0,    13 }            -- CTRL + -
    keys.addCol         = { 1,    0,  1,    11 }            -- CTRL + Shift + +
    keys.remCol         = { 1,    0,  1,    13 }            -- CTRL + Shift + -
    keys.tab            = { 0,    0,  0,    9 }             -- Tab
    keys.shifttab       = { 0,    0,  1,    9 }             -- SHIFT + Tab
    
    help = {
      { 'Arrow Keys', 'Move' },
      { '`', 'Note OFF' },
      { 'Insert/Backspace', 'Insert/Remove line' },   
      { 'Del/.', 'Delete' }, 
      { 'F5/F6', 'Play/Play from here' },
      { 'F8/F11/F12', 'Stop / Options / Panic' },
      { 'CTRL + L', 'Loop pattern' },
      { 'CTRL + Q/W', 'Loop start/end' },
      { 'Shift + +/-', 'Transpose selection' },
      { 'CTRL + B/E', 'Selection Begin/End' },
      { 'SHIFT + Arrow Keys', 'Block selection' },
      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },
      { 'CTRL + I', 'Interpolate' },
      { 'Shift + Del', 'Delete block' },
      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' }, 
      { 'CTRL + ALT + Up/Down', '[Res]olution Up/Down' },
      { 'CTRL + ALT + Return', '[Res]olution Commit' },  
      { '*//', '[Oct]ave Up/Down' },     
      { 'CTRL + Shift + Up/Down', '[Env]elope change' },
      { 'CTRL + F1/F2', '[Adv]ance De/Increase' },
      { 'CTRL + Up/Down', 'MIDI [out] Up/Down' },  
      { '-/+', 'Switch MIDI item' },
      { 'CTRL + Shift + Return', 'Duplicate pattern' },
      { 'CTRL + Backspace', 'Rename pattern' },
      { 'F7', 'Toggle note play' },
      { 'CTRL + +/-', 'Advanced col options' },
      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },
      { '', '' },
      { 'Harmony helper', '' },      
      { 'F9', 'Toggle harmonizer' },
      { 'CTRL + Click', 'Insert chord' },
      { 'Alt', 'Invert first note' },
      { 'Shift', 'Invert second note' },   
      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },
    }
  end
end

tracker.hash = 0
tracker.envShapes = {}
tracker.envShapes[0] = 'Lin'
tracker.envShapes[1] = 'S&H'
tracker.envShapes[2] = 'Exp'

tracker.signed = {}
tracker.signed["Pan (Pre-FX)"] = 1
tracker.signed["Width (Pre-FX)"] = 1
tracker.signed["Pan"] = 1
tracker.signed["Width"] = 1

tracker.armed = 0
tracker.maxPatternNameSize = 13

tracker.hint = '';

tracker.debug = 0

keys.Cbase = 24-12

--- Base pitches
--- Can customize the 'keyboard' here, if they aren't working for you
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

CC = {}
CC[0] = "Bank Select"
CC[1] = "Mod Wheel"
CC[2] = "Breath Ctrl"
CC[4] = "Foot Controller"
CC[5] = "Portamento Time"
CC[6] = "Data Entry MSB"
CC[7] = "Main Volume"
CC[8] = "Balance"
CC[10] = "Pan"
CC[12] = "FX Ctrl 1"
CC[13] = "FX Ctrl 2"
CC[16] = "Gen Purpose Ctrl 1"
CC[17] = "Gen Purpose Ctrl 2"
CC[18] = "Gen Purpose Ctrl 3"
CC[19] = "Gen Purpose Ctrl 4"
CC[64] = "Sustain"
CC[65] = "Portamento"
CC[66] = "Sostenuto"
CC[67] = "Soft Pedal"
CC[68] = "Legato Foot"
CC[69] = "Hold 2"
CC[70]= "Sound Variation"
CC[71] = "Timbre/Harmonics"
CC[72] = "Release Time"
CC[73] = "Attack Time"
CC[74] = "Brightness"
CC[75] = "Sound Ctrl 6"
CC[76] = "Sound Ctrl 7"
CC[77] = "Sound Ctrl 8"
CC[78] = "Sound Ctrl 9"
CC[79] = "Sound Ctrl 10"
CC[80] = "Gen Ctrl 5"
CC[81] = "Gen Ctrl 6"
CC[82] = "Gen Ctrl 7"
CC[83] = "Gen Ctrl 8"
CC[84] = "Portamento Ctrl"
CC[91] = "FX1 Depth (Ext)"
CC[92] = "FX2 Depth (Tremolo)"
CC[93] = "FX3 Depth (Chorus)"
CC[94] = "FX4 Depth (Detune)"
CC[95] = "FX5 Depth (Phaser)"
CC[96] = "Data increment"
CC[97] = "Data decrement"
CC[98] = "Non reg par num LSB"
CC[99] = "Non reg par num LSB"
CC[100] = "Reg par num LSB"
CC[101] = "Reg par num MSB"
CC[121] = "Reset all ctrl"
CC[122] = "Local ctrl"
CC[123] = "All notes off"
CC[124] = "Omni off"
CC[125] = "Omni on"
CC[126] = "Mono on (Poly off)"
CC[127] = "Poly on (Mono off)"

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
  tracker.colors.linecolor5s = alpha( tracker.colors.linecolor5, 1.3 )    
end

local function get_script_path()
  local info = debug.getinfo(1,'S');
  local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
  return script_path
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
  local fx          = self.fx
  local data        = self.data
  local showDelays  = self.showDelays
  
  -- Here is where the linkage between the display and the actual data fields in "tracker" is made
  local colsizes  = {}
  local datafield = {}
  local idx       = {}
  local padsizes  = {}  
  local headers   = {}
  local grouplink = {}    -- Stores what other columns are linked to this one (some act as groups)
  local hints     = {}
  local master    = {}
  
  if ( self.showMod == 1 ) then
    if ( self.modMode == 0 ) then
      -- Single CC display
      master[#master+1]       = 1
      datafield[#datafield+1] = 'mod1'
      idx[#idx+1]             = 0
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 0
      grouplink[#grouplink+1] = {1, 2, 3}
      headers[#headers+1]     = ' CC'
      hints[#hints+1]         = "CC type"
  
      master[#master+1]       = 0
      datafield[#datafield+1] = 'mod2'
      idx[#idx+1]             = 0
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 0
      grouplink[#grouplink+1] = {-1, 1, 2}
      headers[#headers+1]     = ''
      hints[#hints+1]         = "CC type"
      
      master[#master+1]       = 0
      datafield[#datafield+1] = 'mod3'
      idx[#idx+1]             = 0
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 0
      grouplink[#grouplink+1] = {-2, -1, 1}
      headers[#headers+1]     = ''
      hints[#hints+1]         = "CC value"
      
      master[#master+1]       = 0    
      datafield[#datafield+1] = 'mod4'
      idx[#idx+1]             = 0
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 2
      grouplink[#grouplink+1] = {-3, -2, -1}
      headers[#headers+1]     = ''
      hints[#hints+1]         = "CC value"  
    else
      -- Display with CC commands separated per column
      local modtypes = data.modtypes
        if ( modtypes ) then
        for j = 1,#modtypes do
          master[#master+1]       = 1
          datafield[#datafield+1] = 'modtxt1'
          idx[#idx+1]             = j
          colsizes[#colsizes+1]   = 1
          padsizes[#padsizes+1]   = 0
          grouplink[#grouplink+1] = {1}
          headers[#headers+1]     = string.format('CC')
          if ( CC[modtypes[j]] ) then
            hints[#hints+1]         = string.format('%s (%d)', CC[modtypes[j]], modtypes[j])
          else
            hints[#hints+1]         = string.format('CC command %2d', modtypes[j])
          end
        
          master[#master+1]       = 0
          datafield[#datafield+1] = 'modtxt2'
          idx[#idx+1]             = j
          colsizes[#colsizes+1]   = 1
          padsizes[#padsizes+1]   = 1
          grouplink[#grouplink+1] = {-1}
          headers[#headers+1]     = ''
          if ( CC[modtypes[j]] ) then
            hints[#hints+1]         = string.format('%s (%d)', CC[modtypes[j]], modtypes[j])
          else
            hints[#hints+1]         = string.format('CC command %2d', modtypes[j])
          end
        end
      end
    end
  end
  
  if ( fx.names ) then
    for j = 1,#fx.names do
      master[#master+1]       = 1
      datafield[#datafield+1] = 'fx1'
      idx[#idx+1]             = j
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 0
      grouplink[#grouplink+1] = {1}
      headers[#headers+1]     = 'FX'
      hints[#hints+1]         = namerep(fx.names[j])
      
      master[#master+1]       = 0
      datafield[#datafield+1] = 'fx2'
      idx[#idx+1]             = j
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 2
      grouplink[#grouplink+1] = {-1}
      headers[#headers+1]     = ''
      hints[#hints+1]         = namerep(fx.names[j])
    end
  end
  
  master[#master+1]       = 1
  datafield[#datafield+1] = 'legato'
  idx[#idx+1]             = 0
  colsizes[#colsizes+1]   = 1
  padsizes[#padsizes+1]   = 1
  grouplink[#grouplink+1] = {0}
  headers[#headers+1]     = string.format( 'L' )
  hints[#hints+1]         = 'Legato toggle'
  
  for j = 1,self.displaychannels do
    local hasDelay = (self.showDelays[j] == 1)
    
    -- Link up the note fields
    master[#master+1]       = 1
    datafield[#datafield+1] = 'text'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 3
    padsizes[#padsizes + 1] = 1
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {1, 2}
    else
      grouplink[#grouplink+1] = {0}    
    end
    if ( hasDelay ) then
      headers[#headers + 1]   = string.format('  Ch.%2d', j)
    else
      headers[#headers + 1]   = string.format(' Ch%2d', j)
    end
    hints[#hints+1]         = string.format('Note channel %2d', j)
    
    -- Link up the velocity fields
    master[#master+1]       = 0
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
    master[#master+1]       = 0
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
    
    -- Link up the delay fields (if active)
    if ( hasDelay == true ) then
      padsizes[#padsizes]     = 1
      
      master[#master+1]       = 0    
      datafield[#datafield+1] = 'delay1'
      idx[#idx+1]             = j
      colsizes[#colsizes + 1] = 1
      padsizes[#padsizes + 1] = 0
      if ( self.selectionBehavior == 1 ) then
        grouplink[#grouplink+1] = {1}
      else
        grouplink[#grouplink+1] = {1}
      end
      headers[#headers + 1]   = ''    
      hints[#hints+1]         = string.format('Note delay channel %2d', j) 
  
      -- Link up the delay fields
      master[#master+1]       = 0      
      datafield[#datafield+1] = 'delay2'
      idx[#idx+1]             = j
      colsizes[#colsizes + 1] = 1
      padsizes[#padsizes + 1] = 2
      if ( self.selectionBehavior == 1 ) then
        grouplink[#grouplink+1] = {-1}
      else       
        grouplink[#grouplink+1] = {-1}    
      end
      headers[#headers + 1]   = ''     
      hints[#hints+1]         = string.format('Note delay channel %2d', j)
    end
  end
  
  local link = {}
  link.datafields = datafield
  link.headers    = headers
  link.padsizes   = padsizes
  link.colsizes   = colsizes
  link.idxfields  = idx
  link.grouplink  = grouplink
  link.hints      = hints
  link.master     = master
  self.link       = link
end

function tracker:grabLinkage()
  local link = self.link
  return link.datafields, link.padsizes, link.colsizes, link.idxfields, link.headers, link.grouplink, link.hints, link.master
end

------------------------------
-- Establish what is plotted
------------------------------
function tracker:updatePlotLink()
  local plotData = {}
  local grid = tracker.grid
  local originx = grid.originx
  local originy = grid.originy
  local dx = grid.dx
  local dy = grid.dy
  plotData.barpad = grid.barpad
  plotData.itempadx = grid.itempadx
  plotData.itempady = grid.itempady
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
    if ( xpred > fov.abswidth-dx ) then
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
  plotData.totalwidth = tracker.fov.abswidth - 1.5*originx --x - padsizes[#padsizes] * dx - colsizes[#colsizes] * dx
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
  plotData.textSize = dx
  
  self.plotData = plotData
  
  self.scrollbar:setPos( plotData.xstart + plotData.totalwidth, yloc[1]-plotData.yshift, plotData.totalheight - plotData.itempady )
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

function tracker:getLoopLocations()
  local lStart, lEnd = reaper.GetSet_LoopTimeRange2(0, false, 1, 0, 0, false)
  lStart = self:normalizePositionToSelf( lStart )
  lEnd = self:normalizePositionToSelf( lEnd )    
  return lStart, lEnd
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

function tracker:outString()
  if ( tracker.outChannel == 0 ) then
    return 'C'
  else
    return string.format('%d', tracker.outChannel)
  end
end

------------------------------
-- Scrollbar
------------------------------
scrollbar = {}
function scrollbar.create( w )
  self = {}
  self.w = w
  self.setPos = function ( self, x, y, h )
    self.x = x
    self.y = y
    self.h = h
    
    self.ytop = ytop
    self.yend = yend
  end
  self.setExtent = function( self, ytop, yend )
    self.ytop = ytop
    self.yend = yend
  end
  
  self.mouseUpdate = function(self, mx, my, left)
    local loc
    if ( left == 1 ) then
      if ( ( mx > self.x ) and ( mx < self.x + self.w ) ) then
        if ( ( my > self.y ) and ( my < self.y + self.h ) ) then
          loc = ( my - self.y ) / self.h
        end
      end
      return loc
    end
  end
  
  self.draw = function(self, colors)
    local x = self.x
    local y = self.y
    local w = self.w
    local h = self.h
    local ytop = self.ytop
    local yend = self.yend
    
    gfx.set(table.unpack(colors.scrollbar1))
    gfx.rect(x, y, w, h)
    gfx.set(table.unpack(colors.scrollbar2))
    gfx.rect(x+1, y+1, w-2, h-2)
    gfx.set(table.unpack(colors.scrollbar1))
    gfx.rect(x+2, y + ytop*h+2, w-4, (yend-ytop)*h-3)
  end
  
  return self
end

function tracker:getSizeIndicatorLocation()
  local plotData  = self.plotData
  local xloc      = plotData.xloc
  local yloc      = plotData.yloc
  local yheight   = plotData.yheight
  local xl = xloc[1] - plotData.indicatorShiftX
  local yl

  if ( self.cfg.stickToBottom == 1 ) then
    yl = self.windowHeight - yheight[1]*2
  else
    yl = yloc[#yloc] + 1 * yheight[1] + plotData.itempady
  end
  local xm = xl + plotData.textSize*3
  local ym = yl+yheight[1]-6
  
  return xl, yl, xm, ym
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
  local yshift        = plotData.yshift
  
  -- Render in relative FOV coordinates
  local data      = self.data
  for y=1,#yloc do
    gfx.y = yloc[y]
    gfx.x = xloc[1] - plotData.indicatorShiftX
    local absy = y + scrolly
    gfx.set(table.unpack(colors.headercolor))
    if tracker.zeroindexed == 1 then
      gfx.printf("%3d", absy-1)
    else
      gfx.printf("%3d", absy)
    end
    local c1, c2
    if ( (((absy-1)/16) - math.floor((absy-1)/16)) == 0 ) then -- TODO This should depend on current time signature
      c1 = colors.linecolor5
      c2 = colors.linecolor5s
    elseif ( (((absy-1)/4) - math.floor((absy-1)/4)) == 0 ) then
      c1 = colors.linecolor2
      c2 = colors.linecolor2s
    else
      c1 = colors.linecolor
      c2 = colors.linecolors
    end
    gfx.set(table.unpack(c1))
    gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, tw, yheight[1] + itempady)
    gfx.set(table.unpack(c2))
    gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, tw, 1)
    gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, 1, yheight[y])
    gfx.rect(xloc[1] - itempadx + tw + 0, yloc[y] - yshift, 1, yheight[y] + itempady)
    for x=1,#xloc do
      gfx.x = xloc[x]
      gfx.set(table.unpack(colors.textcolor))
      gfx.printf("%s", data[dlink[x]][rows*xlink[x]+absy-1])
    end
  end
  
  -- Pattern Length Indicator
  local xl, yl, xm, ym = self:getSizeIndicatorLocation()
  gfx.y = yl
  gfx.x = xl
  if ( self.renaming == 3 ) then
    gfx.set(table.unpack(colors.changed))
    gfx.printf("%3s", tracker.newLength)
  else
    gfx.set(table.unpack(colors.textcolor))
    gfx.printf("%3d", self.max_ypos)
  end 
  
  gfx.y = yl
  gfx.x = xl
  if ( self.renaming ~= 3 ) then
    gfx.set(table.unpack(colors.linecolor3s))
    gfx.printf("%3d", self.max_ypos)
  end
  
  gfx.line(xl, yl-2, xm,  yl-2)
  gfx.line(xl, ym,   xm,  ym)
  gfx.line(xm, ym,   xm,  yl-2)

  ------------------------------
  -- Field descriptions
  ------------------------------
  local bottom
  if ( self.cfg.stickToBottom == 1 ) then
    bottom = self.windowHeight - yheight[1] * 2
  else
    bottom = yloc[#yloc] + yheight[1] + itempady
  end
  
  gfx.x = plotData.xstart
  gfx.y = bottom
  gfx.set(table.unpack(colors.headercolor))
  if ( tracker.renaming ~= 2 ) then
    gfx.printf("%s", description[relx])
  else
      gfx.set(table.unpack(colors.changed))
      if ( self.newCol:len() > 0 ) then
        gfx.printf("%s", self.newCol)
      else
        gfx.printf("_")
      end
  end
  
  local patternName
  gfx.set(table.unpack(colors.headercolor))
  gfx.y = bottom
  if ( tracker.renaming == 1 ) then
    gfx.set(table.unpack(colors.changed))
    if ( self.midiName:len() > 0 ) then
      patternName = self.midiName
    else
      patternName = '_'
    end
    gfx.x = plotData.xstart + tw - 8.2 * string.len(patternName)
    gfx.printf(patternName)
  else
    patternName = self.patternName
    gfx.x = plotData.xstart + tw - 8.2 * string.len(patternName)
    gfx.printf(patternName)
  end
   
  gfx.set(table.unpack(colors.headercolor))
  local str = string.format("Oct [%d] Adv [%d] Env [%s] Out [%s]", self.transpose, self.advance, tracker.envShapes[tracker.envShape], self:outString() )
  gfx.x = plotData.xstart + tw - 8.2 * string.len(str)
  gfx.y = bottom + yheight[1]
  gfx.set(table.unpack(colors.headercolor))
  gfx.printf(str)

  gfx.x = plotData.xstart
  if ( self.armed == 1) then
    if ( self.onlyListen == 1 ) then
      gfx.set(table.unpack(colors.changed2))    
    else
      gfx.set(table.unpack(colors.changed))
    end
    gfx.printf("[Rec]")
    gfx.set(table.unpack(colors.headercolor))
  else
    gfx.printf("[Rec]")
  end
 
  local str2 = string.format("Res [%d] ", tracker.newRowPerQn )
  if ( tracker.newRowPerQn ~= tracker.rowPerQn ) then
    gfx.set(table.unpack(colors.changed))
  else
    gfx.set(table.unpack(colors.headercolor))
  end
  gfx.x = plotData.xstart + tw - 8.2 * string.len(str) - 8.2 * string.len(str2)
  gfx.y = bottom + yheight[1]
  gfx.printf(str2)
 
  -- Draw the headers so we don't get lost :)
  gfx.set(table.unpack(colors.headercolor))
  gfx.y = yloc[1] - plotData.indicatorShiftY

  for x=1,#xloc do
    gfx.x = xloc[x]
    gfx.printf("%s", headers[x])
  end
    
  ------------------------------
  -- Scrollbar
  ------------------------------
  tracker.scrollbar:setExtent( fov.scrolly / rows, ( fov.scrolly + fov.height ) / rows )
  if ( tracker.fov.height < self.rows ) then
    tracker.scrollbar:draw(colors)
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
  -- Loop indicator
  ------------------------------
  if ( self.showloop == 1 ) then
    local lStart, lEnd = self:getLoopLocations()
    if ( ( lStart >= 0 ) and ( lStart <= 1 ) ) then
      gfx.set(table.unpack(colors.loopcolor))
      gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * lStart - 2*itempady - 1, tw, 2)
    end
    if ( ( lEnd >= 0 ) and ( lEnd <= 1 ) ) then
      gfx.set(table.unpack(colors.loopcolor))
      gfx.rect(plotData.xstart - itempadx, plotData.ystart + plotData.totalheight * lEnd - 2*itempady - 1, tw, 2)
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
  
  ----------------------------------
  -- Help
  ----------------------------------
  
  if ( tracker.helpActive == 1 ) then
    local scales = scales
    local help = help
    local helpwidth = self.helpwidth
    local ys = plotData.ystart - 1.3*plotData.indicatorShiftY
    local xs = plotData.xstart + tw
    if ( self.cfg.scaleActive == 1 ) then
      xs = xs + self.scalewidth * 1
    end
    for i,v in pairs( help ) do
      gfx.set(table.unpack(colors.helpcolor))
      gfx.x = xs + 0.5*helpwidth + 4*itempadx
      gfx.y = ys
      gfx.printf(v[2])
      gfx.set(table.unpack(colors.helpcolor2))
      gfx.x = xs + helpwidth - 8.2 * string.len(v[1]) - 0.5 * helpwidth + 2*itempadx
      gfx.printf(v[1])      
      ys = ys + yheight[1]
    end
  end
  
  ------------------------------
  -- Chorder
  ------------------------------    
  if ( tracker.cfg.scaleActive == 1 ) then
    local xs, ys, scaleY, keyMapH, scaleW, chordW, noteW, chordAreaY, charW = self:chordLocations()
    local xwidth       = plotData.xwidth
    local names        = scales.names
    local progressions = scales.progressions
    
    gfx.set(table.unpack(colors.helpcolor2))
    gfx.x = xs + self.scalewidth - 4 * noteW
    gfx.y = ys
    gfx.printf( "Harmony helper" )
    
    gfx.y = ys + keyMapH
    if ( scales.picked and scales.picked.notes ) then
      local s = ''
      for i,v in pairs( scales.picked.notes ) do
        s = s .. scales:pitchToNote(v) .. ","
      end
      gfx.x = xs + self.scalewidth - (4 + s:len() ) * charW
      gfx.printf( "["..s:sub(1,-2).."]" )
    else
      gfx.x = xs + self.scalewidth - 4 * charW
      gfx.printf( "[]" )   
    end
    
    gfx.x = xs
    gfx.y = ys
    gfx.printf( "Current scale: " .. scales:getScale() .. " " .. scales:getScaleNote(1) .. " (" .. scales:scaleNotes() .. ")"  )

    gfx.y = scaleY
    local curx = xs
    local root = scales:getRootValue()
    for k = 1,12 do
      local notetxt = scales:getNote(k)
      gfx.x = curx + 0.5 * noteW - 0.1 * noteW * (#notetxt-1)
      if ( k == root ) then
        gfx.set(table.unpack(colors.textcolor))
      else
        gfx.set(table.unpack(colors.helpcolor))
      end
      gfx.printf( notetxt )
          
      curx = curx + noteW
    end
    gfx.set(table.unpack(colors.textcolor))
    
    local cury = ys + chordAreaY - keyMapH
    local curx = xs + scaleW
    
    -- Currently marked for major, could choose to incorporate others
    local markings = { 'I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii0', 'VIII' }
    for k = 1,7 do
      gfx.x = curx
      gfx.y = cury
      gfx.printf( markings[k] )
          
      curx = curx + chordW
    end    
    cury = cury + keyMapH
    gfx.set(table.unpack(colors.helpcolor))
    gfx.line(xs-5, cury-4, xs+self.scalewidth*0.95, cury-5)
    gfx.set(table.unpack(colors.textcolor))
    local selectedScale = scales:getScaleValue()
    for i = 1,#names do
      gfx.x = xs
      gfx.y = cury
      local scaleName = scales.names[i]
      if ( i == selectedScale ) then
        gfx.set(table.unpack(colors.textcolor))      
      else
        gfx.set(table.unpack(colors.helpcolor))
      end
      gfx.printf( scaleName )
      gfx.set(table.unpack(colors.textcolor))
        
      local chordmap = progressions[scaleName]
      for j = 1,#(chordmap[i].notes) do
        local curx = xs + scaleW
        for k = 1,7 do        
          gfx.x = curx
          gfx.y = cury
          if ( chordmap[k].names[j] ) then
            local score = scales:similarityScore( chordmap[k].notes[j] )
            local col = { colors.textcolor[1], colors.textcolor[2], colors.textcolor[3], clamp( 0.1, 1, colors.textcolor[4] - 0.4 * score ) }
            gfx.set(table.unpack(col))
          
            gfx.printf( chordmap[k].names[j] )
          end
          
          curx = curx + chordW
        end
        cury = cury + keyMapH
      end
      gfx.set(table.unpack(colors.helpcolor))
      gfx.line(xs-5, cury-4, xs+self.scalewidth*0.95, cury-5)
      gfx.set(table.unpack(colors.textcolor))
    end
  end
  
  if ( tracker.optionsActive == 1 ) then
    local help = help
    local helpwidth = self.helpwidth
    
    local xs, ys, keyMapX, keyMapY, keyMapH, themeMapX, themeMapY, binaryOptionsX, binaryOptionsY, binaryOptionsH = self:optionLocations()

    gfx.set(table.unpack(colors.helpcolor2))
    gfx.x = xs
    gfx.y = ys
    gfx.printf( "Options" )
    
    xs = themeMapX
    ys = themeMapY
    gfx.y = ys
    gfx.x = xs
    gfx.printf( "Theme mapping" )
    
    for i,v in pairs( tracker.colorschemes ) do
      ys = ys + keyMapH
      gfx.y = ys
      gfx.x = xs + 8.2*2
      
      if ( v == tracker.cfg.colorscheme ) then
        gfx.set(table.unpack(colors.helpcolor2))
      else
        gfx.set(table.unpack(colors.helpcolor))
      end
      gfx.printf(v)
    end
    
    gfx.set(table.unpack(colors.helpcolor2))
    xs = keyMapX
    ys = keyMapY
    gfx.y = ys
    gfx.x = xs
    gfx.printf( "Key mapping" )
    
    for i,v in pairs( keysets ) do
      ys = ys + keyMapH
      gfx.y = ys
      gfx.x = xs + 8.2*2
      
      if ( v == tracker.cfg.keyset ) then
        gfx.set(table.unpack(colors.helpcolor2))
      else
        gfx.set(table.unpack(colors.helpcolor))
      end
      gfx.printf(v)
    end
    
    xs = binaryOptionsX
    ys = binaryOptionsY
    gfx.x = xs
    gfx.y = ys
    
    for i=1,#self.binaryOptions do
      gfx.set(table.unpack(colors.helpcolor2))
      gfx.x = xs
      local cys = ys + i * binaryOptionsH
      gfx.y = cys
      
      gfx.line(xs, cys, xs,  cys+8)
      gfx.line(xs+8, cys, xs+8,  cys+8)
      gfx.line(xs, cys, xs+8,  cys)
      gfx.line(xs, cys+8, xs+8,  cys+8)
      
      if ( self.cfg[self.binaryOptions[i][1]] == 1 ) then
        gfx.line(xs, cys, xs+8,  cys+8)
        gfx.line(xs+8, cys, xs,  cys+8)        
      end
      
      gfx.printf( "  %s", self.binaryOptions[i][2] )
    end
  end
  
end

-- Load the scales
dofile(get_script_path() .. 'scales.lua')
scales:initialize()

function tracker:optionLocations()
  local plotData = self.plotData
  local tw       = plotData.totalwidth
  local th       = plotData.totalheight
  local itempadx = plotData.itempadx
  local itempady = plotData.itempady
  local yloc     = plotData.yloc
  local yheight  = (yloc[2]-yloc[1])*.8 --plotData.yheight
  
  local xs = plotData.xstart + tw + 4*itempadx
  local ys = plotData.ystart - 1.3*plotData.indicatorShiftY + yheight
  
  if ( self.helpActive == 1 ) then
    xs = xs + self.helpwidth * 1.1
  end
  if ( self.cfg.scaleActive == 1 ) then
    xs = xs + self.scalewidth * 1.1
  end
  
  local keyMapX = xs + 8.2 * 2
  local keyMapY = ys + yheight * ( 5 + #keysets )
  local keyMapH = yheight
  
  local themeMapX = xs + 8.2 * 2
  local themeMapY = ys + yheight * 2
  
  local binaryOptionsX = xs + 8.2 * 2
  local binaryOptionsY = ys + yheight * ( 5 + #tracker.colorschemes + #keysets )
  
  return xs, ys, keyMapX, keyMapY, keyMapH, themeMapX, themeMapY, binaryOptionsX, binaryOptionsY, keyMapH
end

function tracker:chordLocations()
  local grid     = tracker.grid
  local dx       = grid.dx
  local plotData = self.plotData
  local tw       = plotData.totalwidth
  local th       = plotData.totalheight
  local itempadx = plotData.itempadx
  local itempady = plotData.itempady
  local xloc     = plotData.xloc
  local yloc     = plotData.yloc
  local xwidth   = dx
  local yheight  = (yloc[2]-yloc[1])*.8 --plotData.yheight
  
  local xs = plotData.xstart + tw + 4*itempadx
  local ys = plotData.ystart - 1.3*plotData.indicatorShiftY + .5 * yheight
   
  local scaleY    = ys + 1.5*yheight
  local keyMapH   = yheight
  local scaleLoc  = ys + 2*yheight
  local scaleW    = xwidth*12
  local chordW    = xwidth*7
  local noteW     = xwidth*4
  
  local themeMapX = xs + xwidth
  local themeMapY = ys + yheight * 2
  
  return xs, ys, scaleY, keyMapH, scaleW, chordW, noteW, ys + keyMapH * 4, dx
end

-- Returns fieldtype, channel and row
function tracker:getLocation()
  local plotData  = self.plotData
  local dlink     = plotData.dlink
  local xlink     = plotData.xlink
  
  local relx = tracker.xpos - tracker.fov.scrollx
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then  
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
  tracker:stopNote()
end

---------------------
-- Shift operator
---------------------
function tracker:shiftAt( x, y, shift, scale )
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
      
      local newPitch = 0
      if ( self.cfg.scaleActive == 1 ) then
        if ( scale and scale == 1 ) then
          newPitch = scales:shiftRoot(pitch, shift)
        else
          newPitch = scales:shiftPitch(pitch, shift)
        end
      else
        newPitch = pitch+shift
      end
      
      reaper.MIDI_SetNote(self.take, selected, nil, nil, nil, nil, nil, newPitch, nil, true) 
    elseif ( datafields[x] == 'vel1' ) or ( datafields[x] == 'vel2' ) then
      -- Velocity
      local pitch, vel, startppqpos, endppqpos = table.unpack( note )
      reaper.MIDI_SetNote(self.take, selected, nil, nil, nil, nil, nil, nil, clamp(0, 127,vel+shift), true)     
    elseif ( datafields[x] == 'delay1' ) or ( datafields[x] == 'delay2' ) then
      -- Note delay
      local delay = self:getNoteDelay( selected )
      self:setNoteDelay( selected, delay + shift )
    end
  end
  if ( ( datafields[x] == 'mod1' ) or ( datafields[x] == 'mod2' ) or ( datafields[x] == 'mod3' ) or ( datafields[x] == 'mod4' ) ) then
    local modtype, val, found = self:getCC( y - 1 )
    if ( found == 1 ) then
      local newval = clamp( 0, 127, val + shift )
      self:addCCPt_channel( y - 1, modtype, newval )
    end
  elseif ( ( datafields[x] == 'modtxt1' ) or ( datafields[x] == 'modtxt2' ) ) then
    local modtypes = self.data.modtypes
    local modtype, val, found = self:getCC( y - 1, modtypes[chan] )
    if ( found == 1 ) then
      local newval = clamp( 0, 127, val + shift )
      self:addCCPt_channel( y - 1, modtype, newval )
    end
  elseif ( ( datafields[x] == 'fx1' ) or ( datafields[x] == 'fx2' ) ) then  
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(y-1))
    if ( env and shape ) then
      local newEnv = clamp( 0, 1, env + shift/255 )
      self:addEnvPt(chan, self:toSeconds(y-1), newEnv, shape)
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

function tracker:shiftScaleUp()
  local cp = self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift root operation")
  reaper.MarkProjectDirty(0)
  
  if ( cp.ystop == -1 ) then
    self:shiftAt( tracker.xpos, tracker.ypos, 1, 1 )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, 1, 1 )
      end
    end
  end
  
  scales:switchRoot( scales.root + 1 )
  self:saveConfig(self.cfg)
  reaper.MIDI_Sort(self.take)
end

function tracker:shiftScaleDown()
  local cp = self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift root operation")
  reaper.MarkProjectDirty(0)
  
  if ( cp.ystop == -1 ) then  
    self:shiftAt( tracker.xpos, tracker.ypos, -1, 1 )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, -1, 1 )
      end
    end
  end
  
  scales:switchRoot( scales.root - 1 )
  self:saveConfig(self.cfg)
  reaper.MIDI_Sort(self.take)
end


function tracker:addNotePpq(startppqpos, endppqpos, chan, pitch, velocity)
  local endrow = self:ppqToRow(endppqpos)

  if ( chan == 1 ) then
    if ( self.legato[endrow] and self.legato[endrow] > -1 ) then
      endppqpos = endppqpos + tracker.magicOverlap
    end
  end

  reaper.MIDI_InsertNote( self.take, false, false, startppqpos, endppqpos, chan, pitch, velocity, true )
end

function tracker:addNote(startrow, endrow, chan, pitch, velocity)
  local startppqpos = self:rowToPpq(startrow)
  local endppqpos   = self:rowToPpq(endrow)

  if ( chan == 1 ) then
    if ( self.legato[endrow] > -1 ) then
      endppqpos = endppqpos + tracker.magicOverlap
    end
  end

  reaper.MIDI_InsertNote( self.take, false, false, startppqpos, endppqpos, chan, pitch, velocity, true )
end

function tracker:getNoteDelay( note )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  return self:ppqToDelay( startppqpos )
end

function tracker:setNoteDelay( note, newDelay )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local newppq = self:delayToPpq( startppqpos, newDelay )
  reaper.MIDI_SetNote(self.take, note, nil, nil, newppq, nil, nil, nil, nil, true)
end

function tracker:ppqToDelay( ppq )
  local rows = self.rows
  local eps = self.eps
  local singlerow = self:rowToPpq(1)
  local ppq = ppq - self:rowToPpq( self:ppqToRow(ppq) )  --singlerow * math.floor( ( ppq + eps ) / singlerow ) -- modulo
  return math.floor( 256 * ( ppq / singlerow ) )
end

function tracker:delayToPpq( ppq, delay )
  local singlerow = self:rowToPpq(1)
  local ppq = self:rowToPpq( self:ppqToRow(ppq) )
  return ppq + singlerow * ( delay / 256.0 )
end

----------------------
-- Show more data
----------------------
function tracker:showMore()
  local ftype, chan, row = self:getLocation()
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) ) then
    local singlerow = math.floor(self:rowToPpq(1))
    if ( ( singlerow / 256 ) ~= math.floor( singlerow/256 ) ) then
      if ( not self.showedWarning ) then
        reaper.ShowMessageBox("WARNING: This functionality only works reliably when MIDI pulses per row is set to a multiple of 256!\nPreferences > Media/MIDI > Ticks per quarter note for new MIDI items.", "WARNING", 0)
        self.showedWarning = 1
      end
    end
  
    self.showDelays[chan] = 1
    self.hash = 0
  end
  
  if ( ( ftype == 'mod1' ) or ( ftype == 'mod2' ) or ( ftype == 'mod3' ) or ( ftype == 'mod4' ) ) then
    tracker.modMode = 1
    self.hash = 0
    self:storeSettings()
  end
end

function tracker:showLess()
  local ftype, chan, row = self:getLocation()
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then
    self.showDelays[chan] = 0
    self.hash = 0
  end
  if ( ( ftype == 'modtxt1' ) or ( ftype == 'modtxt2' ) ) then
    tracker.modMode = 0
    self.hash = 0
    self:storeSettings()    
  end
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
  
  if ( ( self.armed == 1 ) and ( self.onlyListen == 1 ) ) then
    local note = keys.pitches[char]
    if ( note ) then
      -- Note is present, we are good to go!
      local pitch = note + tracker.transpose * 12
      self:playNote(chan, pitch, self.lastVel)
    end
    
    return
  end
  
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
        local p2, v2 = table.unpack( notes[noteToEdit] )
        self:playNote(chan, pitch, v2)
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
        self:playNote(chan, pitch, self.lastVel)
      
        if ( noteGrid[rows*chan+k] ) then
          if ( noteGrid[rows*chan+k] < -1 ) then    
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
        end
        
        -- Were we overwriting an OFF marker?
        local idx = rows*chan+row
        if ( noteGrid[idx] and noteGrid[idx] < -1 ) then
          self:deleteNote(chan, row)
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
          self:playNote(chan, pitch, vel)
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
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos-1))
    env = env or self.lastEnv
    local newEnv = tracker:editEnvField( env, 1, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)
    self.ypos = self.ypos + self.advance
    self.lastEnv = newEnv
  elseif ( ( ftype == 'fx2' ) and validHex( char ) ) then
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos-1))
    env = env or self.lastEnv  
    local newEnv = tracker:editEnvField( env, 2, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)    
    self.ypos = self.ypos + self.advance
    self.lastEnv = newEnv
  elseif ( ( ftype == 'delay1' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local delay = self:getNoteDelay( noteToEdit )
      local newDelay = self:editCCField( delay, 1, char )
      self:setNoteDelay( noteToEdit, newDelay )
      self.ypos = self.ypos + self.advance
    end
  elseif ( ( ftype == 'delay2' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local delay = self:getNoteDelay( noteToEdit )
      local newDelay = self:editCCField( delay, 2, char )
      self:setNoteDelay( noteToEdit, newDelay )
      self.ypos = self.ypos + self.advance
    end
  elseif ( ( ftype == 'mod1' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newtype = self:editCCField( modtype, 1, char )
    self:addCCPt( self.ypos-1, newtype, val )
    self.lastmodtype = newtype
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'mod2' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newtype = self:editCCField( modtype, 2, char )
    self:addCCPt( self.ypos-1, newtype, val )
    self.lastmodtype = newtype
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'mod3' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newval = self:editCCField( val, 1, char )
    self:addCCPt( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'mod4' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newval = self:editCCField( val, 2, char )
    self:addCCPt( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'modtxt1' ) and validHex( char ) ) then
    local modtypes = data.modtypes
    local modtype, val = self:getCC( self.ypos - 1, modtypes[chan] )
    local newval = self:editCCField( val, 1, char )
    self:addCCPt_channel( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    self.ypos = self.ypos + self.advance
  elseif ( ( ftype == 'modtxt2' ) and validHex( char ) ) then
    local modtypes = data.modtypes  
    local modtype, val = self:getCC( self.ypos - 1, modtypes[chan] )
    local newval = self:editCCField( val, 2, char )
    self:addCCPt_channel( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    self.ypos = self.ypos + self.advance    
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
  if ( not tracker.deleteNotes ) then
    tracker.deleteNotes = {}
  end
  tracker.deleteNotes[note] = note
end

function tracker:SAFE_DeleteText( take, txt )
  if ( not tracker.deleteText ) then
    tracker.deleteText = {}
  end
  tracker.deleteText[txt] = txt
end

function ordereduniquepairs(inTable, order)
  if ( not inTable ) then
    print( "Warning! Error in iterator: passed nil to spairs" )
    return function() return nil end
  end

  local keys = {}
  for k in pairs(inTable) do table.insert(keys, k) end
  table.sort(keys, function(a,b) return a > b end)

  local i = 0
  local last = -1337
  return function()
    i = i + 1  
    while( inTable[keys[i]] == last ) do
      i = i + 1
    end
    if ( keys[i] ) then
      last = inTable[keys[i]]
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

  if ( deleteNotes ) then
    for i,v in ordereduniquepairs(deleteNotes) do
      reaper.MIDI_DeleteNote(self.take, v)
    end
  end
  if ( deleteText ) then
    for i,v in ordereduniquepairs(deleteText) do
      reaper.MIDI_DeleteTextSysexEvt(self.take, v)
    end    
  end
  
  self.deleteNotes = {}
  self.deleteText = {}
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
  if ( row > 0 ) then
    local noteToResize = noteGrid[rows*chan+row - 1]
    
    -- Was there a note before this?
    if ( noteToResize and ( noteToResize > -1 ) ) then
      local k = row+1
      while( k < rows ) do
        idx = rows*chan+k
        if ( noteGrid[idx] and ( not ( noteGrid[idx] == noteToDelete ) ) ) then
          if ( self.debug == 1 ) then
            if ( noteGrid[idx] > -1 ) then
              local pitch = table.unpack( notes[noteGrid[idx]] )
              local pitch2 = table.unpack( notes[noteToResize] )
              --print( 'I (' .. self.pitchTable[pitch2] .. ') am breaking my elongation on note !' .. self.pitchTable[pitch] )
            else
              local pitch2 = table.unpack( notes[noteToResize] )
              --print( 'I (' .. self.pitchTable[pitch2] .. ') am breaking my elongation on an OFF symbol' )
            end
          end
          break;
        end
        k = k + 1
      end
      local newend = k

      -- If we are the last note, then it may go to the end of the track, hence only subtract
      -- the shift offset if we are not the last note in the pattern
      local magic = 0
      if ( k < rows ) then
        newend = newend - offset
        -- We might want to add some extra for legato. Note that coming from an OFF symbol,
        -- we need to take into account that these have forced legato offs.
        if ( chan == 1 ) then
          if ( legatoWasOff ) then
            magic = self:legatoResize(0, -1, self.legato[k])        
          else
            magic = self:legatoResize(0, self.legato[row], self.legato[k])
          end
        end
      end
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToResize] )
      
      reaper.MIDI_SetNote(self.take, noteToResize, nil, nil, startppqpos, newend * singlerow + magic, nil, nil, nil, true)
      
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
  if ( not newLegato ) then
    newLegato = -1
  end
  if ( ( newLegato > -1 ) and ( oldLegato < 0 ) ) then
    endppqpos = endppqpos + tracker.magicOverlap
  elseif ( ( newLegato < 0 ) and ( oldLegato > -1 ) ) then
    endppqpos = endppqpos - tracker.magicOverlap
  end
  return endppqpos
end

---------------------
-- Resize a note
---------------------
function tracker:resizeNote(chan, row, sizeChange)
  local notes     = self.notes
  local singlerow = self:rowToPpq(1)
  local noteGrid  = self.data.note
  local rows      = self.rows
  local note      = noteGrid[ rows * chan + row ]
  
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local endrow = math.floor( self:ppqToRow( endppqpos ) )

  -- Was this a legato note?
  if ( chan == 1 ) then
    local legato = self.legato
      
    -- Check if it's legato at the old end position!
    local oldLegato = legato[endrow]
    local newLegato = legato[endrow+sizeChange]
    endppqpos = self:legatoResize(endppqpos, oldLegato, newLegato)      
  end

  reaper.MIDI_SetNote(self.take, note, nil, nil, startppqpos, endppqpos + singlerow * sizeChange, nil, nil, nil, true)
end

---------------------
-- Shrink a note by 1 except when at end (used in backspace)
---------------------
function tracker:shrinkNote(chan, row)
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
-- Grow a note by 1 except when at end (used in insert)
---------------------
function tracker:growNote(chan, row)
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then
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
      tmp = legato[i]>-1
      self:setLegato( i, lastleg )
      lastleg = tmp
    end
  elseif( ftype == 'fx1' or ftype == 'fx2' ) then
    self:backspaceEnvPt(chan, self:toSeconds(self.ypos-1))
  elseif( ftype == 'mod1' or ftype == 'mod2' or ftype == 'mod3' or ftype == 'mod4' ) then
    self:backspaceCCPt(self.ypos-1)
  elseif( ftype == 'modtxt1' or ftype == 'modtxt2' ) then
    self:backspaceCCPt(self.ypos-1, data.modtypes[chan])    
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
-- Delete note simple
---------------------
function tracker:deleteNoteSimple(channel, row)
  local rows      = self.rows
  local notes     = self.notes
  local noteGrid  = self.data.note
  local noteStart = self.data.noteStart
  local shift     = shiftIn or 0
  local singlerow = self:rowToPpq(1)
  
  noteToDelete = noteStart[rows*channel+row]
  offToDelete = noteGrid[rows*channel+row]
  if ( noteToDelete ) then
    if ( noteToDelete > -1 ) then
      self:SAFE_DeleteNote(self.take, noteToDelete)
    end
  elseif ( offToDelete ) then
    if ( offToDelete < -1 ) then
      local offidx = self:gridValueToOFFidx( offToDelete )
      self:SAFE_DeleteText(self.take, offidx)
    end
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then
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
  elseif ( ftype == 'mod1' or ftype == 'mod2' or ftype == 'mod3' or ftype == 'mod4' ) then
    self:deleteCC_range(row)
  elseif ( ftype == 'modtxt1' or ftype == 'modtxt2' ) then  
    self:deleteCC_range(row, row+1, data.modtypes[chan])
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
--      if ( shift < 0 ) then
        newEnd = endppqpos
--      end
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
  local rows      = self.rows
  
  -- Determine fieldtype, channel and row
  local ftype, chan, row = self:getLocation()  
  
  -- What are we manipulating here?
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then
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
      if ( row > 0 ) then
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
      tmp = self.legato[i]>-1
      self:setLegato( i, lastleg )
      lastleg = tmp
    end
  elseif ( ftype == 'fx1' or ftype == 'fx2' ) then
    self:insertEnvPt(chan, self:toSeconds(self.ypos-1))
  elseif ( ftype == 'mod1' or ftype == 'mod2' or ftype == 'mod3' or ftype == 'mod4' ) then
    self:insertCCPt(self.ypos-1)
  elseif ( ftype == 'modtxt1' or ftype == 'modtxt2' ) then
    self:insertCCPt(self.ypos-1, data.modtypes[chan])    
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

function tracker:ppqToSeconds(ppq)
  return ppq / self.ppqPerSec
end

function tracker:secondsToPpq(seconds)
  return seconds * self.ppqPerSec
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

function tracker:getResolution( reso )
  -- Determine Row per Qn for this MIDI item
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,textsyxevtcntOut do
    local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
    
    if ( string.sub(msg,1,3) == 'ROW' ) then
      local rpq = tonumber( string.sub(msg,4,5) )
      if ( rpq ) then
        return rpq
      end
    end
  end
  
  return self.rowPerQn
end

function tracker:getSettings( )
  local oct, adv, env, modMode
  local foundOpt = 0
  if ( self.rememberSettings == 1 ) then
    local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    for i=0,textsyxevtcntOut do
      local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
      
      if ( string.sub(msg,1,3) == 'OPT' ) then
        if ( foundOpt == 0 ) then
          oct = tonumber( string.sub(msg,4,5) )
          adv = tonumber( string.sub(msg,6,7) )
          env = tonumber( string.sub(msg,8,9) )
          modMode = tonumber( string.sub(msg,10,10) )
          foundOpt = 1
        else
          self:SAFE_DeleteText(self.take, i)
        end
      end
    end
    
    self.transpose  = oct or self.transpose
    self.advance    = adv or self.advance
    self.envShape   = env or self.envShape
    self.modMode    = modMode or self.modMode
  end
  self:deleteNow()
end

function tracker:storeSettings( )
  if ( self.rememberSettings == 1 ) then
    local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    for i=0,textsyxevtcntOut do
      local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
      
      if ( string.sub(msg,1,3) == 'OPT' ) then
        reaper.MIDI_DeleteTextSysexEvt(self.take, i)
      end
    end
    
    reaper.MIDI_InsertTextSysexEvt(self.take, false, false, 0, 1, string.format( 'OPT%2d%2d%2d%d', self.transpose, self.advance, self.envShape, self.modMode ) )
  end
end

function tracker:storeOpenCC( )
  if ( self.rememberSettings == 1 ) then
    local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    for i=0,textsyxevtcntOut do
      local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
      
      if ( string.sub(msg,1,3) == 'CCC' ) then
        reaper.MIDI_DeleteTextSysexEvt(self.take, i)
      end
    end
    
    if ( #(self.data.modtypes) > 0 ) then
      local str = 'CCC'
      for i,v in pairs(self.data.modtypes) do
        str = str .. string.format( '%3d ', v )
      end
    
      reaper.MIDI_InsertTextSysexEvt(self.take, false, false, 0, 1, str )
    end
  end
end

function tracker:getOpenCC()
  local foundOpt = 0
  local all = {}
  if ( self.rememberSettings == 1 ) then
    local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    for i=0,textsyxevtcntOut do
      local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
      
      if ( string.sub(msg,1,3) == 'CCC' ) then
        if ( foundOpt == 0 ) then
          -- Parse the channels that were open
          local vals = string.sub(msg,4)
          if ( vals:len() > 0 ) then
            for i in string.gmatch(vals, "%d+") do
               all[ tonumber( i ) ] = 1
            end
          end
        end
      end
    end     
  end
  
  return all
end

function tracker:setResolution( reso )
  local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,textsyxevtcntOut do
    local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")
    
    if ( string.sub(msg,1,3) == 'ROW' ) then
      reaper.MIDI_DeleteTextSysexEvt(self.take, i)
    end
  end
  
  reaper.MIDI_InsertTextSysexEvt(self.take, false, false, 0, 1, string.format( 'ROW%2d', reso ) )
end

------------------------------
-- Determine timing info
-- returns true if something changed
------------------------------
function tracker:getRowInfo()

    self.rowPerQn = self:getResolution()

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
    self.ppqPerSec = ppqPerSec
    local rows = math.floor( self.rowPerQn * self.qnCount + 0.5 )
    
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

-- Assign a CC event
function tracker:assignCC(ppq, modtype, modval)
  local data = self.data
  local row = math.floor( self.rowPerPpq * ppq + self.eps )

  if ( ppq and modval and modtype and ( modtype > 0 ) ) then
    local hexType = string.format('%02X', math.floor(modtype) )
    local hexVal = string.format('%02X', math.floor(modval) )    
    data.mod1[row] = hexType:sub(1,1)
    data.mod2[row] = hexType:sub(2,2)
    data.mod3[row] = hexVal:sub(1,1)
    data.mod4[row] = hexVal:sub(2,2)
  end
end

-- Assign a CC event
function tracker:assignCC2(ppq, modtype, modval)
  local data = self.data
  local rows = self.rows
  local row = math.floor( self.rowPerPpq * ppq + self.eps )

  if ( ppq and modval and modtype and ( modtype > 0 ) ) then
    local col = self:CCToColumn(modtype)
    local hexVal = string.format('%02X', math.floor(modval) )    
    data.modtxt1[col*rows+row] = hexVal:sub(1,1)
    data.modtxt2[col*rows+row] = hexVal:sub(2,2)
  end
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

    if ( self.showDelays[ channel ] == 1 ) then
      local delay = self:ppqToDelay( startppqpos )
      data.delay1[rows*channel+ystart]  = self:velToField(delay, 1)
      data.delay2[rows*channel+ystart]  = self:velToField(delay, 2)    
    end

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
  return string.sub( string.format('%02X', math.floor(vel) ), id, id )
end

function tracker:editVelField( vel, id, val )
  -- Convert to Hex first
  local newvel = string.format('%02X', math.floor(vel) )
  -- Replace the digit in question
  newvel = newvel:sub( 1, id-1 ) .. val ..  newvel:sub( id+1 )
  newvel = math.floor( tonumber( "0x"..newvel ) )
  newvel = clamp(1, 127, newvel)
  return newvel
end

-- Tracker => Reaper
function tracker:byteToFloat( byteval )
  return byteval / 255
end

-- Reaper => Tracker
function tracker:floatToByte( floatval )
  local out = clamp( 0, 255, math.floor( floatval * 256.0 ) )
  return out
end

function tracker:editEnvField( vel, id, val )
  -- Convert to Hex first
  local newvel = string.format('%02X', self:floatToByte( vel ) )
  -- Replace the digit in question
  newvel = newvel:sub( 1, id-1 ) .. val ..  newvel:sub( id+1 )
  newvel = tonumber( "0x"..newvel )
  newvel = self:byteToFloat( newvel )
  return newvel
end

function tracker:editCCField( vel, id, val )
  -- Convert to Hex first
  local newvel = string.format('%02X', math.floor(vel) )
  -- Replace the digit in question
  newvel = newvel:sub( 1, id-1 ) .. val ..  newvel:sub( id+1 )
  newvel = tonumber( "0x"..newvel )
  return newvel
end

function tracker:columnToCC(col)
  local data = self.data
  return data.modtypes[col]
end

function tracker:CCToColumn(CC)
  local data = self.data
  return data.modmap[CC]
end

------------------------------
-- Initialize mod channels
-----------------------------
function tracker:initializeModChannels(modtypes)
  local data = self.data
  local rows = self.rows
  data.modch = {}
  data.modtxt1 = {}
  data.modtxt2 = {}
  data.modtypes = modtypes
  -- CC to column
  data.modmap = {}
  for x=1,#modtypes do
    data.modmap[modtypes[x]] = x
    for y=0,rows-1 do
      local cidx = x*rows+y
      data.modch[cidx]   = modtypes[x]
      data.modtxt1[cidx] = '.'
      data.modtxt2[cidx] = '.'      
    end
  end
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
  data.delay1 = {}
  data.delay2 = {}    
  data.legato = {}
  self.legato = {}
  data.fx1 = {}
  data.fx2 = {}
  data.mod1 = {}
  data.mod2 = {}
  data.mod3 = {}
  data.mod4 = {}
  local channels = self.channels
  local rows = self.rows
  for x=0,channels-1 do
    for y=0,rows-1 do
      data.note[rows*x+y]   = nil
      data.text[rows*x+y]   = '...'
      data.vel1[rows*x+y]   = '.'
      data.vel2[rows*x+y]   = '.'
      if ( self.showDelays[x] == 1 ) then
        data.delay1[rows*x+y] = '.'
        data.delay2[rows*x+y] = '.'        
      end
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
  
  for y=0,rows-1 do
    data.mod1[y] = "."
    data.mod2[y] = "."
    data.mod3[y] = "."
    data.mod4[y] = "."            
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
        if ( tracker.debug == 1 ) then
          print( "Removing legato." )
          print( "Shortening note with pitch " .. self.pitchTable[pitch] )
        end
        
        reaper.MIDI_SetNote(self.take, noteOfInterest, nil, nil, nil, endppqpos - tracker.magicOverlap, nil, nil, nil, true)
      end
    end
    if ( not skipMarker ) then
      self:SAFE_DeleteText(self.take, idx)
    end
    
    self.legato[row] = -1
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
    
    -- This is a temporary flag to indicate legato; but which has no reference yet
    self.legato[row] = 5000
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

-------------------
-- Create automation items for enabled parameters
-------------------
function tracker:createDefaultEnvelopes()
  local fxcnt = reaper.TrackFX_GetCount(self.track)
  for fidx = 0,fxcnt-1 do
    local pcnt = reaper.TrackFX_GetNumParams(self.track, fidx)
    for pidx = 0,pcnt-1 do
      local retval, name = reaper.TrackFX_GetParamName(self.track, fidx, pidx, '')
      local envelope = reaper.GetFXEnvelope(self.track, fidx, pidx, false)
    end
  end
end

-------------------
-- Find automation item associated with my take
-------------------
tracker.automationeps = 1e-4
function tracker:findMyAutomation(envelope)
  local eps = tracker.automationeps
  for i=0,reaper.CountAutomationItems(envelope) do
    local pos = reaper.GetSetAutomationItemInfo(envelope, i, "D_POSITION", 1, false)
    local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", 1, false)
    if ( ( self.position > ( pos - eps ) ) and ( self.position < ( pos + eps ) ) ) then
      if ( ( self.length > ( len - eps ) ) and ( self.length < ( len + eps ) ) ) then
        --local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", self.length, true)
        return i
      end
    end
  end
  return nil
end

-------------------
-- Delete specific envelope point
-------------------
function tracker:deleteEnvPt(fxid, t1, t2)
  local fx      = self.fx
  local envidx  = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  local tstart  = t1 + self.position
  local tend
  if ( t2 ) then
    tend  = t2 + self.position
  else
    tend  = tstart + self:toSeconds(1)
  end
  
  reaper.DeleteEnvelopePointRangeEx(envidx, autoidx, tstart - tracker.enveps, tend - tracker.enveps)
end

-------------------
-- Insert operation on envelope
-------------------
function tracker:insertEnvPt(fxid, t1)
  local fx      = self.fx
  local envidx  = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]

  local npoints
  if ( self.automationBug == 1 ) then
    npoints = 2 * self.rows
  else
    npoints = reaper.CountEnvelopePointsEx(envidx, autoidx)
  end

  -- Remove the ones that are going to fall off
  self:deleteEnvPt(fxid, self.length-self:toSeconds(1)-tracker.enveps)
  reaper.Envelope_SortPointsEx(envidx, autoidx)

  -- Shift all envelope points by one time unit
  local abstime = t1 + self.position + self.length - tracker.enveps
  local ptidx
  for ptidx=0,npoints do
    local retval, envtime = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
    if ( envtime >= abstime ) then
      envtime = envtime + self:toSeconds(1)
      reaper.SetEnvelopePointEx(envidx, autoidx, ptidx, envtime, nil, nil, nil, nil, true)
    end
  end
  
  reaper.Envelope_SortPointsEx(envidx, autoidx)
end

-------------------
-- Backspace operation on envelope
-------------------
function tracker:backspaceEnvPt(fxid, t1)
  local fx      = self.fx
  local envidx  = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]

  self:deleteEnvPt(fxid, t1)

  local npoints
  if ( self.automationBug == 1 ) then
    npoints = 2 * self.rows
  else
    npoints = reaper.CountEnvelopePointsEx(envidx, autoidx)
  end

  -- Shift all envelope points by one time unit
  local abstime = t1 + self.position + self.length - self.enveps
  for ptidx=0,npoints do
    local retval, envtime = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
    -- TO DO: Investigate the t1==0. It's a temporary hack which seems to solve a backspace issue
    -- that happens only for the first row of a pattern. Need to look closer into what happens there.
    if ( envtime > ( abstime + self:toSeconds(1) ) or ( t1 == 0 ) ) then
      envtime = envtime - self:toSeconds(1)
      reaper.SetEnvelopePointEx(envidx, autoidx, ptidx, envtime, nil, nil, nil, nil, true)
    end
  end
  
  reaper.Envelope_SortPointsEx(envidx, autoidx)
end

-------------------
-- Get envelope index from time
-------------------
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

-----------------------
-- Insert MIDI CC event
-----------------------
function tracker:insertCCPt( row, modtype )
  local rowsize = self:rowToPpq(1)
  local ppqStart = self:rowToPpq(row)
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=ccevtcntOut,0,-1 do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
    if ( ppqpos >= ppqStart ) then
      local moveIt = true
      if ( modtype and ( modtype ~= msg2 ) ) then
        moveIt = false
      end
      
      if ( moveIt ) then
        reaper.MIDI_SetCC(self.take, i, nil, nil, ppqpos + rowsize, nil, nil, nil, nil, true)  
      end
    end
  end
  self:deleteCC_range( self.rows )
end

-----------------------
-- Backspace MIDI CC event
-----------------------
function tracker:backspaceCCPt( row, modtype )
  local rowsize = self:rowToPpq(1)
  local ppqStart = self:rowToPpq(row)
  self:deleteCC_range( row, row + 1, modtype )
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=ccevtcntOut,0,-1 do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)   
    
    if ( ppqpos >= ppqStart ) then
      local moveIt = true
      if ( modtype and ( modtype ~= msg2 ) ) then
        moveIt = false
      end
      if ( moveIt == true ) then
        reaper.MIDI_SetCC(self.take, i, nil, nil, ppqpos - rowsize, nil, nil, nil, nil, true)
      end
    end
  end
end


-------------------
-- Remove MIDI CC range
-------------------
function tracker:deleteCC_range(rowstart, rowend, modtype)
  local ppqStart = self:rowToPpq(rowstart)
  local ppqEnd = self:rowToPpq( rowend or rowstart + 1 ) - self.eps
  
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=ccevtcntOut,0,-1 do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
    if ( ppqpos >= ppqStart and ppqpos < ppqEnd ) then
      local deleteIt = true
      if ( modtype and ( modtype ~= msg2 ) ) then
        deleteIt = false
      end
    
      if ( deleteIt == true ) then
        reaper.MIDI_DeleteCC(self.take, i)
      end
    end
  end
end

-------------------
-- Grab MIDI CC point
-------------------
function tracker:getCC( row, modtype )
  local ppqStart = self:rowToPpq(row)
  local ppqEnd = self:rowToPpq( row + 1 ) - self.eps
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,ccevtcntOut do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
    if ( ppqpos >= ppqStart and ppqpos < ppqEnd ) then
      local fetchIt = true
      if ( modtype and ( modtype ~= msg2 ) ) then
        fetchIt = false
      end
      
      if ( fetchIt == true ) then
        return msg2, msg3, 1
      end
    end
  end
  
  return modtype or self.lastmodtype, self.lastmodval
end

-------------------
-- Add MIDI CC point
-------------------
function tracker:addCCPt(row, modtype, value)
  self:deleteCC_range(row)
  local ppqStart = self:rowToPpq(row)
  reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 176, 0, modtype, value)
end

-------------------
-- Add MIDI CC point to specific type
-------------------
function tracker:addCCPt_channel(row, modtype, value)
  self:deleteCC_range(row, row + 1, modtype)
  local ppqStart = self:rowToPpq(row)
  reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 176, 0, modtype, value)
end

-------------------
-- Add envelope point
-------------------
function tracker:addEnvPt(fxid, time, value, shape)
  local fx = self.fx
  local envidx = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  local signed = fx.signed[fxid]

  if ( not envidx or not autoidx ) then
    print("FATAL: FX channel does not exist?")
    return
  end
  
  local val = value or 5
  local envShape = shape or 0
  local envTension = nil
  
  -- The 0.5 shift is to get 80 at the true center (analogously to buzz)
  -- even though 256 values do not have an actual center. This results in
  -- having to deal with val == 1 separately as well.
  if ( signed == 1 ) then
    if ( val < 1 ) then
      val = (val - 0.5/255)*2.0 - 1.0
    end
  end
  
  ptidx, loc = self:getEnvIdx(fxid, time)
  if ( ptidx ) then
    reaper.SetEnvelopePointEx(envidx, autoidx, ptidx, loc, val, envShape, envTension, false, true)
  else
    reaper.InsertEnvelopePointEx(envidx, autoidx, loc, val, envShape, 0.5, false, true)     
  end
  
  reaper.Envelope_SortPointsEx(envidx, autoidx)
end
---------------------------------

-------------------
-- Get envelope data from time
-------------------
function tracker:getEnvPt(fxid, time)
  local fx = self.fx
  local envidx = fx.envelopeidx[fxid]
  local autoidx = fx.autoidx[fxid]
  local signed = fx.signed[fxid]
  
  ptidx = self:getEnvIdx(fxid, time)
  if ( ptidx ) then
    local retval, atime, value, shape, tension = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
    
    -- The 0.5 shift is to get 80 at the true center (analogously to buzz)
    -- even though 256 values do not have an actual center. This results in
    -- having to deal with val == 1 separately as well.
    if ( signed == 1 ) then
      if ( value < 1 ) then
        value = value*0.5 + 0.5 + 0.5/255
      end
    end
    
    return atime, value, shape, tension, ptidx
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
    local signed = {}
    local names = {}
  
    local cnt = reaper.CountTrackEnvelopes(self.track)
    local autoidx = nil
    for i = 0,cnt-1 do;
      local envelope = reaper.GetTrackEnvelope(self.track, i)
      local retval, name = reaper.GetEnvelopeName(envelope, '')
      
      autoidx = self:findMyAutomation( envelope )
      if ( not autoidx ) then
        autoidx = reaper.InsertAutomationItem(envelope, -1, self.position, self.length)
        
        -- Consolidate all automation curves into this one and clean up
      end     
      
      -- Check the scaling of the envelope
      --number reaper.ScaleFromEnvelopeMode(integer scaling_mode, number val)
      local retval, str = reaper.GetEnvelopeName(envelope, ' ')
      if ( tracker.signed[str] ) then
        signed[#signed + 1] = 1
      else
        signed[#signed + 1] = 0
      end
      
      envelopeidxs[#envelopeidxs + 1] = envelope
      autoidxs[#autoidxs + 1] = autoidx
      names[#names + 1] = name
    end
    
    self.fx.envelopeidx = envelopeidxs
    self.fx.autoidx     = autoidxs
    self.fx.names       = names
    self.fx.signed      = signed
  end 
end

-------------------
-- Set the envelope text in the tracker view
-------------------
function tracker:updateEnvelopes()
  local rows = self.rows
  local data = self.data
  local str =  string.format('%2X', math.floor(97) )

  if ( self.fx.names ) then
    for ch=1,#self.fx.names do
      for i=0,rows-1 do
        local atime, value, shape, tension = self:getEnvPt(ch, self:toSeconds(i))       
        
        if ( value ) then        
          local hexEnv = string.format('%02X', self:floatToByte(value) )          
          data.fx1[rows*ch+i] = hexEnv:sub(1,1)
          data.fx2[rows*ch+i] = hexEnv:sub(2,2)
        end
      end
    end
  end
end

local stringbuffer = "                                                                               "

function tracker:addCol()
  if ( self.showMod == 1 ) then
    if ( self.modMode == 1 ) then
      tracker.renaming = 2
      tracker.newCol = ''
    end
  end
end

function tracker:createCCCol()
  local data = self.data
  
  if ( not data.modtypes ) then
    data.modtypes = {}
  end
  
  local modtypes = data.modtypes
  if ( pcall( function () tonumber( tracker.newCol ) end ) ) then
    local newCol = tonumber( tracker.newCol )
    if ( newCol and ( newCol > -1 ) ) then
      modtypes[#modtypes+1] = newCol
      self:storeOpenCC()
    end
  else
    print("Passed invalid number")
  end
end

function tracker:remCol()
  if ( self.showMod == 1 ) then
    if ( self.modMode == 1 ) then  
      local data = self.data
      local modtypes = data.modtypes  
      local ftype, chan, row = self:getLocation()
      local modtype, val = self:getCC( self.ypos - 1, modtypes[chan] )    
    
      for i,v in pairs( modtypes ) do
        if ( v == modtype ) then
          self:deleteCC_range(0, self.rows, modtype)
          modtypes[i] = nil
        end
      end
  
      self:storeOpenCC()
      self.hash = 0
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
    if ( self.debug == 1 ) then
      print( "Updating the grid ..." )
    end
  
    self:getRowInfo()
    self:getSettings()
    self:getTakeEnvelopes()
    self:initializeGrid()
    self:updateEnvelopes()
    
    self:updateNames()
    
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
        ---------------------------------------------
        -- OFF markers
        ---------------------------------------------
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
       
      ---------------------------------------------
      -- CC EVENTS
      ---------------------------------------------
      if ( self.showMod == 1 ) then
        if ( self.modMode == 1 ) then
          local all = self:getOpenCC()
          for i=0,ccevtcntOut do
            local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
            all[msg2] = 1
          end
          all[0] = nil
          local indices = {}
          for i in pairs(all) do
            if ( all[i] == 1 ) then
              table.insert(indices, i)
            end
          end
          table.sort(indices)
          local modtypes = {}
          for i,v in pairs(indices) do
            if( i > 0 ) then
              modtypes[#modtypes+1] = v
            end
          end
          if ( #modtypes > 0 ) then
            tracker:initializeModChannels(modtypes)
            for i=0,ccevtcntOut do
              local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
              self:assignCC2( ppqpos, msg2, msg3 )
            end
            self:storeOpenCC()
          else
            self:storeSettings()
          end
        end
        if ( self.modMode == 0 ) then
          for i=0,ccevtcntOut do
            local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
            self:assignCC( ppqpos, msg2, msg3 )
          end
        end
      end
    
      ---------------------------------------------
      -- NOTES
      ---------------------------------------------
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
            if ( self.debug == 1 ) then
              print("Warning: A note that should have been assigned was shifted")
            end
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
  
  self:linkData()
  self:updatePlotLink()
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
    
      if ( tracker.armed == 1 ) then
        tracker:stopNote()
        tracker:disarm()
      end
    
      self.take = take
      self.track = reaper.GetMediaItem_Track(self.item)
      -- Store note hash (second arg = notes only)
      self.hash = reaper.MIDI_GetHash( self.take, false, "?" )
      self.newRowPerQn = self:getResolution()
      self:update()
      
      if ( self.cfg.alwaysRecord == 1 ) then
        tracker:arm()
      end
      
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
  
  if ( self.cfg.followSelection == 1 ) then
    tracker:grabActiveItem()
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

------------------
-- Clear the data in a block
------------------
function tracker:clearBlock(incp)
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local notes     = self.notes
  local noteGrid  = data.note
  local noteStart = data.noteStart
  local rows      = self.rows
  local singlerow = self:rowToPpq(1)
  local cp        = incp or self.cp

  if ( self.debug == 1 ) then
    print( "Clearing block [" .. cp.xstart .. ", " .. cp.xstop .. "] [" .. cp.ystart .. ", " .. cp.ystop .. "]" );
  end

  local xstart = cp.xstart
  local xstop = cp.xstop  
  if ( cp.all == 1 ) then
    xstart = 1
    xstop = tracker.displaychannels
  end

  -- Cut out the block. Note that this creates 'stops' at the start of the block
  local legatoDone = 0 
  for jx = xstart, xstop do
    local chan = idxfields[ jx ]
    if ( datafields[jx] == 'text' ) then 
      for jy = cp.ystart, cp.ystop do
        -- If we are a legato note, make sure that the previous one gets shortened
        -- otherwise things won't fit.
        if ( legatoDone == 0 and chan == 1 and self.legato[jy] and self.legato[jy-1] > -1 ) then
          tracker:deleteLegato( jy-1, 1 )
          legatoDone = 1
        end
        self:deleteNoteSimple( chan, jy - 1 )
      end
    elseif ( datafields[jx] == 'legato' ) then
      for jy = cp.ystart, cp.ystop do
        self:deleteLegato( jy-1 )
      end
    elseif ( ( datafields[jx] == 'fx1' ) or ( datafields[jx] == 'fx2' ) ) then
      self:deleteEnvPt(chan, self:toSeconds(cp.ystart-1), self:toSeconds(cp.ystop-1)+tracker.eps )
    elseif ( ( datafields[jx] == 'mod1' ) or ( datafields[jx] == 'mod2' ) or ( datafields[jx] == 'mod3' ) or ( datafields[jx] == 'mod4' ) ) then
      self:deleteCC_range( cp.ystart-1, cp.ystop )
    elseif ( ( datafields[jx] == 'modtxt1' ) or ( datafields[jx] == 'modtxt2' ) ) then
      self:deleteCC_range( cp.ystart-1, cp.ystop, data.modtypes[chan] )
    end
  end
  
  self:deleteNow()
  self:forceUpdate()
  
  -- This has to be refetched since the array gets remade completely
  noteGrid = self.data.note
  
  -- Make sure that there are no spurious note offs in the deleted region afterwards
  -- These are removed so that mendBlock can grow into this region
  --[[--
  for jx = cp.xstart, cp.xstop do
    local chan = idxfields[ jx ]
    if ( datafields[jx] == 'text' ) then
      for jy = cp.ystart, cp.ystop do
        if ( self.debug == 1 ) then
          self:printNote(chan, jy - 1)
        end
        noteGrid[chan * rows + jy - 1] = nil
      end
    end
  end
  --]]--
end

------------------
-- Mend block (check if notes at top can be extended)
------------------
function tracker:mendBlock()
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local notes     = self.notes
  local txtList   = self.txtList
  local rows      = self.rows
  local singlerow = self:rowToPpq(1)
  local cp        = self.cp 
  
  local xstart = cp.xstart
  local xstop = cp.xstop  
  if ( cp.all == 1 ) then
    xstart = 1
    xstop = tracker.displaychannels
  end
  
  for jx = xstart, xstop do
    local chan = idxfields[ jx ]
    if ( cp.ystart > 1 ) then
      if ( datafields[jx] == 'text' ) then
        local elong = noteGrid[chan*rows + cp.ystart-2]
        self:checkNoteGrow(notes, noteGrid, rows, chan, cp.ystart-1, singlerow, elong, nil, 1)
      end
    end
  end
end

-- A list of the channels is maintained so that we can verify that the paste
-- list is compatible.
function tracker:addChannelToClipboard(clipboard, channel)
  if ( not clipboard.channels ) then
    clipboard.channels = {}
  end
  clipboard.channels[#clipboard.channels + 1] = {}
  clipboard.channels[#clipboard.channels].fieldtype = channel
end

function tracker:addDataToClipboard(clipboard, data)
  local channel = clipboard.channels[#clipboard.channels]
  if ( not channel.data ) then
    channel.data = {}
  end
  channel.data[#channel.data + 1] = deepcopy(data)
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tracker:tab()
  local master = self.link.master
  self.xpos = self.xpos + 1
  while ( ( self.xpos < self.max_xpos ) and ( master[self.xpos] == 0 ) ) do
    self.xpos = self.xpos + 1
  end
end

function tracker : shifttab()
  local master = self.link.master
  self.xpos = self.xpos - 1
  while ( ( self.xpos > 0 ) and ( master[self.xpos] == 0 ) ) do
    self.xpos = self.xpos - 1
  end
end

function tracker:getAdvance( chtype, ch, extraShift )
  local hasDelay = 0
  if ( chtype == 'text' ) then
    return 3 + (extrashift or 0)
  elseif ( chtype == 'vel1' ) then
    return 2 + (extrashift or 0)
  elseif ( chtype == 'vel2' ) then
    return 1 + (extrashift or 0)
  elseif ( chtype == 'legato' ) then
    return 1
  elseif ( chtype == 'fx1' ) then
    return 2
  elseif ( chtype == 'fx2' ) then
    return 1
  elseif ( chtype == 'mod1' ) then
    return 4
  elseif ( chtype == 'mod2' ) then
    return 3
  elseif ( chtype == 'mod3' ) then
    return 2
  elseif ( chtype == 'mod4' ) then
    return 1    
  elseif ( chtype == 'modtxt1' ) then
    return 2
  elseif ( chtype == 'modtxt2' ) then
    return 1    
  elseif ( chtype == 'delay1' ) then
    return 2
  elseif ( chtype == 'delay2' ) then
    return 1
  else
    return 1
  end
end

tracker.colgroups = {}
tracker.colgroups['mod1'] = { 'mod1', 'mod2', 'mod3', 'mod4' }
tracker.colgroups['mod2'] = { 'mod1', 'mod2', 'mod3', 'mod4' }
tracker.colgroups['mod3'] = { 'mod1', 'mod2', 'mod3', 'mod4' }
tracker.colgroups['mod4'] = { 'mod1', 'mod2', 'mod3', 'mod4' }
tracker.colgroups['modtxt1'] = { 'modtxt1', 'modtxt2' }
tracker.colgroups['modtxt2'] = { 'modtxt1', 'modtxt2' }
tracker.colgroups['text'] = { 'text', 'vel1', 'vel2' }
tracker.colgroups['vel1'] = { 'text', 'vel1', 'vel2' }
tracker.colgroups['vel2'] = { 'text', 'vel1', 'vel2' }
tracker.colgroups['fx1'] = { 'fx1', 'fx2' }
tracker.colgroups['fx2'] = { 'fx1', 'fx2' }
tracker.colgroups['legato'] = { 'legato' }
tracker.colref = {}
tracker.colref['mod1'] = 0
tracker.colref['mod2'] = -1
tracker.colref['mod3'] = -2
tracker.colref['mod4'] = -3
tracker.colref['modtxt1'] = 0
tracker.colref['modtxt2'] = -1
tracker.colref['text'] = 0
tracker.colref['vel1'] = -1
tracker.colref['vel2'] = -2
tracker.colref['fx1'] = 0
tracker.colref['fx2'] = -1
tracker.colref['legato'] = 0

function tracker:pasteClipboard()
  local clipboard = self.clipboard
  
  if ( not clipboard ) then
    return
  end
  
  local channels  = clipboard.channels
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local refrow    = self.ypos - 1
  local refppq    = self:rowToPpq( self.ypos - 1 ) - clipboard.refppq
  
  if ( not clipboard ) then
    return
  end
  
  -- Check whether we have compatible fields
  local jx = self.xpos
  for i = 1,#channels do
    local chan = idxfields[jx]
    local chtype = datafields[jx]
    
    local found = false
    for j,v in pairs( tracker.colgroups[chtype] ) do
      found = found or ( channels[i].fieldtype == v )
    end
    
    if ( found == false ) then
      return
    end
    
    jx = jx + self:getAdvance(chtype)
  end

  -- Determine the shift we need to apply to the current position to get to the start
  -- of the clipboard
  local cpShift = self.colref[ datafields[self.xpos] ]
  local region = self.clipboard.region 
  region.xstop = self.xpos + (region.xstop - region.xstart) + cpShift
  region.ystop = self.ypos + (region.ystop - region.ystart)
  region.xstart = self.xpos + cpShift
  region.ystart = self.ypos
  self:clearBlock(region)
   
  -- Grab references here, since clearblock calls update and regenerates them
  local data      = self.data
  local noteGrid  = data.note
  local notes     = self.notes
  local rows      = self.rows
  
  -- We should be able to paste the contents now
  local jx = self.xpos
  for i = 1,#channels do
    local chan = idxfields[jx]
    local chtype = datafields[jx]
    local firstNote = 1
    if ( channels[i].data ) then
      for j = 1,#(channels[i].data) do
        local data = channels[i].data[j]
          if ( data[1] == 'NOTE' ) then
            -- 'NOTE' (1), pitch (2), velocity (3), startppq (4), endppq (5)
            local note = noteGrid[chan*rows+self.ypos-1]
            if ( ( firstNote == 1 ) and ( self.ypos > 0 ) and ( note and ( note > -1 ) ) ) then
              -- If the location where the paste happens started with a note, then shorten it!
              local pitch, vel, startppqpos, endppqpos = table.unpack( notes[ note ] )
              local resize = self:ppqToRow(data[4]+refppq-endppqpos)
              if ( resize ~= 0 ) then
                self:resizeNote(chan, self:ppqToRow(startppqpos), resize )
              end
              firstNote = 0
            end
            self:addNotePpq(data[4] + refppq, data[5] + refppq, chan, data[2], data[3])
            firstNote = 0
          elseif ( data[1] == 'OFF' ) then
            -- 'OFF' symbol
            local note = noteGrid[chan*rows+self.ypos-1]
            if ( ( firstNote == 1 ) and ( self.ypos > 0 ) and ( note and ( note > -1 ) ) ) then
              -- If the location where the paste happens started with a note, then shorten it!
              local pitch, vel, startppqpos, endppqpos = table.unpack( notes[ note ] )
              self:resizeNote(chan, self:ppqToRow(startppqpos), self:ppqToRow(data[2]+refppq-endppqpos) )
              firstNote = 0
            else
              -- Otherwise, make it an explicit off
              self:addNoteOFF(data[2] + refppq, chan)
              firstNote = 0
            end
          elseif ( data[1] == 'LEG' ) then
            -- 'LEG', ppqposition
            self:addLegato( self:ppqToRow(data[2] + refppq) )
          elseif ( data[1] == 'FX' ) then
            -- 'FX', ppqposition   
            self:addEnvPt( chan, self:ppqToSeconds(data[2] + refppq), data[3], data[4] )
          elseif ( data[1] == 'CC' ) then
            -- 'MOD'
            self:addCCPt( data[2]+refrow, data[3], data[4] )
          elseif ( data[1] == 'CCC' ) then
            -- 'MOD'
            local targetMod = self.data.modtypes[chan]
            self:addCCPt_channel( data[2]+refrow, targetMod, data[3] )            
        else
          print( "FATAL ERROR, unknown field in clipboard" )
        end
      end
    end
    jx = jx + self:getAdvance(chtype)
  end
end

-- Copy things to clipboard
-- Note that if a block starts with an implicit OFF symbol (coming from a previous note outside the block)
-- then this is converted to an explicit OFF. Note that notes that overhang the end are cropped to the block.
function tracker:copyToClipboard()

  local newclipboard = {}
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart
  local legato    = self.legato
  local notes     = self.notes
  local txtList   = self.txtList
  local rows      = self.rows
  local cp        = self.cp
  
  newclipboard.refppq = self:rowToPpq( cp.ystart - 1 )
  local maxppq    = self:rowToPpq(cp.ystop)

  local xstart = cp.xstart
  local xstop = cp.xstop  
  if ( cp.all == 1 ) then
    xstart = 1
    xstop = tracker.displaychannels
  end

  -- All we should be copying is note starts and note stops
  local jx = xstart
  while ( jx <= xstop ) do
    self:addChannelToClipboard( newclipboard, datafields[jx] )
    local chan = idxfields[jx]
    local chtype = datafields[jx]  
    local firstNote = 1
    for jy = cp.ystart, cp.ystop do
      if ( ( chtype == 'text' ) or ( chtype == 'vel1' ) or ( chtype == 'vel2' ) ) then
        local loc = chan * rows + jy-1
        if ( noteStart[ loc ] ) then
          -- A note
          local pitch, vel, startppqpos, endppqpos = table.unpack( notes[ noteStart[loc] ] )
          
          -- Store the legato state of the note that we are copying
          if ( chan == 1 ) then
            local lpos = self:ppqToRow(endppqpos)
            if ( legato[lpos] > -1 ) then
              if ( noteStart[rows+lpos] ) then
                -- Undo the legato
                endppqpos = endppqpos - self.magicOverlap
              end
            end
          end
          if ( endppqpos > maxppq ) then
            endppqpos = maxppq
          end
          self:addDataToClipboard( newclipboard, { 'NOTE', pitch, vel, startppqpos, endppqpos } )
          firstNote = 0
        elseif ( noteGrid[ loc ] ) then
          -- Grab OFF locations
          if ( noteGrid[ loc ] < -1 ) then
            -- An explicit OFF symbol. Store it!
            local offidx = self:gridValueToOFFidx( noteGrid[loc] )
            self:addDataToClipboard( newclipboard, { 'OFF', txtList[ offidx ][1] } )
            firstNote = 0
          elseif( noteGrid[ loc ] == -1 ) then
            if ( firstNote == 1 ) then
              -- An implicit OFF symbol => Grab note before this
              local pitch, vel, startppqpos, endppqpos = table.unpack( notes[ noteGrid[loc-1] ] )
              self:addDataToClipboard( newclipboard, { 'OFF', endppqpos } )
              firstNote = 0
            end
          end
        end
      elseif ( chtype == 'legato' ) then
          local lpos = jy-1
          if ( legato[lpos] > -1 ) then
            self:addDataToClipboard( newclipboard, { 'LEG', txtList[ legato[lpos] ][1] } )
          end
      elseif ( chtype == 'fx1' or chtype == 'fx2' ) then
        local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(jy-1))
        if ( atime ) then
          local mPos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
          atime = atime - mPos
          self:addDataToClipboard( newclipboard, { 'FX', self:secondsToPpq( atime ), env, shape, tension } )
        end
      elseif ( chtype == 'mod1' or chtype == 'mod2' or chtype == 'mod3' or chtype == 'mod4' ) then
        local modtype, val, gotvalue = tracker:getCC( jy-1 )
        if ( gotvalue ) then
          self:addDataToClipboard( newclipboard, { 'CC', jy-1-cp.ystart+1, modtype, val } )
        end
      elseif ( chtype == 'modtxt1' or chtype == 'modtxt2' ) then
        local mtype = data.modtypes[chan]
        local modtype, val, gotvalue = tracker:getCC( jy-1, mtype )
        if ( gotvalue ) then
          self:addDataToClipboard( newclipboard, { 'CCC', jy-1-cp.ystart+1, val } )
        end        
      end
    end
    
    jx = jx + self:getAdvance(chtype)
  end
  
  self.clipboard = newclipboard
  self.clipboard.region = deepcopy( cp )
end

function tracker:printNote(chan, row)
  if ( tracker.debug == 1 ) then
    local data      = self.data
    local noteGrid  = data.note
    local notes     = self.notes
    local rows      = self.rows
    local noteOfInterest = noteGrid[chan*rows+row]
    if ( noteOfInterest ) then
      if ( noteOfInterest > -1 ) then
        local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteOfInterest] )
        print( "Channel " .. chan .. " Row " .. row .. " Pitch " .. self.pitchTable[pitch] )
      elseif( noteOfInterest == -1 ) then
        print( "Channel " .. chan .. " Row " .. row .. " OFF" )    
      elseif( noteOfInterest < -1 ) then
        print( "Channel " .. chan .. " Row " .. row .. " OFC" )          
      end
    else
        print( "Channel " .. chan .. " Row " .. row .. " EMPTY" )              
    end
  end
end

------------------
-- Delete block
------------------
function tracker:deleteBlock()
  self:clearBlock()
  self:mendBlock()
end

------------------
-- Force the note grids to update
------------------
function tracker:forceUpdate()
  self.hash = 0
  self:update()
end

function tracker:interpolate()
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart  
  local notes     = self.notes
  local txtList   = self.txtList
  local rows      = self.rows
  local cp        = self.cp
  
  if ( cp.xstart == cp.xstop ) then
    local jx = cp.xstart
    -- Notes
    if ( datafields[jx] == 'text' ) then    
      local chan    = idxfields[ jx ]
      local nStart  = noteStart[ chan*rows + cp.ystart - 1 ]
      local nEnd    = noteStart[ chan*rows + cp.ystop - 1 ]
      
      if ( nStart and nEnd ) then
        local startpitch, startvel = table.unpack( notes[ nStart ] )
        local endpitch, endvel     = table.unpack( notes[ nEnd ] )
        local nR = cp.ystop - cp.ystart

        for jy = cp.ystart, cp.ystop-1 do
          self:deleteNoteSimple(chan, jy - 1)
        end
        self:deleteNow()
        
        -- Force a grid update since all the note locations are invalid now
        self:forceUpdate()

        idx = 0
        notelen = 1
        for jy = cp.ystart, cp.ystop-1 do
          local loc   = chan * rows + jy
          local pitch = math.floor( (endpitch-startpitch) * (idx / nR) + startpitch ) 
          local vel   = math.floor( (endvel-startvel) * (idx / nR) + startvel )
          self:addNote( jy - 1, jy, chan, pitch, vel)         
          idx = idx + 1
        end
      end
    end
    
    if ( datafields[jx] == 'fx1' or datafields[jx] == 'fx2' ) then
      local chan        = idxfields[ jx ]
      local startidx    = cp.ystart - 1
      local endidx      = cp.ystop - 1
         
      local time, startenv, startshape, starttension = tracker:getEnvPt(chan, self:toSeconds(startidx))
      local time, endenv,   endshape,   endtension   = tracker:getEnvPt(chan, self:toSeconds(endidx))            
      if ( startenv and endenv and startidx and endidx ) then
        local dydx = (endenv-startenv)/(endidx-startidx)
        self.hash = 0
        local idx = 0
        for jy = startidx,endidx do
          self:addEnvPt( chan, self:toSeconds(jy), dydx * idx + startenv, endshape )
          idx = idx + 1
        end
      end
    elseif ( datafields[jx] == 'mod1' or datafields[jx] == 'mod2' or datafields[jx] == 'mod3' or datafields[jx] == 'mod4' ) then
      local startidx    = cp.ystart - 1
      local endidx      = cp.ystop - 1
      local starttype, startval = tracker:getCC( startidx )
      local endtype,   endval   = tracker:getCC( endidx )      
      if ( startval and endval and startidx and endidx ) then
        local dydx = (endval-startval)/(endidx-startidx)
        self.hash = 0
        local idx = 0
        for jy = startidx,endidx do
          self:addCCPt( jy, starttype, math.floor( dydx * idx + startval ) )
          idx = idx + 1
        end
      end
    elseif ( datafields[jx] == 'modtxt1' or datafields[jx] == 'modtxt2' ) then
      local chan        = idxfields[ jx ]
      local modtype     = self.data.modtypes[chan]
      local startidx    = cp.ystart - 1
      local endidx      = cp.ystop - 1
      local starttype, startval = tracker:getCC( startidx, modtype )
      local endtype,   endval   = tracker:getCC( endidx,   modtype )     
      if ( startval and endval and startidx and endidx ) then
        local dydx = (endval-startval)/(endidx-startidx)
        self.hash = 0
        local idx = 0
        for jy = startidx,endidx do
          self:addCCPt_channel( jy, starttype, math.floor( dydx * idx + startval ) )
          idx = idx + 1
        end
      end
    end
  end
end

function tracker:resetShiftSelect()
  local cp = self.cp
  self:forceCursorInRange()
  if ( cp.lastShiftCoord ) then
    cp.lastShiftCoord = nil
    self:resetBlock()
  end
end

function tracker:dragBlock(cx, cy)
  local cp = self.cp
  local xp, yp
  if ( not cx ) then
    xp = tracker.xpos
    yp = tracker.ypos
  else
    xp = cx
    yp = cy
  end
  
  if ( not cp.lastShiftCoord ) then
    cp.lastShiftCoord = {}
    cp.lastShiftCoord.x = xp
    cp.lastShiftCoord.y = yp
  end
  local xstart, xend, ystart, yend
  if ( xp > cp.lastShiftCoord.x ) then
    xstart  = cp.lastShiftCoord.x
    xend    = xp
  else
    xstart  = xp
    xend    = cp.lastShiftCoord.x
  end
  if ( yp > cp.lastShiftCoord.y ) then
    ystart  = cp.lastShiftCoord.y
    yend    = yp
  else
    ystart  = yp
    yend    = cp.lastShiftCoord.y
  end
  
  cp.xstart  = xstart
  cp.xstop   = xend
  cp.all     = 0
  cp.ystart  = ystart
  cp.ystop   = yend
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
  
  cp.lastShiftCoord = nil
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
  
  cp.lastShiftCoord = nil
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
  self:copyToClipboard()
  self:clearBlock()
  self:mendBlock()
end

function tracker:pasteBlock()
  self:pasteClipboard()
  self:resetBlock()
end

function tracker:copyBlock()
  self:copyToClipboard()
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

local function mouseStatus()
  local leftbutton  = gfx.mouse_cap & 1
  local rightbutton = gfx.mouse_cap & 2
  if ( rightbutton > 0 ) then
    rightbutton = 1
  end
  return leftbutton, rightbutton
end

function tracker:setOutChannel( ch )
  if not pcall( self.testGetTake ) then
    return false
  end

  if ( self.item ) then
    local retval, str = reaper.GetItemStateChunk( self.item, "zzzzzzzzz")

    -- Are we setting a channel?
    if ( ch > 0 ) then
      if ( not string.find( str, "OUTCH" ) ) then
        local strOut = string.gsub(str, "<SOURCE MIDI", "<SOURCE MIDI\nOUTCH "..ch)
        reaper.SetItemStateChunk( self.item, strOut )
      else
        local strOut = string.gsub(str, "\nOUTCH [-]*%d+", "\nOUTCH "..ch)
        reaper.SetItemStateChunk( self.item, strOut )
      end
    else
      if ( string.find( str, "OUTCH" ) ) then
        local strOut = string.gsub(str, "\nOUTCH [-]*%d+", "")
        reaper.SetItemStateChunk( self.item, strOut )
      end
    end
  end
end

function tracker:arm()
  reaper.ClearAllRecArmed()
  self.oldarm     = reaper.GetMediaTrackInfo_Value(self.track, "I_RECARM")  
  self.oldinput   = reaper.GetMediaTrackInfo_Value(self.track, "I_RECINPUT") 
  self.oldmonitor = reaper.GetMediaTrackInfo_Value(self.track, "I_RECMON")
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECARM", 1)
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECMON", 1)  
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECINPUT", 6112)
  self.armed = 1
end

function tracker:checkArmed()
  if ( self.armed == 1 ) then
    local recinput = reaper.GetMediaTrackInfo_Value(self.track, "I_RECINPUT")
    local recarm = reaper.GetMediaTrackInfo_Value(self.track, "I_RECARM")
    local recmonitor = reaper.GetMediaTrackInfo_Value(self.track, "I_RECMON")
    local ready = ( recinput == tracker.playNoteCh ) and ( recarm == 1 ) and ( recmonitor == 1 )
    if ( not ready ) then
      self.armed = 0
    end
  end
end

function tracker:disarm()
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECARM",   self.oldarm)
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECINPUT", self.oldinput)
  reaper.SetMediaTrackInfo_Value(self.track, "I_RECMON",   self.oldmonitor)
  self.armed = 0
  self.hash = 0
  self:update()
end

function tracker:playNote(chan, pitch, vel)
  self:checkArmed()
  if ( self.armed == 1 ) then
    local ch = 1
    self:stopNote()
    reaper.StuffMIDIMessage(0, 0x90 + ch - 1, pitch, vel)
    self.lastNote = {ch, pitch, vel}
  end
end

function tracker:stopNote()
  self:checkArmed()
  if ( self.armed == 1 ) then
    if ( self.lastNote ) then
      local lastNote = self.lastNote
      reaper.StuffMIDIMessage(0, 0x80 + lastNote[1] - 1, lastNote[2], lastNote[3])
      self.lastNote = nil
    end
  end
end

-- chord has to contain a table of {chan, pitch, vel}
function tracker:playChord(chord)
  self:checkArmed()
  if ( self.armed == 1 ) then
    local ch = 1
    self:stopChord()
    for i,v in pairs( chord ) do
      reaper.StuffMIDIMessage(0, 0x90 + v[1] - 1, v[2], v[3])
    end
    self.lastChord = chord
  end
end

function tracker:insertChord(chord)
  --reaper.StuffMIDIMessage(0, 0x90 + v[1] - 1, v[2], v[3])
  
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
   
  -- Grab references here, since clearblock calls update and regenerates them
  local data      = self.data
  local notes     = self.notes
  local noteGrid  = data.note  
  local noteStart = data.noteStart    
  
  -- We should be able to paste the contents now
  local jx        = self.xpos
  local rows      = self.rows
  local chtype, chan, origrow = self:getLocation()
  
  -- Don't insert chords if we are at an invalid location
  if ( chtype ~= 'text' ) then
    return
  end

  for i=1,#chord do
    local row = origrow
    
    -- 'NOTE' (1), pitch (2), velocity (3), startppq (4), endppq (5)
    local note = noteGrid[chan*rows+row-1]
    local noteToEdit = noteStart[rows*chan+row]

    -- Note that used to be in these grid locations
    local noteToInterrupt
    if ( row > 0 ) then
      noteToInterrupt = noteGrid[rows*chan+row-1]
    else
      noteToInterrupt = noteGrid[rows*chan+row]
    end    

    -- If the location where the paste happens started with a note, then shorten it!
    if ( ( self.ypos > 1 ) and ( note and ( note > -1 ) ) ) then
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[ note ] )
      local resize = row - self:ppqToRow(endppqpos)
      if ( resize ~= 0 ) then
        self:resizeNote(chan, self:ppqToRow(startppqpos), resize )
      end
    end

    -- Is there already a note starting here? Simply change the note.
    if ( noteToEdit ) then
        reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, chord[i][2], chord[i][3], true)
        local p2, v2 = table.unpack( notes[noteToEdit] )
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
        self:addNote(row, k, chan, chord[i][2], chord[i][3])

        local idx = rows*chan+k
        if ( noteGrid[idx] ) then
          if ( noteGrid[idx] < -1 ) then
            self:deleteNote(chan, k)

            local offidx = self:gridValueToOFFidx( noteGrid[idx] )
            self:SAFE_DeleteText(self.take, offidx)
          end
        end             
    end
    
    -- Were we overwriting an OFF marker?
    local curNote = noteGrid[rows*chan+row]
    if ( curNote and ( curNote < -1 ) ) then
      self:deleteNote(chan, row)
    end
    
    chan = chan + 1
  end
end

function tracker:stopChord()
  self:checkArmed()
  if ( self.armed == 1 ) then
    if ( self.lastChord ) then
      for i,v in pairs( self.lastChord ) do
        reaper.StuffMIDIMessage(0, 0x80 + v[1] - 1, v[2], v[3])
      end
      self.lastChord = nil
    end
  end
end

function tracker:setLoopStart()
    local mPos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
    local lPos, lEnd = reaper.GetSet_LoopTimeRange2(0, false, 1, 0, 0, false)
    
    lPos = mPos + tracker:toSeconds(tracker.ypos-1)
    if ( lPos > lEnd ) then
      lEnd = lPos + tracker:toSeconds(1)
    end
    reaper.GetSet_LoopTimeRange2(0, true, true, lPos, lEnd, true)
end

function tracker:setLoopEnd()
    local mPos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
    local lPos, lEnd = reaper.GetSet_LoopTimeRange2(0, false, 1, 0, 0, false)
    
    lEnd = mPos + tracker:toSeconds(tracker.ypos)
    if ( lPos > lEnd ) then
      lPos = lEnd - tracker:toSeconds(1)
    end
    reaper.GetSet_LoopTimeRange2(0, true, true, lPos, lEnd, true)    
end

function tracker:tryTake(i)
  local item = reaper.GetTrackMediaItem(self.track, i)
  if ( item ) then
    local take = reaper.GetActiveTake(item)
    if ( take ) then
      if ( reaper.TakeIsMIDI( take ) == true ) then
        tracker:setItem( item )
        tracker:setTake( take )
        return true
      end
      return false
    else
      return false
    end
  end
end

function tracker:clearEnvelopeRange(t1, t2)
  local fx = self.fx
  for i,v in pairs(fx.envelopeidx) do
    reaper.DeleteEnvelopePointRangeEx(v, -1, t1, t2)
  end
end

function tracker:selectCurrent()
  reaper.SelectAllMediaItems(0, false)
  reaper.SetMediaItemSelected(tracker.item, true)
end  
    
function tracker:duplicate()
  local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
  local mlen = reaper.GetMediaItemInfo_Value(tracker.item, "D_LENGTH")  

  if ( tracker.duplicationBehaviour == 1 ) then
    -- Duplicate using reaper commands (quick 'n dirty, but can be annoying because automation 
    -- gets put in the same pool)
    reaper.SelectAllMediaItems(0, false)
    reaper.SetMediaItemSelected(tracker.item, true)
    reaper.Main_OnCommand(40698, 0) -- Copy selected items
    reaper.SetEditCurPos2(0, mpos+mlen, false, false)
    reaper.Main_OnCommand(40058, 0) -- Paste
  else
    -- Duplicate explicitly (this makes sure that we get a new automation pool for every pattern)
    local newItem = reaper.CreateNewMIDIItemInProj(self.track, mpos+mlen, mlen, false)
    local newTake = reaper.GetActiveTake(newItem)
    
    -- For some reason the new midi item doesn't simply accept being created with the length given
    reaper.SetMediaItemInfo_Value(newItem, "D_LENGTH", mlen)

    -- Grab the notes and store them in channels
    local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
    local i
    if ( retval > 0 ) then
      for i=0,notecntOut do      
        local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(self.take, i)
        reaper.MIDI_InsertNote(newTake, selected, muted, startppqpos, endppqpos, chan, pitch, vel, true)        
      end
      for i=0,ccevtcntOut do
        local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
        reaper.MIDI_InsertCC(newTake, selected, muted, ppqpos, chanmsg, chan, msg2, msg3)
      end
      for i=0,textsyxevtcntOut do
        local retval, selected, muted, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, true, true, 1, 0, "    ")
        reaper.MIDI_InsertTextSysexEvt(newTake, selected, muted, ppqpos, typeidx, msg)
      end
    end
    reaper.MIDI_Sort(newTake)
    
    -- Clear whatever automation we are going to overlap with
    self:clearEnvelopeRange(mpos+mlen, mpos+2*mlen)
    
    --[[--
    Sadly, it's not possible (yet) to delete automation items it seems.
    local eps = tracker.automationeps
    for i=0,reaper.CountAutomationItems(envelope) do
      local pos = reaper.GetSetAutomationItemInfo(envelope, i, "D_POSITION", 1, false)
      local len = reaper.GetSetAutomationItemInfo(envelope, i, "D_LENGTH", 1, false)
      local startOverlap = pos > mpos and pos < ( mpos + mlen )
      local endOverlap = ( pos + len ) > mpos and ( pos + len ) < ( mpos + mlen )
      if ( startOverlap or endOverlap ) then
      end
    end
    --]]--
        
    local cnt = reaper.CountTrackEnvelopes(self.track)
    local autoidx = nil
    for i = 0,cnt-1 do
      local envidx = reaper.GetTrackEnvelope(self.track, i)
      autoidx = self:findMyAutomation( envidx )
      if ( autoidx ) then
        local newautoidx = reaper.InsertAutomationItem(envidx, -1, self.position+self.length, self.length)
  
        local npoints
        if ( self.automationBug == 1 ) then
          npoints = 2 * self.rows
        else
          npoints = reaper.CountEnvelopePointsEx(envidx, autoidx)
        end
        
        for ptidx=0,npoints do
          local retval, envtime, value, shape, tension, selected = reaper.GetEnvelopePointEx(envidx, autoidx, ptidx)
          if ( retval ) then
            envtime = envtime + mlen
            reaper.InsertEnvelopePointEx(envidx, newautoidx, envtime, value, shape, tension, selected, false)
          end
        end
        reaper.Envelope_SortPointsEx(envidx, autoidx)
      end
    end    
  end
  
  tracker:seekMIDI(1)
  tracker:setOutChannel( tracker.outChannel )
end

function tracker:seekMIDI( dir )
  self.track = reaper.GetMediaItem_Track(self.item)
  local nItems = reaper.GetTrackNumMediaItems(self.track)
    
  -- Find me first
  local cur
  for i=0,nItems do
    local mediaItem = reaper.GetTrackMediaItem(self.track, i)
    if ( mediaItem == self.item ) then
      cur = i
    end
  end
  
  if ( dir > 0 ) then
    for i=cur+1,nItems do
      if ( self:tryTake(i) ) then
        if ( self.selectionFollows == 1 ) then
          self:selectCurrent()
        end
        return
      end
    end
  elseif ( dir < 0 ) then
    for i=cur-1,0,-1 do
      if ( self:tryTake(i) ) then
        if ( self.selectionFollows == 1 ) then
          self:selectCurrent()
        end
        return
      end   
    end  
  else
    print( "Fatal error: Invalid direction given" )
  end  
end

function tracker:resizePattern()
  local newLen = tonumber(self.newLength)
  if ( newLen and ( newLen > 0 ) ) then
    local glueCmd = 40362
    local newLenS = newLen / self.rowPerSec
    
    -- Select the correct items
    reaper.SelectAllMediaItems(0, false)
    -- Deselect everything
    reaper.Main_OnCommand(40289, 0)
    
    -- Select my take and automation stuff
    reaper.SetMediaItemSelected(tracker.item, true)
    local cnt = reaper.CountTrackEnvelopes(self.track)
    local autoidx = nil
    for i = 0,cnt-1 do
      local envidx = reaper.GetTrackEnvelope(self.track, i)
      autoidx = self:findMyAutomation( envidx )
      if ( autoidx ) then
        reaper.GetSetAutomationItemInfo(envidx, autoidx, "D_UISEL", 1, true)
      end
    end
    
    -- Glue it (prevents unpredictable loops that were outside the pattern range)
    reaper.Main_OnCommand(glueCmd, 0)
    reaper.Main_OnCommand(42089, 0)
    
    -- Make sure we have the correct item
    self:grabActiveItem()
    reaper.SetMediaItemInfo_Value(self.item, "D_LENGTH", newLenS )
    
    -- Resize it
    local cnt = reaper.CountTrackEnvelopes(self.track)
    local autoidx = nil
    for i = 0,cnt-1 do
      local envidx = reaper.GetTrackEnvelope(self.track, i)
      autoidx = self:findMyAutomation( envidx )
      if ( autoidx ) then
        local len = reaper.GetSetAutomationItemInfo(envidx, autoidx, "D_LENGTH", newLenS, true)
      end
    end    
    
    -- Glue it again
    reaper.Main_OnCommand(glueCmd, 0)
    reaper.Main_OnCommand(42089, 0)
    tracker:checkChange()
  end
end

------------------------------
-- Main update loop
-----------------------------
local function updateLoop()
  local tracker = tracker

  if ( tracker.cfg.colResize == 1 ) then
    tracker:autoResize()
    tracker:computeDims(tracker.rows)
    
    if ( tracker.fov.abswidth ~= tracker.fov.lastabswidth ) then
      if ( tracker.fov.abswidth < 450 ) then
        tracker.fov.abswidth = 450
      end
    
      tracker.lastabswidth = tracker.fov.abswidth
      tracker:update()
    end
  end

  tracker:clearDeleteLists()
  tracker:clearInsertLists()

  -- Check if the note data or take changed, if so, update the note contents
  if ( not tracker:checkChange() ) then
    gfx.quit()
    return
  end

  tracker:resizeWindow()
  tracker:checkArmed()

  -- Maintain the loop until the window is closed or escape is pressed
  lastChar = gfx.getchar()
  
  -- Check if the length changed, if so, update the time data
  if ( tracker:getRowInfo() == true ) then
    tracker:update()
  end  

  if ( tracker.printKeys == 1 ) then
    if ( lastChar ~= 0 ) then
      print(lastChar)
    end
  end  

  -- Mouse
  local left, right = mouseStatus()
  if ( tracker.fov.height < tracker.rows ) then
    local loc = tracker.scrollbar:mouseUpdate(gfx.mouse_x, gfx.mouse_y, left)
    if ( loc ) then
      tracker.ypos = math.floor(loc*(tracker.rows+1))
      tracker:forceCursorInRange()
    end
  end
  
  if ( left == 1  ) then
    local Inew
    local Jnew
    local plotData  = tracker.plotData
    local fov       = tracker.fov
    local xloc      = plotData.xloc
    local yloc      = plotData.yloc  
    
    -- Mouse on track size indicator?
    local xl, yl, xm, ym = tracker:getSizeIndicatorLocation()
    if ( gfx.mouse_y > yl ) then
      if ( gfx.mouse_y < ym ) then
        if ( gfx.mouse_x > xl ) then
          if ( gfx.mouse_x < xm ) then
            tracker.renaming = 3
            tracker.newLength = tostring(tracker.max_ypos)
          end
        end
      end
    end
    
    -- Mouse in range of pattern data?
    for i=1,#xloc-1 do
      if ( ( gfx.mouse_x > xloc[i] ) and ( gfx.mouse_x < xloc[i+1] ) ) then
        Inew = i
      end
    end
    for i=1,#yloc-1 do
      if ( ( gfx.mouse_y > yloc[i] ) and ( gfx.mouse_y < yloc[i+1] ) ) then
        Jnew = i
      end
    end
    
    if ( Inew and Jnew ) then        
      -- Move the cursor pos on initial click
      if ( tracker.lastleft == 0 ) then
        tracker:resetShiftSelect()
        tracker:dragBlock(Inew+fov.scrollx, Jnew+fov.scrolly)
        tracker.xpos = Inew + fov.scrollx
        tracker.ypos = Jnew + fov.scrolly
      else
        -- Change selection if it wasn't the initial click
        tracker:dragBlock(Inew+fov.scrollx, Jnew+fov.scrolly)
      end
    end
    
    if ( tracker.cfg.scaleActive == 1 ) then
      local xs, ys, scaleY, keyMapH, scaleW, chordW, noteW, chordAreaY = tracker:chordLocations()    
      local scales = scales      
      local progressions = scales.progressions

      if ( gfx.mouse_y > scaleY ) then
        if ( gfx.mouse_y < ( scaleY + keyMapH ) ) then
          if ( gfx.mouse_x > xs ) then
            local note = math.floor( ( gfx.mouse_x - xs ) / noteW ) + 1
            if ( note < 1 ) then
              note = 1
            elseif( note > 12 ) then
              note = 12
            end
            scales:switchRoot(note)
            tracker:saveConfig(tracker.cfg)
          end
        end
      end

      if ( gfx.mouse_y > chordAreaY ) then      
        -- Figure out which scale we are clicking
        yCoord = ( gfx.mouse_y - chordAreaY ) / keyMapH

        -- Find the scale we clicked
        local done = 0
        local i = 1
        local row = 0
        local chordrow = 1
        local scaleRows
        local scaleIdx
        local scaleName
        while (done==0) do
          scaleIdx = i
          scaleName = scales.names[i]
          -- How many rows does this scale have?
          local chordmap = #(progressions[scaleName][1].notes)
          scaleRows = #(progressions[scaleName][1].notes)
          chordrow = math.floor(yCoord - row - .5)
          i = i + 1
          if ( ( chordrow < scaleRows ) or ( i > #scales.names ) ) then    
            done = 1
          else
            row = row + scaleRows
          end
        end
        
        -- Select different scale?
        if ( gfx.mouse_x > xs ) then
          if ( gfx.mouse_x < xs + scaleW ) then
            scales:setScale( scaleIdx )
            tracker:saveConfig(tracker.cfg)
          end
          
          -- Selected a chord?
          if ( chordrow < scaleRows ) then
            local tone = math.floor( ( gfx.mouse_x - xs - scaleW ) / chordW ) + 1
            if ( ( tone > 0 ) and ( tone < 8 ) ) then
              local chord = scales:pickChord( scaleName, tone, chordrow+1 )
              
              if ( chord ) then
                local playChord = {}
                
                -- Get modifiers
                local control = gfx.mouse_cap & 4
                if ( control > 0 ) then control = 1 end  
                local shift   = gfx.mouse_cap & 8
                if ( shift > 0 ) then shift = 1 end
                local alt     = gfx.mouse_cap & 16
                if ( alt > 0 ) then alt = 1 end
                
                for i,v in pairs(chord) do
                  v = v + tracker.transpose * 12 + 11
                  playChord[i] = { 1, v, 127 }
                end
                
                if ( alt == 1 ) then
                  if ( playChord[1][2] ) then
                    playChord[1][2] = playChord[1][2] + 12
                  end
                end
                if ( shift == 1 ) then
                  if ( playChord[1][2] ) then
                    playChord[2][2] = playChord[2][2] + 12
                  end
                end

                if ( control == 1 ) then
                  tracker:insertChord( playChord )
                  tracker:deleteNow()
                end
                
                if ( (change == 1) or (not tracker.lastChord) ) then
                  tracker:playChord( playChord )
                end
              end
            end
          end
        end
      end
    end
    
    -- Mouse in range of options?
    if ( tracker.optionsActive == 1 ) then
      local changedOptions = 0
      local xs, ys, keyMapX, keyMapY, keyMapH, themeMapX, themeMapY, binaryOptionsX, binaryOptionsY, binaryOptionsH = tracker:optionLocations()    
      
      -- Color themes
      if ( gfx.mouse_x > themeMapX ) then
        if ( gfx.mouse_y > themeMapY + keyMapH ) then
          if ( gfx.mouse_y < keyMapY ) then
            local sel = math.floor((gfx.mouse_y - themeMapY)/keyMapH)
            if ( tracker.colorschemes[sel] ) then
              if ( tracker.colorschemes[sel] ~= tracker.cfg.colorscheme ) then
                changedOptions = 1
              end
              tracker.cfg.colorscheme = tracker.colorschemes[sel]
            end
          end
        end
      end
      
      -- Key mappings
      if ( gfx.mouse_x > keyMapX ) then
        if ( gfx.mouse_y > keyMapY + keyMapH ) then
          local sel = math.floor((gfx.mouse_y - keyMapY)/keyMapH)
          if ( keysets[sel] ) then
            if ( keysets[sel] ~= tracker.cfg.keyset ) then
              changedOptions = 1
            end
            tracker.cfg.keyset = keysets[sel]
          end
        end
      end
      
      -- Binary options
      if ( gfx.mouse_x > binaryOptionsX ) then
        if ( gfx.mouse_y > binaryOptionsY ) then        
          for i=1,#tracker.binaryOptions do
            local xs = binaryOptionsX
            local ys = binaryOptionsY + i * binaryOptionsH
            local xm = xs + 8
            local ym = ys + 8
            if ( ( gfx.mouse_x > xs ) and  ( gfx.mouse_x < xm ) and ( gfx.mouse_y > ys ) and ( gfx.mouse_y < ym ) and not tracker.holding ) then
              tracker.cfg[tracker.binaryOptions[i][1]] = 1 - tracker.cfg[tracker.binaryOptions[i][1]]
              changedOptions = 1
              tracker.holding = 1
            end
          end
        end
      end      
      
      if ( changedOptions == 1 ) then
        local cfg = tracker.cfg
        tracker:saveConfig(cfg)
        tracker:loadColors(cfg.colorscheme)
        tracker:initColors()
        tracker:loadKeys(cfg.keyset)
      end
    end
  else
    if ( tracker.lastChord ) then
      tracker:stopChord()
    end
    tracker.holding = nil
  end 
  tracker.lastleft = left
  
  if ( gfx.mouse_wheel ~= 0 ) then
    tracker.ypos = tracker.ypos - math.floor( gfx.mouse_wheel / 120 )
    tracker:resetShiftSelect()
    gfx.mouse_wheel = 0
  end
  
  local modified = 0
  if ( tracker.renaming == 0 ) then
    if inputs('left') then
      tracker.xpos = tracker.xpos - 1
      tracker:resetShiftSelect()
    elseif inputs('right') then
      tracker.xpos = tracker.xpos + 1
      tracker:resetShiftSelect()
    elseif inputs('up') then
      tracker.ypos = tracker.ypos - 1
      tracker:resetShiftSelect()
    elseif inputs('down') then
      tracker.ypos = tracker.ypos + 1
      tracker:resetShiftSelect()
    elseif inputs('shiftleft') then
      tracker:dragBlock()
      tracker.xpos = tracker.xpos - 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftright') then
      tracker:dragBlock()
      tracker.xpos = tracker.xpos + 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftup') then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos - 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftdown') then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos + 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('off') then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Place OFF")
      reaper.MarkProjectDirty(0)    
      tracker:placeOff()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('delete') ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete (Del)")
      tracker:delete()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('delete2') ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete (Del)")
      tracker:delete()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      tracker.ypos = tracker.ypos + tracker.advance
    elseif inputs('home') then
      tracker.ypos = 0
    elseif inputs('End') then
      tracker.ypos = tracker.rows
    elseif inputs('toggle') then
      togglePlayPause()
    elseif inputs('playfrom') then
      local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
      local loc = reaper.AddProjectMarker(0, 0, mpos + tracker:toSeconds(tracker.ypos-1), 0, "", -1)
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
    elseif inputs('deleteBlock') then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete block")
      reaper.MarkProjectDirty(0)
      tracker:deleteBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('beginBlock') then
      tracker:beginBlock()
    elseif inputs('endBlock') then
      tracker:endBlock()
    elseif inputs('cutBlock') then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Cut block")
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('pasteBlock') then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Paste block")
      reaper.MarkProjectDirty(0)
      tracker:pasteBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('copyBlock') then
      tracker:copyBlock()
    elseif inputs('shiftItemUp') then
      modified = 1
      tracker:shiftup()
    elseif inputs('shiftItemDown') then
      modified = 1
      tracker:shiftdown()
    elseif inputs('scaleUp') then
      modified = 1
      tracker:shiftScaleUp()
    elseif inputs('scaleDown') then
      modified = 1
      tracker:shiftScaleDown()
    elseif inputs('octaveup') then
      tracker.transpose = tracker.transpose + 1
      tracker:storeSettings()
    elseif inputs('octavedown') then
      tracker.transpose = tracker.transpose - 1  
      tracker:storeSettings()    
    elseif inputs('envshapeup') then
      tracker.envShape = tracker.envShape + 1
      if ( tracker.envShape > #tracker.envShapes ) then
        tracker.envShape = 0
      end
      tracker:storeSettings()
    elseif inputs('envshapedown') then
      tracker.envShape = tracker.envShape - 1
      if ( tracker.envShape < 0 ) then
        tracker.envShape = #tracker.envShapes
      end
      tracker:storeSettings()
    elseif inputs('outchanup') then
      tracker.outChannel = tracker.outChannel + 1
      if ( tracker.outChannel > 16 ) then
        tracker.outChannel = 0
      end
      tracker:setOutChannel( tracker.outChannel )
    elseif inputs('outchandown') then
      tracker.outChannel = tracker.outChannel - 1
      if ( tracker.outChannel < 0) then
        tracker.outChannel = 16
      end
      tracker:setOutChannel( tracker.outChannel )
    elseif inputs('advanceup') then
      tracker.advance = tracker.advance + 1
      tracker:storeSettings()
    elseif inputs('advancedown') then
      tracker.advance = tracker.advance - 1
      if ( tracker.advance < 0 ) then
        tracker.advance = 0
      end
      tracker:storeSettings()
    elseif inputs('resolutionUp') then
      tracker.newRowPerQn = tracker.newRowPerQn + 1
      if ( tracker.newRowPerQn > tracker.maxRowPerQn ) then
        tracker.newRowPerQn = 1
      end
    elseif inputs('resolutionDown') then  
      tracker.newRowPerQn = tracker.newRowPerQn - 1
      if ( tracker.newRowPerQn < 1 ) then
        tracker.newRowPerQn = tracker.maxRowPerQn
      end
    elseif inputs('stop2') then
      reaper.Main_OnCommand(1016, 0)
    elseif inputs('panic') then
      reaper.Main_OnCommand(40345, 0)
    elseif inputs('help') then
      tracker.helpActive = 1-tracker.helpActive
      tracker:resizeWindow()
    elseif inputs('options') then
      tracker.optionsActive = 1-tracker.optionsActive    
      tracker:resizeWindow()
    elseif inputs('harmony') then
      tracker.cfg.scaleActive = 1-(tracker.cfg.scaleActive or 0)
      tracker:resizeWindow()
      tracker:saveConfig(tracker.cfg)
    elseif inputs('nextMIDI') then
      tracker:seekMIDI(1)
      tracker:resizeWindow()
    elseif inputs('prevMIDI') then  
      tracker:seekMIDI(-1)
      tracker:resizeWindow()
    elseif inputs('duplicate') then
      reaper.Undo_OnStateChange2(0, "Tracker: Duplicate pattern")
      reaper.MarkProjectDirty(0) 
      tracker:duplicate()
    elseif inputs('commit') then
      tracker:setResolution( tracker.newRowPerQn )
      self.hash = math.random()
    elseif inputs('setloop') then
      local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
      local mlen = reaper.GetMediaItemInfo_Value(tracker.item, "D_LENGTH")      
      reaper.GetSet_LoopTimeRange2(0, true, true, mpos, mpos+mlen, true)
    elseif inputs('setloopstart') then
      tracker:setLoopStart()  
    elseif inputs('setloopend') then
      tracker:setLoopEnd()   
    elseif inputs('interpolate') then
      reaper.Undo_OnStateChange2(0, "Tracker: Interpolate")
      reaper.MarkProjectDirty(0)  
      tracker:interpolate()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('showMore') then
      tracker:showMore()
    elseif inputs('showLess') then
      tracker:showLess()
    elseif inputs('tab') then
      tracker:tab()
    elseif inputs('shifttab') then
      tracker:shifttab()
    elseif inputs('addCol') then
      tracker:addCol()
    elseif inputs('remCol') then
      tracker:remCol()            
    elseif inputs('rename') then
      tracker.oldMidiName = tracker.midiName
      tracker.midiName = ''
      tracker.renaming = 1
      tracker:updateMidiName()
    elseif inputs('toggleRec') then
      if ( tracker.armed == 1 ) then
        tracker:stopNote()
        tracker:disarm()
      else
        tracker:arm()
      end
    elseif inputs('escape') then
      if ( tracker.armed == 1 ) then
        tracker.onlyListen = 1 - tracker.onlyListen
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
  elseif( tracker.renaming == 1 ) then
    -- Renaming pattern
    if inputs( 'playfrom' ) then
      tracker.renaming = 0
    elseif inputs( 'escape' ) then
      tracker.midiName = tracker.oldMidiName
      tracker:updateMidiName()
      tracker.renaming = 0
    elseif inputs( 'remove' ) then
      tracker.midiName = tracker.midiName:sub(1, tracker.midiName:len()-1)
      tracker:updateMidiName()
    else    
      if ( pcall( function () string.char(lastChar) end ) ) then
        local str = string.char( lastChar )
        tracker.midiName = string.format( '%s%s', tracker.midiName, str )
        tracker:updateMidiName()
      end
    end
  elseif ( tracker.renaming == 2 ) then
    -- Adding column
    if inputs( 'playfrom' ) then
      tracker.renaming = 0
      tracker:createCCCol()
    elseif( inputs( 'escape' ) ) then
      tracker.renaming = 0
    elseif( inputs( 'remove' ) ) then
      tracker.newCol = tracker.newCol:sub(1, tracker.newCol:len()-1)
    elseif ( lastChar > 0 ) then
      if ( pcall( function () string.char( lastChar ) tonumber(lastChar) end ) ) then
        local str = string.char( lastChar )
        tracker.newCol = string.format( '%s%s', tracker.newCol, str )
      end
    end
  elseif ( tracker.renaming == 3 ) then
    -- Resizing pattern
    if inputs( 'playfrom' ) then
      tracker.renaming = 0
      tracker:resizePattern()
    elseif( inputs( 'escape' ) ) then
      tracker.renaming = 0
    elseif( inputs( 'remove' ) ) then
      tracker.newLength = tracker.newLength:sub(1, tracker.newLength:len()-1)
    elseif ( lastChar > 0 ) then
      if ( pcall( function () string.char( lastChar ) tonumber(lastChar) end ) ) then
        local str = string.char( lastChar )
        tracker.newLength = string.format( '%s%s', tracker.newLength:sub(1,2), str )
      end
    end
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
  
  --lastChar ~= 27 and 
  if lastChar ~= -1 then
    reaper.defer(updateLoop)
  else
    tracker:stopNote()
    gfx.quit()
  end
end

function tracker:autoResize()
  local siz = gfx.w
  if ( tracker.helpActive == 1 ) then
    siz = siz - self.helpwidth
  end
  if ( tracker.optionsActive == 1 ) then
    siz = siz - self.optionswidth
  end
  if ( tracker.scaleActive == 1 ) then
    siz = siz - self.scalewidth
  end
  tracker.fov.abswidth = siz
end

-- To do: Automatic width estimation
function tracker:computeDims(inRows)
  local rows = inRows
  
  if ( rows > tracker.fov.height ) then
    rows = tracker.fov.height
  end  
  
  width = self.fov.abswidth
  if ( tracker.helpActive == 1 ) then
    width = width + self.helpwidth
    if ( rows < 16 ) then
      rows = 16
    end
  end
  if ( tracker.optionsActive == 1 ) then
    width = width + self.optionswidth
    if ( rows < 16 ) then
      rows = 16
    end
  end
  if ( tracker.cfg.scaleActive == 1 ) then
    width = width + self.scalewidth
    if ( rows < 26 ) then
      rows = 26
    end
  end
  
  local grid = tracker.grid
  height = grid.originy + (rows+1) * grid.dy + 2*grid.itempady  
  
  if ( tracker.cfg.autoResize == 0 ) then
    if ( self.lastY ) then
      height = self.lastY
    end
  end
  
  local changed
  if ( not self.lastY or ( self.lastY ~= height) or not self.lastX or ( self.lastX ~= width ) ) then    
    self:resetBlock()
    
    changed = 1
    if ( not self.lastX or ( self.lastX ~= width ) ) then
      changed = 2
    end
    
    self.lastY = height
    self.lastX = width
  else
    changed = 0
  end
  
  return width, height, changed
end

function tracker:resizeWindow()
  local width, height, changed = self:computeDims(self.rows)
  if ( ( changed == 1 and ( tracker.cfg.autoResize == 1 ) ) or ( changed == 2 ) ) then
    local v, wx, wy, ww, wh
    local d, wx, wh = gfx.dock(-1, 1, 1, nil, nil)
    gfx.quit()
    gfx.init( self.windowTitle, width, height, d, wx, wh)
    self.windowHeight = height
  end
end

function tracker:updateMidiName()
  reaper.GetSetMediaItemTakeInfo_String(self.take, "P_NAME", self.midiName, true)
  self:updateNames()
end

function tracker:updateNames()
  local maxsize = self.maxPatternNameSize
  if ( self.track ) then
    local retval, trackName = reaper.GetTrackName(self.track, stringbuffer)  
    self.trackName = trackName
  end
  if ( self.take ) then    
    self.midiName = reaper.GetTakeName(self.take)
  else
    self.midiName = ''
  end
  
  self.windowTitle = string.format('%s [%s], ', self.name, self.trackName)
  if ( self.midiName:len() > maxsize ) then
    self.patternName = string.format('%s/%s>', self.trackName, self.midiName:sub(1,maxsize))
  else
    self.patternName = string.format('%s/%s', self.trackName, self.midiName:sub(1,maxsize))  
  end
end

function tracker:loadConfig()
    local cfg = self.cfg
    local file = io.open(get_script_path().."_hackey_trackey_options_.cfg", "r")
    
    if ( file ) then
      io.input(file)
      local str = io.read()
      while ( str ) do
        for k, v in string.gmatch(str, "(%w+)=(%w+)") do
          local no = tonumber(v)
        
          if ( no ) then
            cfg[k] = no
          else
            cfg[k] = v
          end
        end
        str = io.read()
      end
      io.close(file)
    end    
    
    return cfg
end

function tracker:saveConfig(cfg)
  local file = io.open(get_script_path().."_hackey_trackey_options_.cfg", "w+")
  
  cfg.root  = scales.root
  cfg.scale = scales.curScale
  
  if ( file ) then
    io.output(file)
    for i,v in pairs(cfg) do
      io.write( string.format('%s=%s\n', i, v) )
    end
    io.close(file)
  end
end

function tracker:grabActiveItem()
    local item = reaper.GetSelectedMediaItem(0, 0)
    if ( item ) then
      local take = reaper.GetActiveTake(item)
      if ( reaper.TakeIsMIDI( take ) == true ) then
        tracker:setItem( item )
        tracker:setTake( take )
        return 1
      end
    end
end

--tracker.saveConfig(tracker.cfg)
local function Main()
  local tracker = tracker  
  local reaper = reaper
  if ( reaper.CountSelectedMediaItems(0) > 0 ) then
    tracker.tick = 0
    tracker.scrollbar = scrollbar.create(tracker.scrollbar.size)
    
    -- Load user options
    local cfg = tracker:loadConfig()
    tracker:loadColors(cfg.colorscheme)
    tracker:initColors()
    tracker:loadKeys(cfg.keyset)
    tracker.cfg = cfg   
    
    if ( cfg.root and ( scales.root ~= cfg.root ) ) then
      scales:switchRoot( cfg.root )
    end
    if ( cfg.scale and ( scales.curScale ~= cfg.scale ) ) then
      scales:setScale( cfg.scale )
    end
    
    tracker:generatePitches()
    tracker:initColors()
    if ( tracker:grabActiveItem() ) then
      
      local width, height = tracker:computeDims(48)
      tracker:updateNames()
      gfx.init(tracker.windowTitle, width, height, 0, 200, 200)
      tracker.windowHeight = height
      
      if ( tracker.outChannel ) then
        tracker:setOutChannel( tracker.outChannel )
      end
      
      reaper.defer(updateLoop)
    end
  else
    reaper.ShowMessageBox("Please select a MIDI item before starting the tracker", "No MIDI item selected", 0)
  end
end

Main()
