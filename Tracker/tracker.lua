--[[
@description Hackey-Trackey: A tracker interface similar to Jeskola Buzz for MIDI and FX editing.
@author: Joep Vanlier
@provides
  scales.lua
  [main] .
@links
  https://github.com/joepvanlier/Hackey-Trackey
@license MIT
@version 2.20
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
 * v2.20 (2020-05-09)
   + Only show pulse warning once.
   + Add config option that allows delay or note end to always be open as a preference.
   + Don't let font run off screen.
 * v2.19 (2020-03-28)
   + Fix remember position.
 * v2.18 (2020-03-14)
   + Add support for lowest midi octave.
 * v2.17 (2020-03-07)
   + Bugfix mute status. Make sure added notes respect mute status.
 * v2.16 (2020-03-07)
   + Support channel level mutes.
 * v2.15 (2020-02-23)
   + Fix note off AZERTY layout Renoise.
 * v2.14 (2020-02-23)
   + Minor bugfix scrolling behavior.
   + Quietly ignore missing keys.
   + Improve scrollbar behaviour.
 * v2.13 (2020-02-22)
   + Added clicking on left column to set position.
   + Added optional graphical effects.
   + Added extra validation of item and take.
   + Fixed issue with duplicate defer loop.
 * v2.12 (2020-02-22)
   + Update loop when following selection.
 * v2.11 (2020-02-20)
   + Add default channel = 1 option.
 * v2.10 (2020-02-09)
   + Disable printkeys
 * v2.09 (2020-02-09)
   + Add ctrl + o as secondary key for options.
 * v2.08 (2020-01-09)
   + Minor tweaks for larger fonts.
 * v2.07 (2020-01-06)
   + Allow different font sizes.
   + Refactor menu handling to make it a little less horrible.
   + Bugfix: Make sure key mapping isn't clicked when layout is changed.
 * v2.06 (2020-01-05)
   + Bugfix shift functionality. Catch keystrokes that cannot be converted to valid characters.
 * v2.05 (2019-12-15)
   + add note names panel
 * v2.04 (2019-12-08)
   + make shift + chord behaviour more like renoise: return to first column and advance when shift is released
   + add advanceDouble and advanceHalve commands
   + add upByAdvance and downByAdvance commands
 * v2.03 (2019-10-28)
   + Minor bugfix shift + note = next column (thanks dri_ft!).
   + Remove default enter = close.
 * v2.02 (2019-07-30)
   + Bugfix pattern deletion.
 * v2.01 (2019-07-30)
   + Bugfix item deletion.
 * v2.00 (2019-07-27)
   + Bugfix column header colors.
 * v1.99 (2019-07-27)
   + Minor tweak header renderposition.
 * v1.98 (2019-07-27)
   + Add config option for item color instead of track color (thanks hangnef!).
   + Invert header color if luminance is too close to item color.
   + Minor tweaks.
   + Fix issue with overhanging text fields.
 * v1.97 (2019-07-27)
   + Start tracker on first note column properly.
 * v1.96 (2019-07-27)
   + Start tracker on first note column.
 * v1.95 (2019-07-26)
   + Add ability to start HT without MIDI item selected.
   + Store whether HT is docked or not.
 * v1.94 (2019-02-17)
   + Added check whether a new FX column was added and make it trigger an auto-refresh.
   + Added support for using track colors.
   + Added mechanism that allows fallback on nearest track when track is deleted.
   + Added mechanism that attempts waiting a few cycles when item goes missing (for glueing from arrange).
 * v1.93 (2019-02-17)
   + Prevent shift from modifying pitch keys that aren't letters (thanks hangnef).
 * v1.92 (2019-02-17)
   + Fix exception when MIDI item is removed by CTRL+Z.
 * v1.91 (2019-01-27)
   + Added option to follow location in arrange.
 * v1.90 (2019-01-27)
   + Add flag for custom parameter to kill hackey trackey (set the last one to 1)
   + Make open patterns close HT.
 * v1.89 (2019-01-27)
   + Copy target channel when duplicating pattern.
 * v1.88 (2018-12-05)
   + Rename reaper-kb.
 * v1.87 (2018-11-18)
   + Added optional mode to store row highlighting override in pattern.
 * v1.86 (2018-11-17)
   + Added option to override row highlighting.
 * v1.85 (2018-11-17)
   + Made sure ticks per beat also highlights beats correctly.
   + Fetch channel output settings from track.
 * v1.84 (2018-10-21)
   + Add maximum height to config file.
   + Added automatic rescaling of number of rows.
 * v1.83 (2018-10-20)
   + Add maxwidth parameter to config file.
 * v1.82 (2018-10-19)
   + Added passthrough of commands which are configurable as custom keys.
 * v1.81 (2018-10-19)
   + Added option to suppress all automatic resizing of the tracker.
 * v1.80 (2018-10-13)
   + Ignore OFF MIDI items when browsing. Do not allow browser to be opened on OFF MIDI Items.
   + Cleaned up automatic file write.
 * v1.79 (2018-10-10)
   + Added option for custom key layouts in external file (userkeys.lua, should be created on script startup).
   + Added option to remove minimum size constraint
 * v1.78 (2018-09-10)
   + Fix issue when not using settings stored in pattern
 * v1.77 (2018-09-07)
   + Minor bugfix.
 * v1.76 (2018-09-07)
   + Fix typo.
 * v1.75 (2018-09-07)
   + Made sure the sequencer can pass row info to HT.
 * v1.74 (2018-08-13)
   + Started work on integration with Hackey Machines (receiving config override info).
 * v1.73 (2018-08-11)
   + Bugfix pattern duplication due to incorrect usage of CreateNewMIDIItemInProj (Thanks Meta!)
 * v1.72 (2018-07-11)
   + Added option to switch track
 * v1.71 (2018-07-11)
   + Added option to set loop when tracker is opened
 * v1.70 (2018-07-11)
   + Added option to make looped section follow pattern that is active
 * v1.69 (2018-07-09)
   + Added optional per channel program change select
 * v1.68 (2018-07-09)
   + Made sure CC0 is possible
 * v1.67 (2018-07-06)
   + Added option for midi program change column (beta)
 * v1.66 (2018-07-06)
   + Added option for swapping y and z for different keyboard layouts
 * v1.65 (2018-06-11)
   + Block interpolation without distance
 * v1.64 (2018-06-10)
   + Added some extra shortcuts
   + Insert row (default = CTRL + Ins)
   + Remove row (default = CTRL + Backspace)
   + Wrap down  (default = CTRL + Shift + Ins)
   + Wrap up    (default = CTRL + Shift + Backspace)
 * v1.63 (2018-05-26)
   + Fixed problems with paste behavior (now mends so that we don't get OFFs at the end of the block (can toggle this behavior in options screen)
   + Added shortcut for closing hackey trackey
 * v1.62 (2018-05-26)
   + Fixed play from
   + Set default FOV back to 32 rows
   + Added shift pgup, pgdown, home, end
 * v1.61 (2018-05-24)
   + More renoise shortcuts added (see help)
   + Fix regarding the Play From command
 * v1.60 (2018-05-23)
   + Added some more renoise keybindings (SHIFT + place note and others)
   + Fixed bug related to storage of settings with the bottom bar
   + Make script remember last position and size
 * v1.59 (2018-05-23)
   + Bugfix: Fixed delete key not working in renoise theme.
 * v1.58 (2018-05-23)
   + Bugfix: Fixed bug that caused copy error when subtick fields were being copied (delay or end)
 * v1.57 (2018-05-23)
   + Added: Optional note length column (reveal with CTRL + + twice)
   + The value indicates the length of the last tick that the note is active.
     FF = the full length of the last tick.
 * v1.56 (2018-05-22)
   + Fixed bug involving envelopes that were constantly resetting and added fast envelope.
 * v1.55 (2018-05-22)
   + Bugfix bottom option
   + Added renoise-like theme with different font
   + Added shift+space as play from in the renoise keyset
 * v1.54 (2018-05-22)
   + Added mouse interactivity for the bottom panel (resolution, octave, record etc)
 * v1.53 (2018-05-21)
   + Renoise-like color scheme
 * v1.52 (2018-05-21)
   + Option to follow tracker within a track
 * v1.51 (2018-05-21)
   + Minor bugfix to make sure that renoise-like keyset is immediately available after change
 * v1.50 (2018-05-21)
   + Added saving defaults for advance / octave / resolution / envelope
 * v1.49 (2018-05-20)
   + Added some compatibility features to be more like renoise
 * v1.48 (2018-05-03)
   + Changed resolution change to Alt + Shift + Up/Down to avoid conflict with windows screenflipping shortcut.
 * v1.47 (2018-05-03)
   + Bugfix regarding scale behaviour when harmony helper is open
 * v1.46 (2018-05-03)
   + Bugfix for when item is deleted
 * v1.45 (2018-05-03)
   + Added hackey mode and optional CRT effect
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
tracker.name = "Hackey Trackey v2.19"

tracker.configFile = "_hackey_trackey_options_.cfg"
tracker.keyFile = "userkeys.lua"

tracker.offTag = "__OFF__"

-- Map output to specific MIDI channel
--   Zero makes the tracker use a separate channel for each column. Column
--   one being mapped to MIDI channel 2. Any other value forces the output on
--   a specific channel.
tracker.outChannel = 1

tracker.CCjump = 512
tracker.PCloc = 10240

-- MIDI device to play notes over
-- For me it was 6080 for Virtual MIDI keyboard and 6112 for ALL, but this may
-- be system dependent, I don't know.
tracker.playNoteCh = 6112

-- How much overlap is used for legato?
tracker.magicOverlap = 10

-- Enable FX automation?
tracker.trackFX = 1

-- Defaults
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
tracker.toosmall = 0

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
function updateShown()
  if tracker.cfg.alwaysShowDelays == 1 then
    tracker.showDelays    = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
  else
    tracker.showDelays    = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  end
  if tracker.cfg.alwaysShowNoteEnd == 1 then
    tracker.showEnd       = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
  else
    tracker.showEnd       = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
  end
end

-- Start by default in mono or multi-col CC mode
-- Mono-col (0) mode shows one column for the CC's that is always displayed
-- Multi-col (1) shows only specifically enabled CC's (Add new ones with CTRL + SHIFT + +)
-- Remove ones with CTRL + SHIFT + - (note that this deltes the CC data too)
tracker.modMode = 0

tracker.channels = 16 -- Max channel (0 is not shown)
tracker.displaychannels = 15

-- Plotting
function updateFontScale()
  local fontScaler = 1
  if ( tracker.colors.patternFont and tracker.colors.patternFontSize ) then
    fontScaler = tracker.colors.patternFontSize/14
  end
  
  tracker.grid = {}
  tracker.grid.fontScaler = fontScaler
  tracker.grid.originx   = 22 + 18*fontScaler  -- 35
  tracker.grid.originy   = 35
  tracker.grid.dx        = 8 * fontScaler
  tracker.grid.dy        = 20 * fontScaler
  tracker.grid.barpad    = 10 * fontScaler
  tracker.grid.itempadx  = 5
  tracker.grid.itempady  = 3
  
  tracker.harmonyWidth    = 520 * fontScaler
  tracker.noteNamesWidth  = 250 * fontScaler
  tracker.helpwidth       = 400 * fontScaler
  tracker.optionswidth    = 370 * fontScaler
end

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
tracker.rowPerQn = 4 -- The default
tracker.newRowPerQn = 4
tracker.maxRowPerQn = 16

tracker.harmonyActive = 0
tracker.noteNamesActive = 0
tracker.helpActive = 0
tracker.optionsActive = 0
tracker.renaming = 0
tracker.minoct = -1
tracker.maxoct = 12
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

tracker.shiftChordInProgress = false -- is the user currently inputting a chord with the shift key?
tracker.shiftChordStartXpos = nil -- what column should we return cursor to when shift is released? only set while shiftChordInProgress

keyLayouts = {'QWERTY', 'QWERTZ', 'AZERTY'}
fontSizes = {12, 14, 16, 18, 20, 22}
fx1Options = {0, 1, 2, 3}
fx2Options = {0, 1, 2, 3, 4, 5, 6}

-- Default configuration
tracker.cfg = {}
tracker.cfg.colorscheme = "buzz"
tracker.cfg.keyset = "default"
tracker.cfg.fontSize = 14
tracker.cfg.channelCCs = 0
tracker.cfg.autoResize = 1
tracker.cfg.loopFollow = 0
tracker.cfg.initLoopSet = 0
tracker.cfg.followSelection = 0
tracker.cfg.stickToBottom = 0
tracker.cfg.colResize = 1
tracker.cfg.alwaysRecord = 0
tracker.cfg.minimumSize = 1
tracker.cfg.CRT = 0
tracker.cfg.keyboard = "buzz"
tracker.cfg.rowPerQn = 4
tracker.cfg.storedSettings = 1
tracker.cfg.followSong = 0
tracker.cfg.page = tracker.page
tracker.cfg.oldBlockBehavior = 0
tracker.cfg.keyLayout = "QWERTY"
tracker.cfg.noResize = 0
tracker.cfg.maxWidth = 50000
tracker.cfg.maxHeight = 50000
tracker.cfg.rowOverride = 0
tracker.cfg.overridePerPattern = 1
tracker.cfg.closeWhenSwitchingToHP = 0
tracker.cfg.followRow = 0
tracker.cfg.useItemColors = 0
tracker.cfg.returnAfterChord = 1
tracker.cfg.fx1 = 0
tracker.cfg.fx2 = 0
tracker.cfg.showedWarning = 0
tracker.cfg.alwaysShowNoteEnd = 0
tracker.cfg.alwaysShowDelays = 0

-- Defaults
tracker.cfg.transpose = 3
tracker.cfg.advance = 1
tracker.cfg.envShape = 1
tracker.cfg.modMode = 0

tracker.binaryOptions = {
    { 'autoResize', 'Auto Resize' },
    { 'followSelection', 'Follow Selection' },
    { 'storedSettings', 'Use settings stored in pattern' },
    { 'followSong', 'Follow Song (CTRL + F)' },
    { 'stickToBottom', 'Info Sticks to Bottom' },
    { 'colResize', 'Adjust Column Count to Window' },
    { 'alwaysRecord', 'Always Enable Recording' },
    { 'CRT', 'CRT mode' },
    { 'oldBlockBehavior', 'Do not mend after paste' },
    { 'channelCCs', 'Enable CCs for channels > 0 (beta)' },
    { 'loopFollow', 'Set loop on pattern switch' },
    { 'initLoopSet', 'Set loop when tracker is opened' },
    { 'minimumSize', 'Force minimum size'},
    { 'noResize', 'Fix plugin size'},
    { 'overridePerPattern', 'Override per pattern'},
    { 'closeWhenSwitchingToHP', 'Allow commands to close HT'},
    { 'followRow', 'Follow row in arrange view' },
    { 'useItemColors', 'Use item colors in headers' },
    { 'returnAfterChord', 'Return to first column after chords' },
    { 'alwaysShowNoteEnd', 'Always show note end' },
    { 'alwaysShowDelays', 'Always show note delay' },
    }

tracker.colorschemes = {"default", "buzz", "it", "hacker", "renoise", "renoiseB", "buzz2"}

noteNames = {}

local function print(...)
  if ( not ... ) then
    reaper.ShowConsoleMsg("nil value\n")
    return
  end
  reaper.ShowConsoleMsg(...)
  reaper.ShowConsoleMsg("\n")
end

function tracker:loadColors(colorScheme)
  -- If you come up with a cool alternative color scheme, let me know
  self.colors = {}
  self.colors.bar = {}
  self.colors.normal = {}
  self.colors.patternFont = nil
  self.colors.patternFontSize = nil
  local colorScheme = colorScheme or tracker.cfg.colorscheme

  if colorScheme == "default" then
  -- default
    self.colors.shadercolor  = {.8, .0, .5}
    self.colors.helpcolor    = {.8, .8, .9, 1}
    self.colors.helpcolor2   = {.7, .7, .9, 1}
    self.colors.selectcolor  = {.6, 0, .6, 1}
    self.colors.textcolor    = {.7, .8, .8, 1}
    self.colors.headercolor  = {.5, .5, .8, 1}
    self.colors.inactive     = {.2, .2, .3, 1}
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
    self.crtStrength         = 2
  elseif colorScheme == "hacker" then
    self.colors.shadercolor  = {.3, .7, .6}
    self.colors.helpcolor    = {0, .4, .2, 1}
    self.colors.helpcolor2   = {0, .7, .3, 1}
    self.colors.selectcolor  = {0, .3, 0, 1}
    self.colors.textcolor    = {0, .8, .4, 1}
    self.colors.textcolorbar = {0.05, 1.0, .7, 1}
    self.colors.headercolor  = {0, .9, .5, 1}
    self.colors.inactive     = {0, .3, .1, 1}
    self.colors.linecolor    = {0, .1, 0, .4}
    self.colors.linecolor2   = {0, .3, .2, .4}
    self.colors.linecolor3   = {0, .2, 0, 1}
    self.colors.linecolor4   = {0, .1, .1, .5}
    self.colors.linecolor5   = {0, .6, .5, .4}
    self.colors.loopcolor    = {0, .3, 0, .5}
    self.colors.copypaste    = {0, .7, .5, .2}
    self.colors.scrollbar1   = {0, .1, 0, 1.0}
    self.colors.scrollbar2   = {0, .0, 0, 1.0}
    self.colors.changed      = {.4,  1, .4, 1.0}
    self.colors.changed2     = {.4,  .5, .4, .5} -- Only listening
    self.colors.windowbackground = {0, 0, 0, 1}
    self.crtStrength         = 4
    self.colors.ellipsis     = 1
  elseif colorScheme == "buzz" then
    -- Buzz
    self.colors.shadercolor      = {.55, .55, .54}
    self.colors.helpcolor        = {1/256*159, 1/256*147, 1/256*115, 1} -- the functions
    self.colors.helpcolor2       = {1/256*48, 1/256*48, 1/256*33, 1} -- the keys
    self.colors.selectcolor      = {37/256, 41/256, 54/256, 1} -- the cursor
    self.colors.selecttext       = {207/256, 207/256, 222/256, 1} -- the cursor
    self.colors.textcolor        = {1/256*48, 1/256*48, 1/256*33, 1} -- main pattern data
    self.colors.headercolor      = {1/256*48, 1/256*48, 1/256*33, 1} -- column headers, statusbar etc
    self.colors.inactive         = {1/256*178, 1/256*174, 1/256*161, 1} -- column headers, statusbar etc
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
    self.crtStrength             = .3
  elseif colorScheme == "it" then
    -- Reapulse Tracker (Impulse Tracker)
    self.colors.shadercolor      = {1/256*88, 1/256*64, 1/256*60}
    self.colors.helpcolor        = {0, 0, 0, 1} -- the functions
    self.colors.helpcolor2       = {1/256*124, 1/256*88, 1/256*68, 1} -- the keys
    self.colors.selectcolor      = {1, 1, 1, 1} -- the cursor
    self.colors.textcolor        = {1, 1, 1, 1} --{1/256*60, 1/256*105, 1/256*59, 1} -- main pattern data (rows should all be darker & this should be green)
    self.colors.headercolor      = {0, 0, 0, 1} -- column headers, statusbar etc
    self.colors.inactive         = {.2, .2, .2, 1} -- column headers, statusbar etc
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
    self.crtStrength             = .5
  elseif colorScheme == "renoise" then
    self.colors.ellipsis         = 1
    self.colors.shadercolor      = {177/255, 171/255, 116/255, 1.0}
    self.colors.harmonycolor     = {177/255, 171/255, 116/255, 1.0}
    self.colors.harmonyselect    = {183/255, 255/255, 191/255, 1.0}
    self.colors.helpcolor        = {243/255, 171/255, 116/255, 1.0} -- the functions
    self.colors.helpcolor2       = {178/256, 178/256, 178/256, 1} -- the keys
    self.colors.selectcolor      = {1, 234/256, 20/256, 1} -- the cursor
    self.colors.selecttext       = {0, 0, 0, 1} -- the cursor
    self.colors.textcolor        = {148/256, 148/256, 148/256, 1} --{1/256*60, 1/256*105, 1/256*59, 1} -- main pattern data (rows should all be darker & this should be green)
    self.colors.textcolorbar     = {1, 1, 1, 1}
    self.colors.headercolor      = {215/256, 215/256, 215/256, 1} -- column headers, statusbar etc
    self.colors.inactive         = {115/256, 115/256, 115/256, 1} -- column headers, statusbar etc
    self.colors.linecolor        = {18/256,18/256,18/256, 0.6} -- normal row
    self.colors.linecolor2       = {1/256*55, 1/256*55, 1/256*55, 0.6} -- beats (must not have 100% alpha as it's drawn over the cursor(!))
    self.colors.linecolor3       = {1/256*180, 1/256*148, 1/256*120, 1} -- scroll indicating trangle thingy
    self.colors.linecolor4       = {1/256*204, 1/256*204, 1/256*68, 1} -- Reaper edit cursor
    self.colors.linecolor5       = {41/256, 41/256, 41/256, 1.0} -- Bar start
    self.colors.loopcolor        = {1/256*204, 1/256*204, 1/256*68, 1} -- lines surrounding loop
    self.colors.copypaste        = {1/256*57, 1/256*57, 1/256*20, 0.66}  -- the selection (should be lighter(not alpha blanded) but is drawn over the data)
    self.colors.scrollbar1       = {98/256, 98/256, 98/256, 1} -- scrollbar handle & outline
    self.colors.scrollbar2       = {19/256, 19/256, 19/256, 1} -- scrollbar background
    self.colors.changed          = {1, 1, 0, 1}
    self.colors.changed2         = {0, .5, 1, .5} -- Only listening
    self.colors.windowbackground = {18/256, 18/256, 18/256, 1}
    self.crtStrength             = 0

    self.colors.normal.mod1      = {243/255, 171/255, 116/255, 1.0}
    self.colors.normal.mod2      = self.colors.normal.mod1
    self.colors.normal.mod3      = self.colors.normal.mod1
    self.colors.normal.mod4      = self.colors.normal.mod1
    self.colors.normal.modtxt1   = {243/255, 171/255, 116/255, 1.0}
    self.colors.normal.modtxt2   = self.colors.normal.modtxt1
    self.colors.normal.modtxt3   = self.colors.normal.modtxt1
    self.colors.normal.modtxt4   = self.colors.normal.modtxt1
    self.colors.normal.vel1      = {186/255, 185/255, 108/255, 1.0}
    self.colors.normal.vel2      = self.colors.normal.vel1
    self.colors.normal.delay1    = {123/255, 149/255, 197/255, 1.0}
    self.colors.normal.delay2    = self.colors.normal.delay1
    self.colors.normal.fx1       = {183/255, 255/255, 191/255, 1.0}
    self.colors.normal.fx2       = self.colors.normal.fx1
    self.colors.normal.end1      = {136/255, 80/255, 178/255, 1.0}
    self.colors.normal.end2      = self.colors.normal.end1

    self.colors.bar.mod1         = {255/255, 159/255, 88/255, 1.0}
    self.colors.bar.mod2         = self.colors.bar.mod1
    self.colors.bar.mod3         = self.colors.bar.mod1
    self.colors.bar.mod4         = self.colors.bar.mod1
    self.colors.bar.modtxt1      = {255/255, 159/255, 88/255, 1.0}
    self.colors.bar.modtxt2      = self.colors.bar.modtxt1
    self.colors.bar.modtxt3      = self.colors.bar.modtxt1
    self.colors.bar.modtxt4      = self.colors.bar.modtxt1
    self.colors.bar.vel1         = {171/255, 169/255, 77/255, 1.0}
    self.colors.bar.vel2         = self.colors.bar.vel1
    self.colors.bar.delay1       = {116/255, 162/255, 255/255, 1.0}
    self.colors.bar.delay2       = self.colors.bar.delay1
    self.colors.bar.fx1          = {146/255, 255/255, 157/255, 1.0}
    self.colors.bar.fx2          = self.colors.normal.fx1
    self.colors.bar.end1         = {136/255, 80/255, 178/255, 1.0}
    self.colors.bar.end2         = self.colors.bar.end1
  elseif colorScheme == "renoiseB" then
    self.colors.ellipsis         = 1
    self.colors.shadercolor      = {177/255, 171/255, 116/255, 1.0}    
    self.colors.harmonycolor     = {177/255, 171/255, 116/255, 1.0}
    self.colors.harmonyselect    = {183/255, 255/255, 191/255, 1.0}
    self.colors.helpcolor        = {243/255, 171/255, 116/255, 1.0} -- the functions
    self.colors.helpcolor2       = {178/256, 178/256, 178/256, 1} -- the keys
    self.colors.selectcolor      = {1, 234/256, 20/256, 1} -- the cursor
    self.colors.selecttext       = {0, 0, 0, 1} -- the cursor
    self.colors.textcolor        = {148/256, 148/256, 148/256, 1} --{1/256*60, 1/256*105, 1/256*59, 1} -- main pattern data (rows should all be darker & this should be green)
    self.colors.textcolorbar     = {1, 1, 1, 1}
    self.colors.headercolor      = {215/256, 215/256, 215/256, 1} -- column headers, statusbar etc
    self.colors.inactive         = {115/256, 115/256, 115/256, 1} -- column headers, statusbar etc
    self.colors.linecolor        = {18/256,18/256,18/256, 0.6} -- normal row
    self.colors.linecolor2       = {1/256*55, 1/256*55, 1/256*55, 0.6} -- beats (must not have 100% alpha as it's drawn over the cursor(!))
    self.colors.linecolor3       = {1/256*180, 1/256*148, 1/256*120, 1} -- scroll indicating trangle thingy
    self.colors.linecolor4       = {1/256*204, 1/256*204, 1/256*68, 1} -- Reaper edit cursor
    self.colors.linecolor5       = {41/256, 41/256, 41/256, 1.0} -- Bar start
    self.colors.loopcolor        = {1/256*204, 1/256*204, 1/256*68, 1} -- lines surrounding loop
    self.colors.copypaste        = {1/256*57, 1/256*57, 1/256*20, 0.66}  -- the selection (should be lighter(not alpha blanded) but is drawn over the data)
    self.colors.scrollbar1       = {98/256, 98/256, 98/256, 1} -- scrollbar handle & outline
    self.colors.scrollbar2       = {19/256, 19/256, 19/256, 1} -- scrollbar background
    self.colors.changed          = {1, 1, 0, 1}
    self.colors.changed2         = {0, .5, 1, .5} -- Only listening
    self.colors.windowbackground = {18/256, 18/256, 18/256, 1}
    self.crtStrength             = 0

    self.colors.normal.mod1      = {243/255, 171/255, 116/255, 1.0}
    self.colors.normal.mod2      = self.colors.normal.mod1
    self.colors.normal.mod3      = self.colors.normal.mod1
    self.colors.normal.mod4      = self.colors.normal.mod1
    self.colors.normal.modtxt1   = {243/255, 171/255, 116/255, 1.0}
    self.colors.normal.modtxt2   = self.colors.normal.modtxt1
    self.colors.normal.modtxt3   = self.colors.normal.modtxt1
    self.colors.normal.modtxt4   = self.colors.normal.modtxt1
    self.colors.normal.vel1      = {186/255, 185/255, 108/255, 1.0}
    self.colors.normal.vel2      = self.colors.normal.vel1
    self.colors.normal.delay1    = {123/255, 149/255, 197/255, 1.0}
    self.colors.normal.delay2    = self.colors.normal.delay1
    self.colors.normal.fx1       = {183/255, 255/255, 191/255, 1.0}
    self.colors.normal.fx2       = self.colors.normal.fx1
    self.colors.normal.end1      = {136/255, 80/255, 178/255, 1.0}
    self.colors.normal.end2      = self.colors.normal.end1

    self.colors.bar.mod1         = {255/255, 159/255, 88/255, 1.0}
    self.colors.bar.mod2         = self.colors.bar.mod1
    self.colors.bar.mod3         = self.colors.bar.mod1
    self.colors.bar.mod4         = self.colors.bar.mod1
    self.colors.bar.modtxt1      = {255/255, 159/255, 88/255, 1.0}
    self.colors.bar.modtxt2      = self.colors.bar.modtxt1
    self.colors.bar.modtxt3      = self.colors.bar.modtxt1
    self.colors.bar.modtxt4      = self.colors.bar.modtxt1
    self.colors.bar.vel1         = {171/255, 169/255, 77/255, 1.0}
    self.colors.bar.vel2         = self.colors.bar.vel1
    self.colors.bar.delay1       = {116/255, 162/255, 255/255, 1.0}
    self.colors.bar.delay2       = self.colors.bar.delay1
    self.colors.bar.fx1          = {146/255, 255/255, 157/255, 1.0}
    self.colors.bar.fx2          = self.colors.normal.fx1
    self.colors.bar.end1         = {136/255, 80/255, 178/255, 1.0}
    self.colors.bar.end2         = self.colors.bar.end1

    self.colors.patternFont         = "DejaVu Sans"
    self.colors.patternFontSize     = tracker.cfg.fontSize or 14
    self.colors.customFontDisplace  = { self.colors.patternFontSize-6, -3 }
  elseif colorScheme == "buzz2" then
    -- Buzz
    self.colors.shadercolor      = {.55, .55, .54}
    self.colors.helpcolor        = {1/256*159, 1/256*147, 1/256*115, 1} -- the functions
    self.colors.helpcolor2       = {1/256*48, 1/256*48, 1/256*33, 1} -- the keys
    self.colors.selectcolor      = {37/256, 41/256, 54/256, 1} -- the cursor
    self.colors.selecttext       = {207/256, 207/256, 222/256, 1} -- the cursor
    self.colors.textcolor        = {1/256*48, 1/256*48, 1/256*33, 1} -- main pattern data
    self.colors.headercolor      = {1/256*48, 1/256*48, 1/256*33, 1} -- column headers, statusbar etc
    self.colors.inactive         = {1/256*178, 1/256*174, 1/256*161, 1} -- column headers, statusbar etc
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
    self.crtStrength             = 0

    self.colors.patternFont         = "DejaVu Sans"
    self.colors.patternFontSize     = tracker.cfg.fontSize or 14
    self.colors.customFontDisplace  = { self.colors.patternFontSize-6, -3 }
  end
  -- clear colour is in a different format
  gfx.clear = tracker.colors.windowbackground[1]*256+(tracker.colors.windowbackground[2]*256*256)+(tracker.colors.windowbackground[3]*256*256*256)
end

-- Can customize the shortcut keys here, if they aren't working for you
-- If you come up with good alternate layouts (maybe based on impulse, screamtracker
-- or other language keyboards), please share them with me and I'll provide some form
-- of chooser here.

-- Default when no config file is present
keysets = { "default", "buzz", "renoise" }
keys = {}

local function reinitializeWindow(title, iwidth, iheight, id, iwx, iwh)
  local v, wx, wy, ww, wh
  local d, wx, wh, ww, wh = gfx.dock(-1, 1, 1, 1, 1)

  if ( iwidth > tracker.cfg.maxWidth ) then
    iwidth = tracker.cfg.maxWidth
  end
  if ( iheight > tracker.cfg.maxHeight ) then
    iheight = tracker.cfg.maxHeight
  end

  if ( tracker.cfg.noResize == 0 and not tracker.attemptedReset ) then
    if ( ww ~= iwidth or wh ~= iheight ) then
      gfx.quit()
      gfx.init( title, iwidth, iheight, id, iwx, iwh)
      tracker.attemptedReset = 1
    end
  end
end

-- You can find the keycodes by setting printKeys to 1 and hitting any key.
function tracker:loadKeys( keySet )
  local keyset = keySet or tracker.cfg.keyset

  keys.options2 = { 1, 0, 0, 15 } -- ctrl + o
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
    keys.playfrom       = { 1,    0,  0,    13 }            -- Ctrl + Enter
    keys.enter          = { 0,    0,  0,    13 }            -- Enter
    keys.playline       = { 0,    0,  1,    32 }            -- Ctrl + Space
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
    keys.noteNames      = { 0,    0,  0,    6697264 }       -- F10
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
    keys.resolutionUp   = { 0,    1,  1,    30064 }         -- SHIFT + Alt + Up
    keys.resolutionDown = { 0,    1,  1,    1685026670 }    -- SHIFT + Alt + Down
    keys.commit         = { 0,    1,  1,    13 }            -- SHIFT + Alt + Enter
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
    keys.addColAll      = { 1,    0,  1,    1 }             -- CTRL + Shift + A
    keys.addPatchSelect = { 1,    0,  1,    16 }            -- CTRL + Shift + P
    keys.tab            = { 0,    0,  0,    9 }             -- Tab
    keys.shifttab       = { 0,    0,  1,    9 }             -- SHIFT + Tab
    keys.follow         = { 1,    0,  0,    6 }             -- CTRL + F
    keys.deleteRow      = { 1,    0,  0,    6579564 }       -- Ctrl + Del
    keys.closeTracker   = { 1,    0,  0,    6697266 }       -- Ctrl + F12
    keys.nextTrack      = { 1,    0,  1,    1919379572.0 }  -- CTRL + Shift + ->
    keys.prevTrack      = { 1,    0,  1,    1818584692.0 }  -- CTRL + Shift + <-
    keys.solo           = { 1,    0,  0,    19 }            -- Solo channel
    keys.mute           = { 1,    0,  0,    1 }             -- Mute/Unmute channel    

    keys.insertRow      = { 1,    0,  0,    6909555 }       -- Insert row CTRL+Ins
    keys.removeRow      = { 1,    0,  0,    8 }             -- Remove Row CTRL+Backspace
    keys.wrapDown       = { 1,    0,  1,    6909555 }       -- CTRL + SHIFT + Ins
    keys.wrapUp         = { 1,    0,  1,    8 }             -- CTRL + SHIFT + Backspace

    keys.m0             = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m25            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m50            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m75            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.off2           = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.renoiseplay    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shpatdown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shpatup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shcoldown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shcolup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shblockdown    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shblockup      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.upByAdvance    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.downByAdvance  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceDouble  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceHalve   = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned

    keys.cutPattern     = { 1,    0,  0,    500000000000000000000000 }
    keys.cutColumn      = { 1,    0,  1,    500000000000000000000000 }
    keys.cutBlock2      = { 1,    1,  0,    500000000000000000000000 }
    keys.copyPattern    = { 1,    0,  0,    500000000000000000000000 }
    keys.copyColumn     = { 1,    0,  1,    500000000000000000000000 }
    keys.copyBlock2     = { 1,    1,  0,    500000000000000000000000 }
    keys.pastePattern   = { 1,    0,  0,    500000000000000000000000 }
    keys.pasteColumn    = { 1,    0,  1,    500000000000000000000000 }
    keys.pasteBlock2    = { 1,    1,  0,    500000000000000000000000 }
    keys.patternOctDown = { 1,    0,  0,    500000000000000000000000.0 }
    keys.patternOctUp   = { 1,    0,  0,    500000000000000000000000.0 }
    keys.colOctDown     = { 1,    0,  1,    500000000000000000000000.0 }
    keys.colOctUp       = { 1,    0,  1,    500000000000000000000000.0 }
    keys.blockOctDown   = { 1,    1,  0,    500000000000000000000000.0 }
    keys.blockOctUp     = { 1,    1,  0,    500000000000000000000000.0 }

    keys.shiftpgdn      = { 0,    0,  1,    1885824110 }    -- Shift + PgDn
    keys.shiftpgup      = { 0,    0,  1,    1885828464 }    -- Shift + PgUp
    keys.shifthome      = { 0,    0,  1,    1752132965 }    -- Shift + Home
    keys.shiftend       = { 0,    0,  1,    6647396 }       -- Shift + End

    keys.startPat       = { 0,    0,  0,    13,  "Hackey Sequencer/Sequencer/HackeyPatterns_exec.lua", 1 }

    help = {
      { 'Shift + Note', 'Advance column after entry' },
      { 'Insert/Backspace/-', 'Insert/Remove/Note OFF' },
      { 'CTRL + Insert/Backspace', 'Insert Row/Remove Row' },
      { 'CTRL + Shift + Ins/Bksp', 'Wrap Forward/Backward' },
      { 'Del/.', 'Delete' },
      { 'Space/CTRL + Return', 'Play/Play From' },
      { 'CTRL + L', 'Loop pattern' },
      { 'CTRL + Q/W', 'Loop start/end' },
      { 'Shift + +/-', 'Transpose selection' },
      { 'CTRL + B/E', 'Selection begin/End' },
      { 'SHIFT + Arrow Keys', 'Block selection' },
      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },
      { 'CTRL + I', 'Interpolate' },
      { 'Shift + Del', 'Delete block' },
      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' },
      { 'SHIFT + Alt + Up/Down', '[Res]olution Up/Down' },
      { 'SHIFT + Alt + Enter', '[Res]olution Commit' },
      { 'CTRL + Up/Down', '[Oct]ave up/down' },
      { 'CTRL + Shift + Up/Down', '[Env]elope change' },
      { 'F4/F5', '[Adv]ance De/Increase' },
      { 'F2/F3', 'MIDI [out] down/up' },
      { 'F8/F12', 'Stop / Panic' },
      { 'F10/F11', 'Note Names / Options' },
      { 'CTRL + Left/Right', 'Switch MIDI item/track' },
      { 'CTRL + Shift + Left/Right', 'Switch Track' },
      { 'CTRL + D', 'Duplicate pattern' },
      { 'CTRL + N', 'Rename pattern' },
      { 'CTRL + R', 'Play notes' },
      { 'CTRL + +/-', 'Advanced col options' },
      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },
      { 'CTRL + Shift + A/P', 'Per channel CC/PC' },
      { 'CTRL + Shift + Click row indicator', 'Change highlighting (RMB resets)' },
      { '', '' },
      { 'Harmony helper', '' },
      { 'F9', 'Toggle harmonizer' },
      { 'CTRL + Click', 'Insert chord' },
      { 'Alt', 'Invert first note' },
      { 'Shift', 'Invert second note' },
      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },
      { 'CTRL + S / CTRL + A', '(un)Solo / (un)Mute' },      
    }

  elseif keyset == "buzz" then
    --                    CTRL    ALT SHIFT Keycode
    keys.playline       = { 0,    0,  1,    32 }            -- Ctrl + Space
    keys.left           = { 0,    0,  0,    1818584692 }    -- <-
    keys.right          = { 0,    0,  0,    1919379572 }    -- ->
    keys.up             = { 0,    0,  0,    30064 }         -- /\
    keys.down           = { 0,    0,  0,    1685026670 }    -- \/
    keys.off            = { 0,    0,  0,    96 }            -- ` (should be 1 but whatever)
    keys.delete         = { 0,    0,  0,    6579564 }       -- Del
    keys.delete2        = { 0,    0,  0,    46 }            -- .
    keys.home           = { 0,    0,  0,    1752132965 }    -- Home
    keys.End            = { 0,    0,  0,    6647396 }       -- End
    keys.enter          = { 0,    0,  0,    13 }            -- Enter
    keys.toggle         = { 0,    0,  0,    26165 }         -- f5 = play/pause
    keys.playfrom       = { 0,    0,  0,    26166 }         -- f6 = play here
    keys.stop2          = { 0,    0,  0,    26168 }         -- f8 = Stop
    keys.harmony        = { 0,    0,  0,    26169 }         -- f9 = Harmony helper
    keys.noteNames      = { 0,    0,  0,    6697264 }       -- F10
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
    keys.resolutionUp   = { 0,    1,  1,    30064 }         -- SHIFT + Alt + Up    (no equiv, would be set in pattern properties)
    keys.resolutionDown = { 0,    1,  1,    1685026670 }    -- SHIFT + Alt + Down  (ditto)
    keys.commit         = { 0,    1,  1,    13 }            -- SHIFT + Alt + Enter (ditto)
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
    keys.follow         = { 1,    0,  0,    6 }             -- CTRL + F
    keys.deleteRow      = { 1,    0,  0,    6579564 }       -- Ctrl + Del
    keys.addColAll      = { 1,    0,  1,    1 }             -- CTRL + Shift + A
    keys.addPatchSelect = { 1,    0,  1,    16 }            -- CTRL + Shift + P
    keys.nextTrack      = { 1,    0,  1,    1919379572.0 }  -- CTRL + Shift + ->
    keys.prevTrack      = { 1,    0,  1,    1818584692.0 }  -- CTRL + Shift + <-

    keys.insertRow      = { 1,    1,  0,    6909555 }       -- Insert row CTRL+Alt+Ins
    keys.removeRow      = { 1,    1,  0,    8 }             -- Remove Row CTRL+Alt+Backspace
    keys.wrapDown       = { 1,    0,  1,    6909555 }       -- CTRL + SHIFT + Ins
    keys.wrapUp         = { 1,    0,  1,    8 }             -- CTRL + SHIFT + Backspace

    keys.m0             = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m25            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m50            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.m75            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.off2           = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.renoiseplay    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shpatdown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shpatup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shcoldown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shcolup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shblockdown    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.shblockup      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.upByAdvance    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.downByAdvance  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceDouble  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceHalve   = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned

    keys.cutPattern     = { 1,    0,  0,    500000000000000000000000 }
    keys.cutColumn      = { 1,    0,  1,    500000000000000000000000 }
    keys.cutBlock2      = { 1,    1,  0,    500000000000000000000000 }
    keys.copyPattern    = { 1,    0,  0,    500000000000000000000000 }
    keys.copyColumn     = { 1,    0,  1,    500000000000000000000000 }
    keys.copyBlock2     = { 1,    1,  0,    500000000000000000000000 }
    keys.pastePattern   = { 1,    0,  0,    500000000000000000000000 }
    keys.pasteColumn    = { 1,    0,  1,    500000000000000000000000 }
    keys.pasteBlock2    = { 1,    1,  0,    500000000000000000000000 }
    keys.patternOctDown = { 1,    0,  0,    500000000000000000000000.0 }
    keys.patternOctUp   = { 1,    0,  0,    500000000000000000000000.0 }
    keys.colOctDown     = { 1,    0,  1,    500000000000000000000000.0 }
    keys.colOctUp       = { 1,    0,  1,    500000000000000000000000.0 }
    keys.blockOctDown   = { 1,    1,  0,    500000000000000000000000.0 }
    keys.blockOctUp     = { 1,    1,  0,    500000000000000000000000.0 }
    keys.closeTracker   = { 0,    0,  0,    500000000000000000000000 }      -- Unassigned
    keys.addColAll      = { 1,    0,  1,    1 }             -- CTRL + Shift + A
    keys.shiftpgdn      = { 0,    0,  1,    1885824110 }    -- Shift + PgDn
    keys.shiftpgup      = { 0,    0,  1,    1885828464 }    -- Shift + PgUp
    keys.shifthome      = { 0,    0,  1,    1752132965 }    -- Shift + Home
    keys.shiftend       = { 0,    0,  1,    6647396 }       -- Shift + End
    keys.solo           = { 1,    0,  0,    19 }            -- Solo channel
    keys.mute           = { 1,    0,  0,    1 }             -- Mute/Unmute channel

    keys.startPat       = { 0,    0,  0,    13,  "Hackey Sequencer/Sequencer/HackeyPatterns_exec.lua", 1 }

    help = {
      { 'Shift + Note', 'Advance column after entry' },
      { '`', 'Note OFF' },
      { 'Insert/Backspace', 'Insert/Remove line' },
      { 'CTRL + Alt + Insert/Backspace', 'Insert Row/Remove Row' },
      { 'CTRL + Shift + Insert/Backspace', 'Wrap Forward/Backward' },
      { 'Del/.', 'Delete' },
      { 'F5/F6', 'Play/Play from here' },
      { 'F8/F12', 'Stop / Panic' },
      { 'F10/F11', 'Note Names / Options' },
      { 'CTRL + L', 'Loop pattern' },
      { 'CTRL + Q/W', 'Loop start/end' },
      { 'Shift + +/-', 'Transpose selection' },
      { 'CTRL + B/E', 'Selection Begin/End' },
      { 'SHIFT + Arrow Keys', 'Block selection' },
      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },
      { 'CTRL + I', 'Interpolate' },
      { 'Shift + Del', 'Delete block' },
      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' },
      { 'SHIFT + Alt + Up/Down', '[Res]olution Up/Down' },
      { 'SHIFT + Alt + Return', '[Res]olution Commit' },
      { '*//', '[Oct]ave Up/Down' },
      { 'CTRL + Shift + Up/Down', '[Env]elope change' },
      { 'CTRL + F1/F2', '[Adv]ance De/Increase' },
      { 'CTRL + Up/Down', 'MIDI [out] Up/Down' },
      { '-/+', 'Switch MIDI item' },
      { 'CTRL + Shift + Left/Right', 'Switch track' },
      { 'CTRL + Shift + Return', 'Duplicate pattern' },
      { 'CTRL + Backspace', 'Rename pattern' },
      { 'F7', 'Toggle note play' },
      { 'CTRL + +/-', 'Advanced col options' },
      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },
      { 'CTRL + Shift + A/P', 'Per channel CC/PC' },
      { 'CTRL + Shift + Click row indicator', 'Change highlighting (RMB resets)' },
      { '', '' },
      { 'Harmony helper', '' },
      { 'F9', 'Toggle harmonizer' },
      { 'CTRL + Click', 'Insert chord' },
      { 'Alt', 'Invert first note' },
      { 'Shift', 'Invert second note' },
      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },
      { 'CTRL + S / CTRL + A', '(un)Solo / (un)Mute' },
    }
  elseif keyset == "renoise" then
    --                    CTRL    ALT SHIFT Keycode
    keys.solo           = { 1,    0,  0,    19 }            -- Solo channel
    keys.mute           = { 1,    0,  0,    1 }             -- Mute/Unmute channel    
    keys.playline       = { 0,    0,  1,    32 }            -- Ctrl + Space
    keys.left           = { 0,    0,  0,    1818584692 }    -- <-
    keys.right          = { 0,    0,  0,    1919379572 }    -- ->
    keys.up             = { 0,    0,  0,    30064 }         -- /\
    keys.down           = { 0,    0,  0,    1685026670 }    -- \/
    keys.off            = { 0,    0,  0,    92 }            -- Backslash (\) (temporary)
    keys.delete         = { 0,    0,  0,    500000000000000000000000 }        -- Not assigned
    keys.delete2        = { 0,    0,  0,    6579564 }       -- Del
    keys.home           = { 0,    0,  0,    1752132965 }    -- Home
    keys.End            = { 0,    0,  0,    6647396 }       -- End
    keys.enter          = { 0,    0,  0,    13 }            -- Enter
    keys.renoiseplay    = { 0,    0,  0,    32 }            -- Play/pause (space)
    keys.playfrom       = { 0,    0,  1,    32 }            -- Shift + space
    keys.stop2          = { 0,    0,  0,    500000000000000000000000 }  -- Not assigned
    keys.harmony        = { 1,    0,  0,    8  }             -- ctrl+h harmony helper
    keys.noteNames      = { 1,    0,  0,    13 }            -- CTRL + m
    keys.options        = { 1,    0,  0,    15 }            -- ctrl+o options
    keys.panic          = { 0,    0,  0,    27 }            -- Escape = MIDI Panic!
    keys.insert         = { 0,    0,  0,    6909555 }       -- Insert
    keys.remove         = { 0,    0,  0,    8 }             -- Backspace
    keys.pgup           = { 0,    0,  0,    1885828464 }    -- Page up
    keys.pgdown         = { 0,    0,  0,    1885824110 }    -- Page down
    keys.m0             = { 0,    0,  0,    26169.0 }       -- F9
    keys.m25            = { 0,    0,  0,    6697264.0 }     -- F10
    keys.m50            = { 0,    0,  0,    6697265.0 }     -- F11
    keys.m75            = { 0,    0,  0,    6697266.0 }     -- F12
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
    keys.outchanup      = { 0,    0,  0,    43 }            -- +
    keys.outchandown    = { 0,    0,  0,    45 }            -- -
    keys.advancedown    = { 1,    0,  0,    13 }            -- CTRL + -
    keys.advanceup      = { 1,    0,  0,    11 }            -- CTRL + +
    keys.setloop        = { 0,    0,  0,    13 }            -- Enter
    keys.setloopstart   = { 1,    0,  0,    17 }            -- CTRL + Q (ditto)
    keys.setloopend     = { 1,    0,  0,    23 }            -- CTRL + W (ditto)
    keys.interpolate    = { 1,    0,  0,    9 }             -- CTRL + I
    keys.shiftleft      = { 0,    0,  1,    1818584692 }    -- Shift + <-
    keys.shiftright     = { 0,    0,  1,    1919379572 }    -- Shift + ->
    keys.shiftup        = { 0,    0,  1,    30064 }         -- Shift + /\
    keys.shiftdown      = { 0,    0,  1,    1685026670 }    -- Shift + \/
    keys.deleteBlock    = { 0,    0,  1,    6579564 }       -- Shift + Del
    keys.resolutionUp   = { 0,    1,  1,    30064 }         -- SHIFT + Alt + Up    (no equiv, would be set in pattern properties)
    keys.resolutionDown = { 0,    1,  1,    1685026670 }    -- SHIFT + Alt + Down  (ditto)
    keys.commit         = { 0,    1,  1,    13 }            -- SHIFT + Alt + Enter (ditto)
    keys.nextMIDI       = { 1,    0,  0,    1685026670.0 }  -- CTRL + /\
    keys.prevMIDI       = { 1,    0,  0,    30064.0 }       -- CTRL + \/
    keys.duplicate      = { 1,    0,  1,    13 }            -- CTRL + Shift + Return = create copy
    keys.rename         = { 1,    0,  1,    14 }            -- CTRL + SHIFT + N
    keys.escape         = { 0,    0,  0,    27 }            -- Escape
    keys.toggleRec      = { 1,    0,  0,    18 }            -- CTRL + N
    keys.showMore       = { 1,    1,  0,    267 }           -- CTRL + Alt + +
    keys.showLess       = { 1,    1,  0,    269 }           -- CTRL + Alt + -
    keys.addCol         = { 1,    0,  1,    11 }            -- CTRL + Shift + +
    keys.remCol         = { 1,    0,  1,    13 }            -- CTRL + Shift + -
    keys.addColAll      = { 1,    0,  1,    1 }             -- CTRL + Shift + A
    keys.addPatchSelect = { 1,    0,  1,    16 }            -- CTRL + Shift + P
    keys.tab            = { 0,    0,  0,    9 }             -- Tab
    keys.shifttab       = { 0,    0,  1,    9 }             -- SHIFT + Tab
    keys.follow         = { 1,    0,  0,    6 }             -- CTRL + F

    local noteOff = '\\ or A'
    if tracker.cfg.keyLayout == "AZERTY" then
      keys.off2           = { 0,    0,  0,    113 }           -- Q
      keys.off            = { 0,    0,  0,    -1 }
      noteOff = 'Q'
    else
      keys.off2           = { 0,    0,  0,    97 }            -- A
    end

    keys.shpatdown      = { 1,    0,  0,    26161 }         -- CTRL + F1
    keys.shpatup        = { 1,    0,  0,    26162 }         -- CTRL + F2
    keys.shcoldown      = { 1,    0,  1,    26161 }         -- CTRL + SHIFT + F1
    keys.shcolup        = { 1,    0,  1,    26162 }         -- CTRL + SHIFT + F2
    keys.shblockdown    = { 1,    1,  0,    26161 }         -- CTRL + ALT  + F1      same as shiftItemDown
    keys.shblockup      = { 1,    1,  0,    26162 }         -- CTRL + ALT  + F2      same as shiftItemUp

    keys.cutPattern     = { 1,    0,  0,    26163 }         -- CTRL + F3
    keys.cutColumn      = { 1,    0,  1,    26163 }         -- CTRL + SHIFT + F3
    keys.cutBlock2      = { 1,    1,  0,    26163 }         -- CTRL + ALT + F3

    keys.copyPattern    = { 1,    0,  0,    26164 }         -- CTRL + F4
    keys.copyColumn     = { 1,    0,  1,    26164 }         -- CTRL + SHIFT + F4
    keys.copyBlock2     = { 1,    1,  0,    26164 }         -- CTRL + ALT + F4

    keys.pastePattern   = { 1,    0,  0,    26165 }         -- CTRL + F5
    keys.pasteColumn    = { 1,    0,  1,    26165 }         -- CTRL + SHIFT + F5
    keys.pasteBlock2    = { 1,    1,  0,    26165 }         -- CTRL + ALT + F5

    keys.patternOctDown = { 1,    0,  0,    6697265.0 }     -- CTRL + F11
    keys.patternOctUp   = { 1,    0,  0,    6697266.0 }     -- CTRL + F12

    keys.colOctDown     = { 1,    0,  1,    6697265.0 }     -- CTRL + SHIFT + F11
    keys.colOctUp       = { 1,    0,  1,    6697266.0 }     -- CTRL + SHIFT + F12

    keys.blockOctDown   = { 1,    1,  0,    6697265.0 }     -- CTRL + ALT + F11
    keys.blockOctUp     = { 1,    1,  0,    6697266.0 }     -- CTRL + ALT + F12

    keys.deleteRow      = { 1,    0,  0,    6579564 }       -- Ctrl + Del

    keys.toggle         = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.upByAdvance    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.downByAdvance  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceDouble  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned
    keys.advanceHalve   = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned

    keys.shiftpgdn      = { 0,    0,  1,    1885824110 }    -- Shift + PgDn
    keys.shiftpgup      = { 0,    0,  1,    1885828464 }    -- Shift + PgUp
    keys.shifthome      = { 0,    0,  1,    1752132965 }    -- Shift + Home
    keys.shiftend       = { 0,    0,  1,    6647396 }       -- Shift + End

    keys.closeTracker   = { 0,    0,  0,    26168 }         -- F8

    keys.insertRow      = { 1,    0,  0,    6909555 }       -- Insert row CTRL+Ins
    keys.removeRow      = { 1,    0,  0,    8 }             -- Remove Row CTRL+Backspace
    keys.wrapDown       = { 1,    0,  1,    6909555 }       -- CTRL + SHIFT + Ins
    keys.wrapUp         = { 1,    0,  1,    8 }             -- CTRL + SHIFT + Backspace

    keys.nextTrack      = { 1,    0,  1,    1919379572.0 }  -- CTRL + Shift + ->
    keys.prevTrack      = { 1,    0,  1,    1818584692.0 }  -- CTRL + Shift + <-

    help = {
      { 'Shift + Note', 'Advance column after entry' },
      { noteOff, 'Note OFF' },
      { 'Insert/Backspace', 'Insert/Remove line' },
      { 'CTRL + Insert/Backspace', 'Insert Row/Remove Row' },
      { 'Del/Ctrl+Del', 'Delete/Delete Row' },
      { 'CTRL + Shift + Insert/Backspace', 'Wrap Forward/Backward' },
      { 'Space/Shift+Space', 'Play / Play From' },
      { 'Ctrl + O / Escape', 'Options / Stop all notes' },
      { 'Enter', 'Loop pattern' },
      { 'CTRL + Q/W', 'Loop start/end' },
      { 'Shift + +/-', 'Transpose selection' },
      { 'CTRL + B/E', 'Selection Begin/End' },
      { 'SHIFT + Arrow Keys', 'Block selection' },
      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },
      { 'CTRL + I', 'Interpolate' },
      { 'Shift + Del', 'Delete block' },
      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' },
      { 'SHIFT + Alt + Up/Down', '[Res]olution Up/Down' },
      { 'SHIFT + Alt + Return', '[Res]olution Commit' },
      { '*//', '[Oct]ave Up/Down' },
      { 'CTRL + Shift + Up/Down', '[Env]elope change' },
      { 'CTRL + -/+ | SHIFT + -/=', '[Adv]ance De/Increase' },
      { '+/-', 'MIDI [out] Up/Down' },
      { 'CTRL + Up/Down', 'Switch MIDI item' },
      { 'CTRL + Shift + Return', 'Duplicate pattern' },
      { 'CTRL + SHIFT + N', 'Rename pattern' },
      { 'CTRL + R', 'Toggle note play' },
      { 'CTRL + Alt + +/-', 'Advanced col options' },
      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },
      { 'F9/F10/F11/F12', 'Goto 0, 25, 50 and 75%%' },
      { 'F8', 'Close tracker' },
      { 'CTRL + Shift + Click row indicator', 'Change highlighting (RMB resets)' },
      { '---', '' },
      { 'CTRL + F1/F2', 'Shift pattern down/up' },
      { 'CTRL + Shift + F1/F2', 'Shift column down/up' },
      { 'CTRL + Alt + F1/F2', 'Shift block down/up' },
      { 'CTRL + F3/F4/F5', 'Cut/Copy/Paste pattern' },
      { 'CTRL + Shift + F3/F4/F5', 'Cut/Copy/Paste column' },
      { 'CTRL + Alt + F3/F4/F5', 'Cut/Copy/Paste block' },
      { 'CTRL + F11/F12', 'Pattern octave up' },
      { 'CTRL + Shift + F11/F12', 'Column octave up' },
      { 'CTRL + Alt + F11/F12', 'Block octave up' },
      { '---', '' },
      { 'CTRL + H', 'Toggle harmonizer' },
      { 'CTRL + Click', 'Insert chord' },
      { 'Alt', 'Invert first note' },
      { 'Shift', 'Invert second note' },
      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },
      { 'CTRL + S / CTRL + A', '(un)Solo / (un)Mute' },      
    }
    elseif ( self.loadCustomKeys ) then
      self:loadKeys("default")
      self.loadCustomKeys(keyset)
    else
      reaper.ShowMessageBox("FATAL ERROR: Something went wrong with loading key layout. Please fix or delete userkeys.lua.", "FATAL ERROR", 0)
    end

  commandKeys = {}
  for i,v in pairs( keys ) do
    if ( ( type(v) == "table" ) and ( #v > 4 ) ) then
      commandKeys[i] = v
    end
  end
end

tracker.hash = 0
tracker.envShapes = {}
tracker.envShapes[0] = 'Lin'
tracker.envShapes[1] = 'S&H'
tracker.envShapes[2] = 'Exp'
tracker.envShapes[3] = 'Fst'

tracker.signed = {}
tracker.signed["Pan (Pre-FX)"] = 1
tracker.signed["Width (Pre-FX)"] = 1
tracker.signed["Pan"] = 1
tracker.signed["Width"] = 1

tracker.armed = 0
tracker.maxPatternNameSize = 13

tracker.hint = ''

tracker.debug = 0

keys.Cbase = 24-12

local function swap( field, name1, name2 )
    if ( name2 ) then
      local t = field[name1]
      keys.pitches[name1] = keys.pitches[name2]
      keys.pitches[name2] = t
    end
end

--- Base pitches
--- Can customize the 'keyboard' here, if they aren't working for you
local function setKeyboard( choice )
  if ( choice == "buzz" or choice == "default" ) then
    local c = 12
    keys.pitches = {}
    keys.pitches.z = 24-c
    keys.pitches.x = 26-c
    keys.pitches.c = 28-c
    keys.pitches.v = 29-c
    keys.pitches.b = 31-c
    keys.pitches.n = 33-c
    keys.pitches.m = 35-c
    keys.pitches.s = 25-c
    keys.pitches.d = 27-c
    keys.pitches.g = 30-c
    keys.pitches.h = 32-c
    keys.pitches.j = 34-c
    keys.pitches.q = 36-c
    keys.pitches.w = 38-c
    keys.pitches.e = 40-c
    keys.pitches.r = 41-c
    keys.pitches.t = 43-c
    keys.pitches.y = 45-c
    keys.pitches.u = 47-c
    keys.pitches.i = 48-c
    keys.pitches.o = 50-c
    keys.pitches.p = 52-c

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
  elseif ( choice == "renoise" ) then
    keys.pitches = {}
    local c = 12
    keys.pitches.z = 24-c
    keys.pitches.x = 26-c
    keys.pitches.c = 28-c
    keys.pitches.v = 29-c
    keys.pitches.b = 31-c
    keys.pitches.n = 33-c
    keys.pitches.m = 35-c
    keys.pitches[","] = 36-c
    keys.pitches["."] = 38-c
    keys.pitches["/"] = 40-c

    keys.pitches.s = 25-c
    keys.pitches.d = 27-c
    keys.pitches.g = 30-c
    keys.pitches.h = 32-c
    keys.pitches.j = 34-c
    keys.pitches.l = 37-c
    keys.pitches[';'] = 39-c

    keys.pitches.q = 36-c
    keys.pitches.w = 38-c
    keys.pitches.e = 40-c
    keys.pitches.r = 41-c
    keys.pitches.t = 43-c
    keys.pitches.y = 45-c
    keys.pitches.u = 47-c
    keys.pitches.i = 48-c
    keys.pitches.o = 50-c
    keys.pitches.p = 52-c
    keys.pitches['['] = 53-c
    keys.pitches[']'] = 55-c

    keys.pitches['2'] = 37-c
    keys.pitches['3'] = 39-c
    keys.pitches['5'] = 42-c
    keys.pitches['6'] = 44-c
    keys.pitches['7'] = 46-c
    keys.pitches['9'] = 49-c
    keys.pitches['0'] = 51-c
    keys.pitches['='] = 54-c

    keys.octaves = {}
  elseif ( tracker.loadCustomKeyboard ) then
    tracker.loadCustomKeyboard(choice)
  else
    reaper.ShowMessageBox("FATAL ERROR: Something went wrong with loading keyboard layout. Please fix or delete userkeys.lua.", "FATAL ERROR", 0)
  end

  if ( tracker.cfg.keyLayout == "QWERTZ" ) then
    swap(keys.pitches, "z", "y")
  end
  if ( tracker.cfg.keyLayout == "AZERTY" ) then
    swap(keys.pitches, "a", "q")
    swap(keys.pitches, "z", "w")
    swap(keys.pitches, "m", ";")
    swap(keys.pitches, ",", ";")
  end

end

setKeyboard(tracker.cfg.keyboard)

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
  local info = debug.getinfo(1,'S')
  local script_path = info.source:match[[^@?(.*[\/])[^\/]-$]]
  return script_path
end

local function findCommandID(name)
  local commandID
  local lines = {}
  local fn = reaper.GetResourcePath() .. "/reaper-kb.ini"
  for line in io.lines(fn) do
    lines[#lines + 1] = line
  end

  for i,v in pairs(lines) do
    if ( v:find(name, 1, true) ) then
      local startidx = v:find("RS", 1, true)
      local endidx = v:find(" ", startidx, true)
      commandID = (v:sub(startidx,endidx-1))
    end
  end

  if ( commandID ) then
    return "_" .. commandID
  end
end

function tracker:callScript(scriptName)
  if ( not scriptName ) then
    reaper.ShowMessageBox("Error callScript called without specifying a script", "Error", 0)
    return
  end

  local cmdID = findCommandID( scriptName )

  if ( cmdID ) then
    local cmd = reaper.NamedCommandLookup( cmdID )
    if ( cmd ) then
      reaper.Main_OnCommand(cmd, 0)
    else
      reaper.ShowMessageBox("Failed to load script "..cmd, "Error", 0)
    end
  end
end

-- Flip channels if we are retrieving a program change
local function encodeProgramChange( chanmsg, msg2, msg3 )
  if ( chanmsg == 192 ) then
    msg3 = msg2
    msg2 = tracker.PCloc
  end

  return msg2, msg3
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
  j = 0
  for k,v in pairs(notes) do
    pitches[j] = v.."M"
    j = j + 1
  end
  
  for i = 0,12 do
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

function tracker:linkCC_channel(modmode, ch, data, master, datafield, idx, colsizes, padsizes, grouplink, headers, headerW, hints)
  if ( modmode == 0 ) then
    -- Single CC display
    master[#master+1]       = 1
    datafield[#datafield+1] = 'mod1'
    idx[#idx+1]             = 0
    colsizes[#colsizes+1]   = 1
    padsizes[#padsizes+1]   = 0
    grouplink[#grouplink+1] = {1, 2, 3}
    headers[#headers+1]     = 'CC'
    headerW[#headerW+1]     = 4
    hints[#hints+1]         = "CC type"

    master[#master+1]       = 0
    datafield[#datafield+1] = 'mod2'
    idx[#idx+1]             = 0
    colsizes[#colsizes+1]   = 1
    padsizes[#padsizes+1]   = 0
    grouplink[#grouplink+1] = {-1, 1, 2}
    headers[#headers+1]     = ''
    headerW[#headerW+1]     = 0
    hints[#hints+1]         = "CC type"

    master[#master+1]       = 0
    datafield[#datafield+1] = 'mod3'
    idx[#idx+1]             = 0
    colsizes[#colsizes+1]   = 1
    padsizes[#padsizes+1]   = 0
    grouplink[#grouplink+1] = {-2, -1, 1}
    headers[#headers+1]     = ''
    headerW[#headerW+1]     = 0
    hints[#hints+1]         = "CC value"

    master[#master+1]       = 0
    datafield[#datafield+1] = 'mod4'
    idx[#idx+1]             = 0
    colsizes[#colsizes+1]   = 1
    padsizes[#padsizes+1]   = 2
    grouplink[#grouplink+1] = {-3, -2, -1}
    headers[#headers+1]     = ''
    headerW[#headerW+1]     = 0
    hints[#hints+1]         = "CC value"
  else
    -- Display with CC commands separated per column
    local allmodtypes = data.modtypes
    if ( not allmodtypes ) then
      return
    end

    local isProgramChange = {}
    local modtypes = {}
    local idxes = {}

    -- Only show for this channel
    local skip = self.CCjump
    if ( ch > -1 ) then
      local k = 1
      for j = 1,#allmodtypes do
        -- Hack to allow mapping Program Changes beyond CC events
        local isPC = 0
        if ( allmodtypes[j] > self.PCloc ) then
          isPC = 1
        end

        if allmodtypes[j] >= skip*ch + self.PCloc*isPC and allmodtypes[j] < skip*(ch+1) + self.PCloc*isPC then
          isProgramChange[k] = isPC
          modtypes[k] = allmodtypes[j]
          idxes[k] = j
          k = k + 1
        end
      end
    end

    if ( modtypes ) then
      for j = 1,#modtypes do
        master[#master+1]       = 1
        datafield[#datafield+1] = 'modtxt1'
        idx[#idx+1]             = idxes[j]
        colsizes[#colsizes+1]   = 1
        padsizes[#padsizes+1]   = 0
        grouplink[#grouplink+1] = {1}
        headerW[#headerW+1]     = 2

        local actualCC = modtypes[j] - math.floor(modtypes[j] / self.CCjump) * self.CCjump
        if ( isProgramChange[j] == 1 ) then
          headers[#headers+1]     = string.format('PC')
          hints[#hints+1]         = string.format('PC')
        else
          headers[#headers+1]     = string.format('CC')
          if ( CC[actualCC] ) then
            hints[#hints+1]         = string.format('%s (%d)', CC[actualCC], actualCC)
          else
            hints[#hints+1]         = string.format('CC command %2d', actualCC)
          end
        end

        master[#master+1]       = 0
        datafield[#datafield+1] = 'modtxt2'
        idx[#idx+1]             = idxes[j]
        colsizes[#colsizes+1]   = 1
        padsizes[#padsizes+1]   = 1
        grouplink[#grouplink+1] = {-1}
        headers[#headers+1]     = ''
        headerW[#headerW+1]     = 0
        local actualCC = modtypes[j] - math.floor(modtypes[j] / self.CCjump) * self.CCjump
        if ( isProgramChange[j] == 1 ) then
          hints[#hints+1]         = string.format('PC')
        else
          if ( CC[actualCC] ) then
            hints[#hints+1]         = string.format('%s (%d)', CC[actualCC], actualCC)
          else
            hints[#hints+1]         = string.format('CC command %2d', actualCC)
          end
        end
      end
    end
  end
end

------------------------------
-- Link GUI grid to data
------------------------------
function tracker:linkData()
  local fx          = self.fx
  local data        = self.data
  local showDelays  = self.showDelays
  local showEnd     = self.showEnd

  -- Here is where the linkage between the display and the actual data fields in "tracker" is made
  local colsizes  = {}
  local datafield = {}
  local idx       = {}
  local padsizes  = {}
  local headers   = {}
  local headerW   = {}
  local grouplink = {}    -- Stores what other columns are linked to this one (some act as groups)
  local hints     = {}
  local master    = {}

  if ( self.showMod == 1 ) then
    tracker:linkCC_channel(math.max(self.modMode, self.cfg.channelCCs), 0, data, master, datafield, idx, colsizes, padsizes, grouplink, headers, headerW, hints)
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
      headerW[#headerW+1]     = 2
      hints[#hints+1]         = namerep(fx.names[j])

      master[#master+1]       = 0
      datafield[#datafield+1] = 'fx2'
      idx[#idx+1]             = j
      colsizes[#colsizes+1]   = 1
      padsizes[#padsizes+1]   = 2
      grouplink[#grouplink+1] = {-1}
      headers[#headers+1]     = ''
      headerW[#headerW+1]     = 0
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
  headerW[#headerW+1]     = 1
  hints[#hints+1]         = 'Legato toggle'

  -- If we are opening the tracker without an xpos, then set it to the first note field
  if self.xposunset then
    self.xpos = #idx+1
    self.xposunset = nil
  end

  for j = 1,self.displaychannels do
    local hasDelay = self.showDelays[j] or 0
    local hasEnd   = self.showEnd[j] or 0

    -- Link up the note fields
    master[#master+1]       = 1
    datafield[#datafield+1] = 'text'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 3 * tracker.grid.fontScaler
    padsizes[#padsizes + 1] = 1
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {1, 2}
    else
      grouplink[#grouplink+1] = {0}
    end
    if self.muted_channels and self.muted_channels[j] then
      headers[#headers + 1]   = string.format('(Ch%2d)', j)
    else
      headers[#headers + 1]   = string.format('Ch%2d', j)
    end
    headerW[#headerW+1]     = 6 + 3 * hasDelay + 3 * hasEnd
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
    headerW[#headerW+1]     = 2
    hints[#hints+1]         = string.format('Velocity channel %2d', j)

    -- Link up the velocity fields
    master[#master+1]       = 0
    datafield[#datafield+1] = 'vel2'
    idx[#idx+1]             = j
    colsizes[#colsizes + 1] = 1
    padsizes[#padsizes + 1] = 2 - self.cfg.channelCCs
    if ( self.selectionBehavior == 1 ) then
      grouplink[#grouplink+1] = {-2, -1}
    else
      grouplink[#grouplink+1] = {-1}
    end
    headers[#headers + 1]   = ''
    headerW[#headerW+1]     = 0
    hints[#hints+1]         = string.format('Velocity channel %2d', j)

    if ( self.cfg.channelCCs == 1 ) then
      tracker:linkCC_channel(1, j, data, master, datafield, idx, colsizes, padsizes, grouplink, headers, headerW, hints)
    end

    -- Link up the delay fields (if active)
    if ( hasDelay == 1 ) then
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
      headerW[#headerW+1]     = 0
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
      headerW[#headerW+1]     = 0
      hints[#hints+1]         = string.format('Note delay channel %2d', j)
    end

    -- Link up the delay fields (if active)
    if ( hasEnd == 1 ) then
      padsizes[#padsizes]     = 1

      master[#master+1]       = 0
      datafield[#datafield+1] = 'end1'
      idx[#idx+1]             = j
      colsizes[#colsizes + 1] = 1
      padsizes[#padsizes + 1] = 0
      if ( self.selectionBehavior == 1 ) then
        grouplink[#grouplink+1] = {1}
      else
        grouplink[#grouplink+1] = {1}
      end
      headers[#headers + 1]   = ''
      headerW[#headerW+1]     = 0
      hints[#hints+1]         = string.format('Note end channel %2d', j)

      -- Link up the delay fields
      master[#master+1]       = 0
      datafield[#datafield+1] = 'end2'
      idx[#idx+1]             = j
      colsizes[#colsizes + 1] = 1
      padsizes[#padsizes + 1] = 2
      if ( self.selectionBehavior == 1 ) then
        grouplink[#grouplink+1] = {-1}
      else
        grouplink[#grouplink+1] = {-1}
      end
      headers[#headers + 1]   = ''
      headerW[#headerW+1]     = 0
      hints[#hints+1]         = string.format('Note end channel %2d', j)
    end
  end

  local link = {}
  link.datafields = datafield
  link.headers    = headers
  link.headerW    = headerW
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
  return link.datafields, link.padsizes, link.colsizes, link.idxfields, link.headers, link.headerW, link.grouplink, link.hints, link.master
end

------------------------------
-- Establish what is plotted
------------------------------
function tracker:updatePlotLink()
  if ( self.colors.patternFont and self.colors.patternFontSize ) then
    gfx.setfont(1, self.colors.patternFont, self.colors.patternFontSize)
  else
    gfx.setfont(0)
  end

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
  local datafields, padsizes, colsizes, idxfields, headers, headerW, grouplink, hints = self:grabLinkage()
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
  local headerWidths = {}
  local description = {}
  local x = originx
--  for j = fov.scrollx+1,math.min(#colsizes,fov.width+fov.scrollx) do
  local q = 0
  for j = fov.scrollx+1,#colsizes do
    xloc[#xloc + 1] = x
    xwidth[#xwidth + 1] = colsizes[j] * dx + padsizes[j]
    xlink[#xlink + 1] = idxfields[j]
    dlink[#dlink + 1] = datafields[j]
    glink[#glink + 1] = grouplink[j]
    header[#header + 1] = headers[j]
    headerWidths[#headerWidths + 1] = math.ceil( .5*(headerW[j])*dx - .5*gfx.measurestr(headers[j].." ") )
    description[#hints + 1] = hints[j]
    x = x + colsizes[j] * dx + padsizes[j] * dx
    q = j

    if ( (x-2*grid.itempadx) > (fov.abswidth-1.5*originx) ) then
      break
    end
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
  plotData.headerW = headerWidths
  plotData.description = hints

  -- Generate y locations for the columns
  local yloc = {}
  local yheight = {}
  local y = originy
  for j = 0,math.max(1,math.min(self.rows-1, fov.height-1)) do
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

  self.scrollbar:setPos( plotData.xstart + plotData.totalwidth, yloc[1] - plotData.yshift, plotData.totalheight - plotData.itempady )
end

------------------------------
-- Cursor and play position
------------------------------
function tracker:normalizePositionToSelf(cpos)
  local norm = 0
  if ( reaper.ValidatePtr2(0, self.item, "MediaItem*") ) then
    local loc = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
    local loc2 = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    self.itemStart = loc
    local row = ( cpos - loc ) * self.rowPerSec
    row = row - self.fov.scrolly
    norm =  row / math.min(self.rows, self.fov.height)
  else
    self:tryPreviousItem()
  end

  return norm
end

-- Used to be self:terminate()
function tracker:lostItem()
  tracker.track     = nil
  tracker.take      = nil
  tracker.rows      = 0
  tracker.max_xpos  = 8
  tracker.max_ypos  = 1
  tracker.renaming  = 0
  tracker.fov.scrolly = 0
end

-- This function is called whenever our item goes missing. It has a few heuristics for
-- finding a new item to focus on. First, see if anything is at the position our last
-- item just started at. If not, see if our buffer of previous items contains a usable
-- item (the case which triggers after CTRL+Z), then just find the nearest item on this
-- track. If even that fails, terminate HT.
function tracker:tryPreviousItem()
  if ( reaper.ValidatePtr2(0, self.track, "MediaTrack*") ) then
    if ( self.itemStart and self:findTakeStartingAtSongPos(self.itemStart) ) then
      -- This was probably a replacement event.
      return
    elseif ( self.lastItem and #self.lastItem > 0 ) then
      local tryItem = self.lastItem[#self.lastItem]
      self.lastItem[#self.lastItem] = nil
      if ( reaper.ValidatePtr2(0, tryItem, "MediaItem*") ) then
        self:useItem(tryItem)
      else
        self:tryPreviousItem()
      end
    elseif ( self.itemStart and self:findTakeClosestToSongPos(self.itemStart) ) then
      -- We switched to a different MIDI item
      return
    else
      self:lostItem()
    end
    self.itemStart = nil
  else
    self:lostItem()
  end
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
    self.loc = 0

    self.ytop = ytop
    self.yend = yend
  end
  
  self.setExtent = function( self, ytop, yend, ypos, rows )
    self.ytop = ytop
    self.yend = yend
    self.loc = ypos
    self.ymarker = ytop + (ypos - ytop) - .5 * (self.yend-self.ytop)/rows
    self.nrows = rows
  end

  self.mouseUpdate = function(self, mx, my, left)
    if ( behavior == 1 ) then
      if ( left == 1 ) then
        if ( ( mx > self.x ) and ( mx < self.x + self.w ) ) then
          if ( ( my > self.y ) and ( my < self.y + self.h ) ) then
            self.loc = ( my - self.y ) / self.h
          end
        end
        return self.loc
      end
    else
      if ( left == 1 ) then
        if ( ( mx > self.x ) and ( mx < self.x + self.w ) ) or self.dragging then
          if ( ( my > self.y ) and ( my < self.y + self.h ) ) or self.dragging then
            if ( ( my > (self.y + self.h*self.ymarker-4) ) and ( my < (self.y + self.h*self.ymarker+4) ) ) and not self.dragging then
              self.dragging = 1
              self.cdy = 0
            end
            
            if self.dragging then
              self.cdy = self.cdy + ((my - self.ly) / self.h)
              local dy = math.floor(self.cdy*self.nrows)/self.nrows
              self.cdy = self.cdy - dy
              
              self.loc = math.max(0.0, math.min(1.0, self.loc + dy))
            else
              self.loc = ( my - self.y ) / self.h
            end            
          end
        end
        self.ly = my
        return self.loc
      else
        self.dragging = nil
      end
    end
    
    self.ly = my
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
    gfx.set(table.unpack(colors.scrollbar1))
    gfx.rect(x-2, y + self.ymarker*h-1, w+4, 2)
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

function tracker:writeField(cdata, ellipsis, x, y, customFont)
  if ( type(cdata) == "number" ) then
    if ( cdata == -1 ) then
      if ( ellipsis == 1 ) then
        local py = y + 6
        gfx.rect(x,  py, 1, 1)
        gfx.rect(x+2, py, 1, 1)
        gfx.rect(x+4, py, 1, 1)
        gfx.rect(x+9, py, 1, 1)
        gfx.rect(x+11, py, 1, 1)
        gfx.rect(x+13, py, 1, 1)
        gfx.rect(x+18, py, 1, 1)
        gfx.rect(x+20, py, 1, 1)
        gfx.rect(x+22, py, 1, 1)
      else
        gfx.printf("...", cdata)
      end
    else
      if ( ellipsis == 1 ) then
        local py = y + 6
        gfx.rect(x,  py, 1, 1)
        gfx.rect(x+2, py, 1, 1)
        gfx.rect(x+4, py, 1, 1)
      else
        gfx.printf(".", cdata)
      end
    end
  else
    if ( customFont )  then
      local cx = x
      if ( not cdata ) then
        return
      end

      for i=1,#cdata do
        gfx.x = cx
        gfx.y = y + customFont[2]
        gfx.printf("%s", cdata:sub(i,i))
        cx = cx + customFont[1]
      end
    else
      gfx.printf("%s", cdata)
    end
  end
end

function tracker:spirals(mode)
  self.sim = self.sim or {}
  self.sim.boost_galaxy = ( self.sim.boost_galaxy or 0 ) + (gfx.mouse_cap & 1 > 0 and 1 or 0)
  self.sim.boost_galaxy2 = ( self.sim.boost_galaxy2 or 0 ) + (gfx.mouse_cap & 2 > 0 and 1 or 0)
  
  local alpha = 0
  local theta = 0
  local r = 0
  local ry = 0
  local ecc = 1.41
  local N_particles = 6000
  
  local cx, cy
  if mode < 10 then
    cx = .5*gfx.w
    cy = .5*gfx.h
  end
  
  local color = self.colors.shadercolor  
  gfx.set(color[1], color[2], color[3], .35)
  
  local dr = .45 * gfx.h / N_particles
  
  local t = 4*math.sin(.00001*reaper.time_precise() + .00001*self.sim.boost_galaxy)
  local t2 = math.sin(self.sim.boost_galaxy2)
  gfx.mode = 1
  alpha = reaper.time_precise();
  for i=1,N_particles do
    if mode == 1 then
      cx = .5*gfx.w + .02*gfx.w*math.sin(alpha+reaper.time_precise())
      cy = .5*gfx.h + .02*gfx.h*math.cos(alpha+reaper.time_precise())
    end
  
    x = cx + r * math.cos(alpha)*math.cos(theta) - r * ecc * math.sin(alpha)*math.sin(theta)
    y = cy + r * math.cos(alpha)*math.sin(theta) + r * ecc * math.sin(alpha)*math.cos(theta)
    
    r = r + dr;
    theta = theta + .3 + t2;
    alpha = alpha + t;
    gfx.circle(x, y, 1, 1)
  end
  gfx.mode = 0
end

function tracker:simulate_shallow_water(mode, movement)
 local function create_2d_table(NX, NY)
    local table = {}
    for i = 1, (NX*NY + 1)*2 do
      table[i] = 0;
    end
    return table
  end

  local xs = 8;
  local sim_w = (gfx.w + xs);
  local sim_h = (gfx.h + xs);
  local Nx = math.floor(sim_w/xs);
  local Ny = math.floor(sim_h/xs);
  dtg = 9.81*0.1;
  dth = .4*0.1;
  
  local cx, cy;
  local dUx, dUy, dHx, dHy, h
  local height = (self.sim and self.sim.height) or create_2d_table(Nx, Ny)
  local velocity_prediction_x = (self.sim and self.sim.velocity_prediction_x) or create_2d_table(Nx, Ny)
  local velocity_prediction_y = (self.sim and self.sim.velocity_prediction_y) or create_2d_table(Nx, Ny)
  local velocity_x = (self.sim and self.sim.velocity_x) or create_2d_table(Nx, Ny)
  local velocity_y = (self.sim and self.sim.velocity_y) or create_2d_table(Nx, Ny)

  if movement == 0 then
    cx = math.floor((Nx-4) * math.random() + 2);
    cy = math.floor((Ny-4) * math.random() + 2);
    if math.random() > .6 then
      height[cx * Ny + cy + 1] = 8*(.5+math.random());
    end
  else
    local time = .7 * reaper.time_precise()
    local sx = ( math.sin(time) + math.sin(3.6*time) ) / 2
    local sy = ( math.cos(time) + math.sin(2.6*time) ) / 2
    cx = math.floor(.5*Nx + .4*Nx * sx )
    cy = math.floor(.5*Ny + .4*Ny * sy )
    height[cx * Ny + cy + 1] = 6;
    
    local time = .7 * reaper.time_precise()
    local sx = ( math.sin(time) + math.sin(3.5*time) ) / 2
    local sy = ( math.cos(time) + math.sin(2.5*time) ) / 2
    cx = math.floor(.5*Nx + .4*Nx * sx )
    cy = math.floor(.5*Ny + .4*Ny * sy )
    height[cx * Ny + cy + 1] = 4;
  end
  
  if gfx.mouse_cap > 0 then
    for dx = -1, 1 do
      for dy = -1, 1 do
        cx = math.floor(gfx.mouse_x / xs) + dx;
        cy = math.floor(gfx.mouse_y / xs) + dy;
        if cx > 0 and cy > 0 and cx < Nx and cy < Ny then
            height[cx * Ny + cy + 1] = height[cx * Ny + cy + 1] + 3;
            if height[cx * Ny + cy + 1] > 5 then
              height[cx * Ny + cy + 1] = 5
            end
        end
      end
    end
  end

  for cx = 1, Nx - 1 do
    for cy = 1, Ny - 1 do
      center = cx * Ny + cy + 1;
    
      h = height[center];
      dHx = h - height[center - Ny];
      dHy = h - height[center - 1];
  
      velocity_prediction_x[center] = velocity_x[center] - dtg * dHx;
      velocity_prediction_y[center] = velocity_y[center] - dtg * dHy;
    end
  end
  
  -- Boundary conditions
  cx = 0;
  for cy = 0, Ny do
    velocity_prediction_x[cy + 1] = 0;
    velocity_prediction_x[(Nx-1) * Ny + cy + 1] = 0;
  end
  
  cx = 0;
  for cy = 0, Ny do
    velocity_prediction_y[cx * Ny + 1] = 0;
    velocity_prediction_y[cx * Ny + (Ny-1) + 1] = 0;
  end
  
  cx = 0;
  local color = self.colors.shadercolor
  for cx = 1, Nx - 1 do
    for cy = 1, Ny - 1 do
      local center = cx * Ny + cy + 1
      
      dUx = velocity_prediction_x[center + Ny] - velocity_prediction_x[center];
      dUy = velocity_prediction_y[center + 1]  - velocity_prediction_y[center];
    
      h = height[center];
      height[center] = h - dth * (dUx + dUy) - .005*h;

      local alpha = h
      if alpha > 1 then
        alpha = 1;
      end
      
      if mode == 0 then
        gfx.set(color[1], color[2], color[3], .7*alpha)
        gfx.rect(cx*xs, cy*xs, xs-1, xs-1)
      elseif mode == 1 then
        gfx.set(color[1], color[2], color[3], alpha)
        gfx.circle(cx*xs, cy*xs, .25*xs, 0)
      elseif mode == 2 then
        gfx.set(color[1], color[2], color[3], alpha)
        gfx.circle(cx*xs, cy*xs, .25*xs, 1)
      elseif mode == 3 then
        gfx.set(color[1], color[2], color[3], alpha)
        gfx.circle(cx*xs, cy*xs, 3*alpha, 0)      
      elseif mode == 4 then
        gfx.set(color[1], color[2], color[3], alpha)
        gfx.circle(cx*xs, cy*xs, 3*alpha, 1)
      end
    end
  end
    
  for cx = 1, Nx - 1 do
    for cy = 1, Ny - 1 do
      local center = cx * Ny + cy + 1
    
      h = height[center];
      dHx = h - height[center - Ny];
      dHy = h - height[center - 1];
    
      velocity_x[center] = velocity_x[center] - dtg * dHx;
      velocity_y[center] = velocity_y[center] - dtg * dHy;
    end
  end
  
  if mode == 5 or mode == 6 then
    local spacing = 1
    if mode == 6 then
      spacing = 3
    end
  
    gfx.set(color[1], color[2], color[3], .3)
    for cy = 1, Ny - 1 do
      lh = 0;
      local ly = xs * cy
      for cx = 1, Nx - 1 do
        local center = cx * Ny + cy + 1
        h = xs * math.min(height[center], 3);
        gfx.line(xs*(cx - 1), ly - lh, xs*cx - spacing, ly - h, 1);
        lh = h;
      end
    end
  end
  
  local sim = self.sim or {}
  
  sim.height = height
  sim.velocity_prediction_x = velocity_prediction_x
  sim.velocity_prediction_y = velocity_prediction_y
  sim.velocity_x = velocity_x
  sim.velocity_y = velocity_y
  
  self.sim = sim
end

------------------------------
-- Draw the GUI
------------------------------
function tracker:printGrid()
  local ellipsis  = self.colors.ellipsis
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
  local headerShift   = 0

  local customFont
  local extraFontShift  = 0

  if ( colors.patternFont and colors.patternFontSize and colors.customFontDisplace ) then
    gfx.setfont(1, colors.patternFont, colors.patternFontSize)
    customFont = colors.customFontDisplace
    extraFontShift = customFont[2]
  else
    gfx.setfont(0)
    headerShift = 4
  end

  if self.cfg.fx1 > 0 then
    if self.cfg.fx1 < 3 then
      self:simulate_shallow_water(self.cfg.fx2, self.cfg.fx1-1);
    else
      self:spirals(self.cfg.fx2)
    end
  end

  -- Render in relative FOV coordinates
  local data  = self.data
  local sig   = self.rowPerQn
  if ( self.cfg.rowOverride > 0  ) then
    sig = self.cfg.rowOverride
  end

  if ( self.take ) then
    for y=1,#yloc do
      local absy = y + scrolly

      local c1, c2, tx
      if ( (((absy-1)/sig) - math.floor((absy-1)/sig)) == 0 ) then
        c1 = colors.linecolor5
        c2 = colors.linecolor5s
        tx = colors.textcolorbar or colors.textcolor
        fc = colors.bar
      elseif false and( (((absy-1)/(sig/4)) - math.floor((absy-1)/(sig/4))) == 0 ) then
        c1 = colors.linecolor2
        c2 = colors.linecolor2s
        tx = colors.textcolorbar or colors.textcolor
        fc = colors.bar
      else
        c1 = colors.linecolor
        c2 = colors.linecolors
        tx = colors.textcolor
        fc = colors.normal
      end

      gfx.y = yloc[y] + extraFontShift
      gfx.x = xloc[1] - plotData.indicatorShiftX

      gfx.set(table.unpack(tx))
      if tracker.zeroindexed == 1 then
        gfx.printf("%03d", absy-1)
      else
        gfx.printf("%03d", absy)
      end
      gfx.set(table.unpack(c1))
      gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, tw, yheight[1] + itempady)
      gfx.set(table.unpack(c2))
      gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, tw, 1)
      gfx.rect(xloc[1] - itempadx, yloc[y] - yshift, 1, yheight[y])
      gfx.rect(xloc[1] - itempadx + tw + 0, yloc[y] - yshift, 1, yheight[y] + itempady)

      for x=1,#xloc do
        local thisfield = dlink[x]
        gfx.x = xloc[x]
        gfx.set(table.unpack(fc[thisfield] or tx))

        local cdata = data[thisfield][rows*xlink[x]+absy-1]
        self:writeField( cdata, ellipsis, xloc[x], yloc[y], customFont )
      end
    end

    if ( xloc[relx] and yloc[rely] ) then
      local absy = rely + scrolly
      gfx.set(table.unpack(colors.selectcolor))
      gfx.rect(xloc[relx]-1, yloc[rely]-plotData.yshift, xwidth[relx], yheight[rely])

      gfx.x = xloc[relx]
      gfx.y = yloc[rely]
      gfx.set(table.unpack(colors.selecttext or colors.textcolor))

      local cdata = data[dlink[relx]][rows*xlink[relx]+absy-1]
      self:writeField( cdata, ellipsis, xloc[relx], yloc[rely], customFont )
    end

    -- Pattern Length Indicator
    local xl, yl, xm, ym = self:getSizeIndicatorLocation()
    gfx.y = yl + extraFontShift
    gfx.x = xl
    if ( self.renaming == 3 ) then
      gfx.set(table.unpack(colors.changed))
      gfx.printf("%3s", tracker.newLength)
    else
      gfx.set(table.unpack(colors.textcolor))
      gfx.printf("%3d", self.max_ypos)
    end

    gfx.y = yl + extraFontShift
    gfx.x = xl
    if ( self.renaming ~= 3 ) then
      gfx.set(table.unpack(colors.linecolor3s))
      gfx.printf("%3d", self.max_ypos)
    end

    gfx.line(xl, yl-2, xm,  yl-2)
    gfx.line(xl, ym,   xm,  ym)
    gfx.line(xm, ym,   xm,  yl-2)
  end

  ------------------------------
  -- Field descriptions
  ------------------------------
  local bottom = self:getBottom()

  gfx.x = plotData.xstart
  gfx.y = bottom + extraFontShift
  gfx.set(table.unpack(colors.headercolor))
  if ( tracker.renaming ~= 2 and tracker.renaming ~= 4 ) then
    if ( self.take ) then
      gfx.printf("%s", description[tracker.xpos])
    end
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
  gfx.y = bottom + extraFontShift
  if ( tracker.renaming == 1 ) then
    gfx.set(table.unpack(colors.changed))
    if ( self.midiName:len() > 0 ) then
      patternName = self.midiName
    else
      patternName = '_'
    end
    gfx.x = plotData.xstart + tw - gfx.measurestr(patternName)
    gfx.printf(patternName)
  elseif ( self.toosmall == 0 and self.take ) then
    patternName = self.patternName
    gfx.x = plotData.xstart + tw - gfx.measurestr(patternName)
    gfx.printf(patternName)
  end

  -- Draw the bottom indicators
  gfx.set(table.unpack(colors.headercolor))
  local strs, locs, yh = tracker:infoString()
  gfx.y = yh + extraFontShift

  if ( self.take ) then
    for i=1,#locs-1 do
      gfx.x = locs[i]
      gfx.printf(strs[i])
    end

    if ( tracker.newRowPerQn ~= tracker.rowPerQn ) then
      gfx.set(table.unpack(colors.changed))
    else
      gfx.set(table.unpack(colors.headercolor))
    end
    gfx.x = locs[#locs]
    gfx.y = bottom + yheight[1] + extraFontShift
    gfx.printf(strs[#locs])
  end

  gfx.set(table.unpack(colors.headercolor))

  gfx.x = plotData.xstart
  if ( self.take ) then
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

    local recsize = gfx.measurestr( "[Rec]") + 2
    if ( self.cfg.followSong == 1 ) then
      gfx.set(table.unpack(colors.headercolor))
    else
      gfx.set(table.unpack(colors.inactive))
    end
    gfx.rect( plotData.xstart + recsize, bottom + yheight[1], 3, 3 )

    if ( self.cfg.followSelection == 1 ) then
      gfx.set(table.unpack(colors.headercolor))
    else
      gfx.set(table.unpack(colors.inactive))
    end
    gfx.rect( plotData.xstart + recsize, bottom + yheight[1] + 4, 3, 3 )
 else
    gfx.y = yloc[1]
    gfx.printf( "No MIDI item selected..." )
 end

  -- Color header with track color
  if ( (self.cfg.useItemColors == 1) and self.item and self.take ) then
    local cColor = reaper.GetDisplayedMediaItemColor2(self.item, self.take)
    if ( cColor ~= 0 ) then
      local r, g, b = reaper.ColorFromNative( cColor )
      if ( math.max(r,math.max(g,b)) > 0 ) then
        gfx.set(r/255,g/255,b/255,1)
        gfx.rect(xloc[1] - itempadx, yloc[1] - plotData.indicatorShiftY, tw, yheight[1] + itempady)
      end

      local function lumi(r, g, b)
        return .2126 * r + .7152 * g + .0722 * b
      end

      -- Check how far the luminance is from the header color
      local lum = lumi(gfx.r, gfx.g, gfx.b)
      local headlum = lumi(colors.headercolor[1], colors.headercolor[2], colors.headercolor[3])

      -- Draw the headers so we don't get lost :)
      if ( math.abs(lum - headlum) > .25 ) then
        gfx.set(table.unpack(colors.headercolor))
      else
        gfx.set(1-colors.headercolor[1], 1-colors.headercolor[2], 1-colors.headercolor[3], colors.headercolor[4])
      end
    else
      gfx.set(table.unpack(colors.headercolor))
    end
  else
    gfx.set(table.unpack(colors.headercolor))
  end

  gfx.y = yloc[1] - plotData.indicatorShiftY + headerShift

  local hws = plotData.headerW
  for x=1,#xloc do
    local xc = xloc[x] + hws[x]
    gfx.x = xc
    if ( (xc + (hws[x+1] or 0)) < tw ) then
      gfx.drawstr(headers[x])
    end
  end

  ------------------------------
  -- Scrollbar
  ------------------------------
  tracker.scrollbar:setExtent( fov.scrolly / rows, ( fov.scrolly + fov.height ) / rows, tracker.ypos/rows, rows )
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
    
    xma = math.min(xma, #xloc)
    ye = math.min(ye, #yloc)
    
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

  ------------------------------
  -- Harmony Helper
  ------------------------------
  if ( tracker.harmonyActive == 1 ) then
    local xs, ys, scaleY, keyMapH, scaleW, chordW, noteW, chordAreaY, charW = self:chordLocations()
    local xwidth       = plotData.xwidth
    local names        = scales.names
    local progressions = scales.progressions

    gfx.set(table.unpack(colors.textcolorbar or colors.textcolor))
    gfx.x = xs + self.harmonyWidth - 4 * noteW - 5
    gfx.y = ys
    gfx.printf( "Harmony helper" )

    gfx.y = ys + keyMapH
    if ( scales.picked and scales.picked.notes ) then
      local s = ''
      for i,v in pairs( scales.picked.notes ) do
        s = s .. scales:pitchToNote(v) .. ","
      end
      gfx.x = xs + self.harmonyWidth - (4 + s:len() ) * charW
      gfx.printf( "["..s:sub(1,-2).."]" )
    else
      gfx.x = xs + self.harmonyWidth - 4 * charW - 5
      gfx.printf( "[]" )
    end

    gfx.x = xs
    gfx.y = ys + extraFontShift
    gfx.printf( "Current scale: " .. scales:getScale() .. " " .. scales:getScaleNote(1) .. " (" .. scales:scaleNotes() .. ")"  )

    gfx.y = scaleY
    local curx = xs
    local root = scales:getRootValue()
    for k = 1,12 do
      local notetxt = scales:getNote(k)
      gfx.x = curx + 0.5 * noteW - 0.1 * noteW * (#notetxt-1)
      if ( k == root ) then
        gfx.set(table.unpack(colors.harmonyselect or colors.textcolor))
      else
        gfx.set(table.unpack(colors.helpcolor))
      end
      gfx.printf( notetxt )

      curx = curx + noteW
    end
    gfx.set(table.unpack(colors.helpcolor))

    local cury = ys + chordAreaY - keyMapH
    local curx = xs + scaleW

    -- Currently marked for major, could choose to incorporate others
    local markings = { 'I', 'ii', 'iii', 'IV', 'V', 'vi', 'vii0', 'VIII' }
    for k = 1,7 do
      gfx.x = curx
      gfx.y = cury+extraFontShift
      gfx.printf( markings[k] )

      curx = curx + chordW
    end
    cury = cury + keyMapH
    gfx.set(table.unpack(colors.helpcolor))
    gfx.line(xs-5, cury-4, xs+self.harmonyWidth*0.94, cury-5)
    gfx.set(table.unpack(colors.textcolor))
    local selectedScale = scales:getScaleValue()
    for i = 1,#names do
      gfx.x = xs
      gfx.y = cury
      local scaleName = scales.names[i]
      if ( i == selectedScale ) then
        gfx.set(table.unpack(colors.harmonyselect or colors.textcolor))
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
          gfx.y = cury + extraFontShift
          if ( chordmap[k].names[j] ) then
            local score = scales:similarityScore( chordmap[k].notes[j] )
            local ccc = colors.harmonycolor or colors.textcolor
            local col = { ccc[1], ccc[2], ccc[3], clamp( 0.1, 1, ccc[4] - 0.4 * score ) }
            gfx.set(table.unpack(col))

            gfx.printf( chordmap[k].names[j] )
          end

          curx = curx + chordW
        end
        cury = cury + keyMapH
      end
      gfx.set(table.unpack(colors.helpcolor))
      gfx.line(xs-5, cury-4, xs+self.harmonyWidth*0.94, cury-5)
      gfx.set(table.unpack(colors.textcolor))
    end
  end

  ----------------------------------
  -- note names
  ----------------------------------
  if tracker.noteNamesActive == 1 then
    local width = self.noteNamesWidth - 2 * itempadx
    local ys = plotData.ystart - 1.3 * plotData.indicatorShiftY + yheight[1]
    local xs = plotData.xstart + tw + 4 * itempadx
    if self.harmonyActive == 1 then
      xs = xs + self.harmonyWidth * 1
    end
    local noteNamesFound = false;

    gfx.set(table.unpack(colors.textcolorbar or colors.helpcolor2))
    gfx.x = xs
    gfx.y = ys
    gfx.printf('Note Names')
    ys = ys + yheight[1] + 4 * itempady

    for note = 0, 127 do
      noteName = noteNames[note]
      if noteName then
        noteNamesFound = true;
        pitch = self.pitchTable[note]
        gfx.set(table.unpack(colors.helpcolor))
        gfx.x = xs + 0.1 * width + 4 * itempadx
        gfx.y = ys
        gfx.printf(noteName)
        gfx.set(table.unpack(colors.helpcolor2))
        local lsize = gfx.measurestr(pitch) -- align right
        gfx.x = xs + 0.1 * width - lsize + 2 * itempadx
        gfx.printf(pitch)
        ys = ys + yheight[1]
      end
    end

    if not noteNamesFound then
      local a = 'No note names found'
      local b = 'for this track'
      gfx.set(table.unpack(colors.helpcolor))
      gfx.y = ys
      gfx.x = xs + 0.5 * width - gfx.measurestr(a) / 2 -- align centre
      gfx.printf(a)
      ys = ys + yheight[1]
      gfx.x = xs + 0.5 * width - gfx.measurestr(b) / 2 --align centre
      gfx.y = ys
      gfx.printf(b)
    end

  end

  ----------------------------------
  -- Help
  ----------------------------------
  if ( tracker.helpActive == 1 ) then
    local help = help
    local helpwidth = self.helpwidth
    local ys = plotData.ystart - 1.3*plotData.indicatorShiftY
    local xs = plotData.xstart + tw
    if self.harmonyActive == 1 then
      xs = xs + self.harmonyWidth * 1
    end
    if self.noteNamesActive == 1 then
      xs = xs + self.noteNamesWidth * 1
    end
    for i,v in pairs( help ) do
      gfx.set(table.unpack(colors.helpcolor))
      gfx.x = xs + 0.5*helpwidth + 4*itempadx
      gfx.y = ys
      gfx.printf(v[2])
      gfx.set(table.unpack(colors.helpcolor2))
      local lsize = gfx.measurestr( v[1] ) -- align right
      gfx.x = xs + helpwidth - lsize - 0.5 * helpwidth + 2*itempadx --8.2 * string.len(v[1])
      gfx.printf(v[1])
      ys = ys + yheight[1]
    end
  end

  if ( tracker.optionsActive == 1 ) then
    local themeMenu, keymapMenu, layoutMenu, fontsizeMenu, binaryOptions, fx1Menu, fx2Menu, labelLocation = tracker:optionLocations()

    gfx.set(table.unpack(colors.textcolorbar or colors.helpcolor2))
    gfx.x = labelLocation.x
    gfx.y = labelLocation.y
    gfx.printf( "Options" )

    local selectedColor = colors.harmonyselect or colors.helpcolor2
    local normalColor = colors.helpcolor
    local titleColor = colors.textcolorbar or colors.helpcolor2

    themeMenu:drawMenu("Theme", tracker.colorschemes, tracker.cfg.colorscheme, titleColor, selectedColor, normalColor)
    keymapMenu:drawMenu("Map", keysets, tracker.cfg.keyset, titleColor, selectedColor, normalColor)    
    layoutMenu:drawMenu("Layout", keyLayouts, tracker.cfg.keyLayout, titleColor, selectedColor, normalColor)
    fontsizeMenu:drawMenu("Font", fontSizes, tracker.cfg.fontSize, titleColor, selectedColor, normalColor)
    fx1Menu:drawMenu("FX", fx1Options, tracker.cfg.fx1, titleColor, selectedColor, normalColor)
    fx2Menu:drawMenu("Style", fx2Options, tracker.cfg.fx2, titleColor, selectedColor, normalColor)

    xs = binaryOptions.x
    ys = binaryOptions.y
    for i=1,#self.binaryOptions do
      gfx.set(table.unpack(colors.textcolorbar or colors.helpcolor2))
      gfx.x = xs + 13
      local cys = ys + i * binaryOptions.h
      gfx.y = cys + extraFontShift

      gfx.line(xs, cys, xs,  cys+8)
      gfx.line(xs+8, cys, xs+8,  cys+8)
      gfx.line(xs, cys, xs+8,  cys)
      gfx.line(xs, cys+8, xs+8,  cys+8)

      if (self.cfg[self.binaryOptions[i][1]] == 1) then
        gfx.line(xs, cys, xs+8,  cys+8)
        gfx.line(xs+8, cys, xs,  cys+8)
      end

      gfx.printf( "%s", self.binaryOptions[i][2] )
    end
  end

  ------------------------------------------
  -- Cheap CRT effect
  ------------------------------------------
  if ( self.cfg.CRT == 1 ) then
    local str = self.crtStrength
    self.crt_time = ( self.crt_time or 0 ) + 0.1
    for c = 0,gfx.h,4 do
      local q = math.sin( self.crt_time + .05 * c ) - 0.1
      gfx.set(0, 0, 0, str * 0.05 * ( 1 + 0.7 * q*q*q*q ) )
      gfx.line(0, c, gfx.w,  c)
      gfx.set(0, 0, 0, str * 0.02 * ( 1 + 0.7 * q*q*q*q ) )
      gfx.line(0, c+1, gfx.w,  c+1)
    end
    for c = 0,gfx.w,4 do
      gfx.set(1.0, 0, 0, 0.01 * str * ( 1 + 0.1 * str ) )
      gfx.line(c, 0, c, gfx.h)
    end
    for c = 3,gfx.w,4 do
      gfx.set(0, 1.0, 0, 0.01 * str * ( 1 + 0.1 * str ) )
      gfx.line(c, 0, c, gfx.h)
    end
  end
end

-- Load the scales
dofile(get_script_path() .. 'scales.lua')
scales:initialize()

function tracker:infoString()
  local plotData = self.plotData
  local tw       = plotData.totalwidth
  local yloc     = plotData.yloc
  local yheight  = (yloc[2]-yloc[1])*.7

  local str = {}
  str[4] = string.format( "Oct [%d]", self.transpose )
  str[3] = string.format( "Adv [%d]", self.advance )
  str[2] = string.format( "Env [%s]", tracker.envShapes[tracker.envShape] )
  str[1] = string.format( "Out [%s]", self:outString() )
  str[5] = string.format( "Res [%d]", tracker.newRowPerQn )

  local locs = {}
  local xs = plotData.xstart + tw - 5
  local maxi
  if ( self.toosmall == 0 ) then
    maxi = #str
  else
    maxi = 1
  end

  for i=1,maxi do
    xs = xs - gfx.measurestr(str[i])
    locs[i] = xs
    xs = xs - gfx.measurestr("p")
  end

  local y = self:getBottom() + yheight

  return str, locs, y
end

function tracker:getBottom()
  local plotData = self.plotData
  local yloc     = plotData.yloc
  local yheight  = (yloc[2]-yloc[1])*.7 --plotData.yheight
  local itempady = plotData.itempady

  local bottom
  if ( self.cfg.stickToBottom == 1 ) then
    bottom = self.windowHeight - yheight * 2
  else
    bottom = yloc[#yloc] + yheight + itempady
  end

  return bottom, yheight
end

function CreateMenu(_x, _y, _w, _h)
  return {
    x=_x, 
    y=_y, 
    w=_w, 
    h=_h,
    processMouseMenu = function(self)
      if ( gfx.mouse_x > self.x ) then
        if ( gfx.mouse_x < self.x+self.w ) then
          if ( gfx.mouse_y > self.y ) then
            return math.floor((gfx.mouse_y - self.y)/self.h)
          end
        end
      end
    end,
    
    drawMenu = function(self, title, labels, selection, titleColor, selectedColor, normalColor)
      gfx.x = self.x
      gfx.y = self.y
      
      gfx.set(table.unpack(titleColor))
      gfx.printf(title)
    
      for i,v in pairs(labels) do
        gfx.x = self.x
        gfx.y = gfx.y + self.h
        if ( v == selection ) then
          gfx.set(table.unpack(selectedColor))
        else
          gfx.set(table.unpack(normalColor))
        end
        gfx.printf(v)
      end
    end,
    
    processSimple = function(self, cfgField, options)
      sel = self:processMouseMenu()
      if ( options[sel] ) then
        if ( options[sel] ~= tracker.cfg[cfgField] ) then
          changedOptions = 1
        end
        tracker.cfg[cfgField] = options[sel]
      end
      return changedOptions
    end
  }
end

function tracker:optionLocations()
  local plotData = self.plotData
  local tw       = plotData.totalwidth
  local th       = plotData.totalheight
  local itempadx = plotData.itempadx
  local itempady = plotData.itempady
  local yloc     = plotData.yloc
  local yheight  = (yloc[2]-yloc[1])*.8

  local xs = plotData.xstart + tw + 4*itempadx
  local ys = plotData.ystart - 1.3*plotData.indicatorShiftY + yheight

  if self.harmonyActive == 1 then
    xs = xs + self.harmonyWidth * 1.1
  end
  if self.noteNamesActive == 1 then
    xs = xs + self.noteNamesWidth * 1.1
  end
  if self.helpActive == 1 then
    xs = xs + self.helpwidth * 1.1
  end
  
  if ( self.colors.patternFont and self.colors.patternFontSize ) then
    gfx.setfont(1, self.colors.patternFont, self.colors.patternFontSize)
  else
    gfx.setfont(0)
  end
  local xloc = xs + 8.2 * 2
  local w = gfx.measurestr("Theme!____")
  local themeMenu = CreateMenu(xloc, ys + yheight * 2, w, yheight)

  xloc = xloc + w;
  w = gfx.measurestr('Map______')
  local keymapMenu = CreateMenu(xloc, ys + yheight * 2, w, yheight)

  xloc = xloc + w;
  w = gfx.measurestr('Layout____')
  local layoutMenu = CreateMenu(xloc, ys + yheight * 2, w, yheight)

  xloc = xloc + w;
  w = gfx.measurestr('font__')
  local fontsizeMenu = CreateMenu(xloc, ys + yheight * 2, w, yheight)
  
  xloc = xloc + w;
  w = gfx.measurestr('fx1__')
  local fx1Menu = CreateMenu(xloc, ys + yheight * 2, w, yheight)
  
  xloc = xloc + w;
  w = gfx.measurestr('fx2__')
  local fx2Menu = CreateMenu(xloc, ys + yheight * 2, w, yheight)

  local binaryOptions = CreateMenu(xs + 8.2 * 2, ys + yheight * ( 1 + #tracker.colorschemes + #keysets ), w, yheight)

  return themeMenu, keymapMenu, layoutMenu, fontsizeMenu, binaryOptions, fx1Menu, fx2Menu, {x=xs, y=ys}
end

function tracker:chordLocations()
  local grid     = tracker.grid
  local dx       = grid.dx
  local plotData = self.plotData
  local tw       = plotData.totalwidth + 8
  local th       = plotData.totalheight
  local itempadx = plotData.itempadx
  local itempady = plotData.itempady
  local xloc     = plotData.xloc
  local yloc     = plotData.yloc
  local xwidth   = dx
  local yheight  = (yloc[2]-yloc[1])*.8 --plotData.yheight

  local xs       = plotData.xstart + tw + 4*itempadx
  local ys       = plotData.ystart - 1.3*plotData.indicatorShiftY + .5 * yheight

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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) or ( ftype == 'end1' ) or ( ftype == 'end2' )) then
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
function tracker:shiftAt( x, y, shift, scale, onlyNotes )
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
      if ( self.harmonyActive == 1 ) then
        if ( scale and scale == 1 ) then
          newPitch = scales:shiftRoot(pitch, shift)
        else
          newPitch = scales:shiftPitch(pitch, shift)
        end
      else
        newPitch = pitch+shift
      end

      reaper.MIDI_SetNote(self.take, selected, nil, nil, nil, nil, nil, newPitch, nil, true)
    elseif ( not onlyNotes ) then
      if ( datafields[x] == 'vel1' ) or ( datafields[x] == 'vel2' ) then
        -- Velocity
        local pitch, vel, startppqpos, endppqpos = table.unpack( note )
        reaper.MIDI_SetNote(self.take, selected, nil, nil, nil, nil, nil, nil, clamp(0, 127,vel+shift), true)
      elseif ( datafields[x] == 'delay1' ) or ( datafields[x] == 'delay2' ) then
        -- Note delay
        local delay = self:getNoteDelay( selected )
        self:setNoteDelay( selected, delay + shift )
      elseif ( datafields[x] == 'end1' ) or ( datafields[x] == 'end2' ) then
        -- Note end
        local newend = self:getNoteEnd( selected )
        self:setNoteEnd( selected, newend + shift )
      end
    end
  end

  if ( not onlyNotes ) then
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
end

function tracker:shiftup(incp, onlyNotes, semitones)
  local cp = incp or self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift operation")
  reaper.MarkProjectDirty(0)

  if ( cp.ystop == -1 ) then
    self:shiftAt( tracker.xpos, tracker.ypos, semitones or 1, nil, onlyNotes )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, semitones or 1, nil, onlyNotes )
      end
    end
  end
  reaper.MIDI_Sort(self.take)
end

function tracker:shiftdown(incp, onlyNotes, semitones)
  local cp = incp or self.cp
  reaper.Undo_OnStateChange2(0, "Tracker: Shift operation")
  reaper.MarkProjectDirty(0)

  if ( cp.ystop == -1 ) then
    self:shiftAt( tracker.xpos, tracker.ypos, -(semitones or 1), nil, onlyNotes )
  else
    for jx = cp.xstart, cp.xstop do
      for jy = cp.ystart, cp.ystop do
        self:shiftAt( jx, jy, -(semitones or 1), nil, onlyNotes )
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
  self:saveConfig(tracker.configFile, self.cfg)
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
  self:saveConfig(tracker.configFile,self.cfg)
  reaper.MIDI_Sort(self.take)
end


function tracker:addNotePpq(startppqpos, endppqpos, chan, pitch, velocity)
  local endrow = self:ppqToRow(endppqpos)

  if ( chan == 1 ) then
    if ( self.legato[endrow] and self.legato[endrow] > -1 ) then
      endppqpos = endppqpos + tracker.magicOverlap
    end
  end

  reaper.MIDI_InsertNote( self.take, false, self.muted_channels[chan], startppqpos, endppqpos, chan, pitch, velocity, true )
end

function tracker:addNote(startrow, endrow, chan, pitch, velocity)
  if ( self.take ) then
    local startppqpos = self:rowToPpq(startrow)
    local endppqpos   = self:rowToPpq(endrow)

    if ( chan == 1 ) then
      if ( self.legato[endrow] > -1 ) then
        endppqpos = endppqpos + tracker.magicOverlap
      end
    end

    reaper.MIDI_InsertNote( self.take, false, self.muted_channels[chan], startppqpos, endppqpos, chan, pitch, velocity, true )
  end
end

----------------------------
-- Handle note delays
----------------------------
function tracker:getNoteDelay( note )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  return self:ppqToDelay( startppqpos )
end

function tracker:setNoteDelay( note, newDelay )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local newppq = self:delayToPpq( startppqpos, newDelay )
  if ( newppq < endppqpos ) then
    reaper.MIDI_SetNote(self.take, note, nil, nil, newppq, nil, nil, nil, nil, true)
  end
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

----------------------------
-- Handle note ends
----------------------------
function tracker:getNoteEnd( note )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  return self:ppqToEnd( endppqpos )
end

function tracker:setNoteEnd( note, newEnd )
  local notes = self.notes
  local pitch, vel, startppqpos, endppqpos = table.unpack( notes[note] )
  local newendppq = self:endToPpq( endppqpos, newEnd )
  if ( newendppq > startppqpos ) then
    reaper.MIDI_SetNote(self.take, note, nil, nil, nil, newendppq, nil, nil, nil, true)
  end
end

function tracker:ppqToEnd( ppq )
  local rows = self.rows
  local eps = self.eps
  local singlerow = self:rowToPpq(1)
  local ppq = ppq - self:rowToPpq( self:ppqToRow(ppq-eps) )
  return math.floor( 256 * ( ppq / singlerow ) - eps )
end

function tracker:endToPpq( ppq, enddiff )
  local singlerow = self:rowToPpq(1)
  local eps = self.eps
  local ppq = self:rowToPpq( self:ppqToRow(ppq - eps) )

  if ( enddiff > 250 ) then
    enddiff = 255
  end
  return ppq + singlerow * ( enddiff / 255.0 )
end

----------------------
-- Show more data
----------------------
function tracker:showMore()
  local ftype, chan, row = self:getLocation()
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) ) then
    if ( self.showDelays[chan] == 1 ) then
      self.showEnd[chan] = 1
      self.hash = 0
    else
      local singlerow = math.floor(self:rowToPpq(1))
      if ( ( singlerow / 256 ) ~= math.floor( singlerow/256 ) ) then
        if ( self.cfg.showedWarning == 0 ) then
          reaper.ShowMessageBox("WARNING: This functionality only works reliably when MIDI pulses per row is set to a multiple of 256!\nPreferences > Media/MIDI > Ticks per quarter note for new MIDI items.", "WARNING", 0)
          self.cfg.showedWarning = 1
          tracker:saveConfig(tracker.configFile, tracker.cfg)
        end
      end

      self.showDelays[chan] = 1
      self.hash = 0
    end
  end

  if ( ( ftype == 'mod1' ) or ( ftype == 'mod2' ) or ( ftype == 'mod3' ) or ( ftype == 'mod4' ) ) then
    tracker.modMode = 1
    self.hash = 0
    self:storeSettings()
  end
end

function tracker:showLess()
  local ftype, chan, row = self:getLocation()

  if ( ftype == 'end1' ) or ( ftype == 'end2' ) then
    self.showEnd[chan] = 0
    self.hash = 0
  end
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
function tracker:createNote(inChar, shift)

  if ( not inChar or ( inChar > 256 ) ) then
    return
  end

  local char       = string.lower(string.char(inChar))
  local data       = self.data
  local notes      = self.notes
  local noteGrid   = data.note
  local noteStart  = data.noteStart
  local rows       = self.rows
  local singlerow  = self:rowToPpq(1)
  local shouldMove = false

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
            break
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
      shouldMove = true
    else
      local octave = keys.octaves[char]
      if ( octave ) then
        if ( noteToEdit ) then
          local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )
          pitch = pitch - math.floor(pitch/12)*12 + (octave+1) * 12
          reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, pitch, nil, true)
          self:playNote(chan, pitch, vel)
        end
        shouldMove = true
      end
    end
  elseif ( ( ftype == 'vel1' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )
      local newvel = tracker:editVelField( vel, 1, char )
      self.lastVel = newvel
      reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, nil, newvel, true)
    end
    shouldMove = true
  elseif ( ( ftype == 'vel2' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local pitch, vel, startppqpos, endppqpos = table.unpack( notes[noteToEdit] )
      local newvel = tracker:editVelField( vel, 2, char )
      self.lastVel = newvel
      reaper.MIDI_SetNote(self.take, noteToEdit, nil, nil, nil, nil, nil, nil, newvel, true)
      shouldMove = true
    end
  elseif ( ( ftype == 'fx1' ) and validHex( char ) ) then
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos-1))
    env = env or self.lastEnv
    local newEnv = tracker:editEnvField( env, 1, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)
    shouldMove = true
    self.lastEnv = newEnv
  elseif ( ( ftype == 'fx2' ) and validHex( char ) ) then
    local atime, env, shape, tension = tracker:getEnvPt(chan, self:toSeconds(self.ypos-1))
    env = env or self.lastEnv
    local newEnv = tracker:editEnvField( env, 2, char )
    self:addEnvPt(chan, self:toSeconds(self.ypos-1), newEnv, self.envShape)
    shouldMove = true
    self.lastEnv = newEnv
  elseif ( ( ftype == 'delay1' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local delay = self:getNoteDelay( noteToEdit )
      local newDelay = self:editCCField( delay, 1, char )
      self:setNoteDelay( noteToEdit, newDelay )
      shouldMove = true
    end
  elseif ( ( ftype == 'delay2' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local delay = self:getNoteDelay( noteToEdit )
      local newDelay = self:editCCField( delay, 2, char )
      self:setNoteDelay( noteToEdit, newDelay )
      shouldMove = true
    end
  elseif ( ( ftype == 'end1' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local oldEnd = self:getNoteEnd( noteToEdit )
      local newEnd = self:editCCField( oldEnd, 1, char )
      self:setNoteEnd( noteToEdit, newEnd )
      shouldMove = true
    end
  elseif ( ( ftype == 'end2' ) and validHex( char ) ) then
    if ( noteToEdit ) then
      local oldEnd = self:getNoteEnd( noteToEdit )
      local newEnd = self:editCCField( oldEnd, 2, char )
      self:setNoteEnd( noteToEdit, newEnd )
      shouldMove = true
    end
  elseif ( ( ftype == 'mod1' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newtype = self:editCCField( modtype, 1, char )
    self:addCCPt( self.ypos-1, newtype, val )
    self.lastmodtype = newtype
    shouldMove = true
  elseif ( ( ftype == 'mod2' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newtype = self:editCCField( modtype, 2, char )
    self:addCCPt( self.ypos-1, newtype, val )
    self.lastmodtype = newtype
    shouldMove = true
  elseif ( ( ftype == 'mod3' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newval = self:editCCField( val, 1, char )
    self:addCCPt( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    shouldMove = true
  elseif ( ( ftype == 'mod4' ) and validHex( char ) ) then
    local modtype, val = self:getCC( self.ypos - 1 )
    local newval = self:editCCField( val, 2, char )
    self:addCCPt( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    shouldMove = true
  elseif ( ( ftype == 'modtxt1' ) and validHex( char ) ) then
    local modtypes = data.modtypes
    local modtype, val = self:getCC( self.ypos - 1, modtypes[chan] )
    local newval = self:editCCField( val, 1, char )
    self:addCCPt_channel( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    shouldMove = true
  elseif ( ( ftype == 'modtxt2' ) and validHex( char ) ) then
    local modtypes = data.modtypes
    local modtype, val = self:getCC( self.ypos - 1, modtypes[chan] )
    local newval = self:editCCField( val, 2, char )
    self:addCCPt_channel( self.ypos-1, modtype, newval )
    self.lastmodval = newval
    shouldMove = true
  elseif ( ftype == 'legato' ) then
    if ( char == '1' ) then
      self:addLegato( row )
    elseif ( char == '0' ) then
      self:deleteLegato( row )
    elseif ( char == '.' ) then
      self:deleteLegato( row )
    end
    shouldMove = true
  end

  if shouldMove then
    if shift then
      self:tab()
    else
      self.ypos = self.ypos + self.advance
    end
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
              print( 'I (' .. self.pitchTable[pitch2] .. ') am breaking my elongation on note !' .. self.pitchTable[pitch] )
            else
              local pitch2 = table.unpack( notes[noteToResize] )
              print( 'I (' .. self.pitchTable[pitch2] .. ') am breaking my elongation on an OFF symbol' )
            end
          end
          break
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) or ( ftype == 'end1' ) or ( ftype == 'end2' ) ) then
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) or ( ftype == 'end1' ) or ( ftype == 'end2' ) ) then
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
      newEnd = endppqpos
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
  if ( ( ftype == 'text' ) or ( ftype == 'vel1' ) or ( ftype == 'vel2' ) or ( ftype == 'delay1' ) or ( ftype == 'delay2' ) or ( ftype == 'end1' ) or ( ftype == 'end2' ) ) then
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
-- forceY indicates that a certain row must be in view!
function tracker:forceCursorInRange(forceY)
  local fov = self.fov
  if ( self.xpos < 1 ) then
    self.xpos = 1
  end
  local yTarget = forceY or self.ypos
  if ( yTarget < 1 ) then
    yTarget = 1
  end
  if ( self.ypos < 1 ) then
    self.ypos = 1
  end
  if ( self.xpos > self.max_xpos ) then
    self.xpos = math.floor( self.max_xpos )
  end
  if ( yTarget > self.max_ypos ) then
    yTarget = math.floor( self.max_ypos )
  end
  if ( self.ypos > self.max_ypos ) then
    self.ypos = math.floor( self.max_ypos )
  end

  -- Is the cursor off fov?
  if ( ( yTarget - fov.scrolly ) > self.fov.height ) then
    self.fov.scrolly = yTarget - self.fov.height
  end
  if ( ( yTarget - fov.scrolly ) < 1 ) then
    self.fov.scrolly = yTarget - 1
  end
  
  if (self.fov.scrolly + self.fov.height) > self.rows then
    self.fov.scrolly = math.max(0, yTarget - self.fov.height)
  end

  if ( self.cfg.followRow == 1 ) then
    local mpos = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
    reaper.SetEditCurPos2(0, mpos + (self.ypos-1) / self.rowPerSec, true, false)
  end

  -- Is the cursor off fov?
  if ( ( self.xpos - fov.scrollx ) > fov.width ) then
    self.fov.scrollx = self.xpos - fov.width
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

  return tracker.cfg.rowPerQn
end

function tracker:getSettings( )
  local oct, adv, env, modMode, rowOverride
  local foundOpt = 0
  if ( tracker.cfg.storedSettings == 1 ) then
    if ( self.take ) then
      local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
      for i=0,textsyxevtcntOut do
        local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")

        if ( string.sub(msg,1,3) == 'OPT' ) then
          if ( foundOpt == 0 ) then
            oct = tonumber( string.sub(msg,4,5) )
            adv = tonumber( string.sub(msg,6,7) )
            env = tonumber( string.sub(msg,8,9) )
            modMode = tonumber( string.sub(msg,10,10) )
            rowOverride = tonumber( string.sub(msg,11,12) )
            foundOpt = 1
          else
            self:SAFE_DeleteText(self.take, i)
          end
        end
      end
    end
  end

  self.transpose          = oct         or self.transpose       or tracker.cfg.transpose
  self.advance            = adv         or self.advance         or tracker.cfg.advance
  self.envShape           = env         or self.envShape        or tracker.cfg.envShape
  self.modMode            = modMode     or self.modMode         or tracker.cfg.modMode
  if ( self.cfg.overridePerPattern == 1 ) then
    self.cfg.rowOverride    = rowOverride or self.cfg.rowOverride
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

    reaper.MIDI_InsertTextSysexEvt(self.take, false, false, 0, 1, string.format( 'OPT%2d%2d%2d%d%2d', self.transpose, self.advance, self.envShape, self.modMode, self.cfg.rowOverride ) )
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
        str = str .. string.format( '%5d ', v )
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
  if ( self:validateCurrentItem() ) then
    self.rowPerQn = self:getResolution()

    -- How many rows do we need?
    local ppqPerQn    = reaper.MIDI_GetPPQPosFromProjQN(self.take, 1) - reaper.MIDI_GetPPQPosFromProjQN(self.take, 0)
    local ppqPerSec   = 1.0 / ( reaper.MIDI_GetProjTimeFromPPQPos(self.take, 1) - reaper.MIDI_GetProjTimeFromPPQPos(self.take, 0) )
    local mediaLength = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")

    self.length       = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    self.position     = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")

    self.maxppq       = ppqPerSec * self.length
    self.minppq       = ppqPerSec * self.position

    local qnCount      = mediaLength * ppqPerSec / ppqPerQn
    self.rowPerPpq    = self.rowPerQn / ppqPerQn
    self.ppqPerRow    = 1 / self.rowPerPpq
    self.rowPerSec    = ppqPerSec * self.rowPerQn / ppqPerQn
    self.ppqPerSec    = ppqPerSec
    local rows        = math.floor( self.rowPerQn * qnCount + 0.5 )

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
  else
    self.length     = 0
    self.position   = 0
    self.maxppq     = 0
    self.minppq     = 0
    self.rowPerPpq  = 0
    self.ppqPerRow  = 0
    self.rowPerSec  = 0
    self.ppqPerSec  = 0
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

    if ( self.showEnd[ channel ] == 1 ) then
      local curEnd = self:ppqToEnd( endppqpos )
      data.end1[rows*channel+ystart]  = self:velToField(curEnd, 1)
      data.end2[rows*channel+ystart]  = self:velToField(curEnd, 2)
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
  -- NaN guard
  if ( vel ~= vel ) then
    vel = 0
  end

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
  data.end1 = {}
  data.end2 = {}
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
      data.text[rows*x+y]   = -1
      data.vel1[rows*x+y]   = '.'
      data.vel2[rows*x+y]   = '.'
      if ( self.showDelays[x] == 1 ) then
        data.delay1[rows*x+y] = '.'
        data.delay2[rows*x+y] = '.'
      end
      if ( self.showEnd[x] == 1 ) then
        data.end1[rows*x+y] = '.'
        data.end2[rows*x+y] = '.'
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
    data.mod1[y] = -2
    data.mod2[y] = -2
    data.mod3[y] = -2
    data.mod4[y] = -2
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
  if ( not reaper.ValidatePtr2(0, self.take, "MediaItem_Take*") ) then
    self:tryPreviousItem()
  end

  if ( reaper.ValidatePtr2(0, self.take, "MediaItem_Take*") ) then
    -- Grab the notes and store them in channels
    local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)

    lastpitch = -1

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
          lastpitch = pitch
          lastend = endppqpos
        end
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
  local ch = 0

  local rowsize = self:rowToPpq(1)
  local ppqStart = self:rowToPpq(row)
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=ccevtcntOut,0,-1 do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
    msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )
    if ( ppqpos >= ppqStart ) then
      local moveIt = true
      msg2 = msg2 + chan * self.CCjump
      if ( modtype and ( modtype ~= msg2 ) ) then
        moveIt = false
      end

      if ( moveIt ) then
        reaper.MIDI_SetCC(self.take, i, nil, nil, ppqpos + rowsize, nil, nil, nil, nil, true)
      end
    end
  end
  self:deleteCC_range( self.rows, modtype )
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
    msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )
    msg2 = msg2 + chan * self.CCjump
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
    msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )
    msg2 = msg2 + chan * self.CCjump
    if ( ppqpos >= ppqStart and ppqpos < ppqEnd ) then
      local deleteIt = true

      if ( modtype ) then
        -- If a modtype is provided then we know which CC command / channel we are looking to delete
        if ( modtype ~= msg2 ) then
          deleteIt = false
        end
      else
        -- If not, then this means that we must be looking at channel 0 (default big first column)
        if ( chan ~= 0 ) then
          deleteIt = false
        end
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
  local ch = 0
  local isPC = false

  -- Decode the channel from the modtype
  if ( modtype ) then
    local ccJump = self.CCjump
    -- Is it a program change rather than a regular MIDI event?
    if ( modtype >= self.PCloc ) then
      ch = math.floor((modtype- self.PCloc) / ccJump)
      isPC = true
    else
      ch = math.floor(modtype / ccJump)
    end
  end

  local ppqStart = self:rowToPpq(row)
  local ppqEnd = self:rowToPpq( row + 1 ) - self.eps
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,ccevtcntOut do
    local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
    msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )

    -- Regular MIDI CC
    if ( ch ) then
      msg2 = msg2 + chan*self.CCjump
    end
    if ( ppqpos >= ppqStart and ppqpos < ppqEnd ) then
      local fetchIt = true
      if ( isPC ~= ( chanmsg == 192 ) ) then
        fetchIt = false
      end
      if ( modtype and ( modtype ~= msg2 ) ) then
        fetchIt = false
      end
      if ( chan ~= ch ) then
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
  local ch
  local ppqStart = self:rowToPpq(row, row+1, modtype)

  -- Is it an actual MIDI event or a Program Change?
  if ( modtype >= self.PCloc ) then
    modtype = modtype - self.PCloc
    ch = math.floor(modtype / self.CCjump)
    reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 192, ch, value, 0)
  else
    ch = math.floor(modtype / self.CCjump)
    reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 176, ch, modtype - ch*self.CCjump, value)
  end
end

-------------------
-- Add MIDI CC point to specific type
-------------------
function tracker:addCCPt_channel(row, modtype, value)
  self:deleteCC_range(row, row + 1, modtype)
  local ppqStart = self:rowToPpq(row)

  -- Is it an actual MIDI event or a Program Change?
  if ( modtype >= self.PCloc ) then
    modtype = modtype - self.PCloc
    ch = math.floor(modtype / self.CCjump)
    reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 192, ch, value, 0)
  else
    ch = math.floor(modtype / self.CCjump)
    reaper.MIDI_InsertCC(self.take, false, false, ppqStart, 176, ch, modtype - ch*self.CCjump, value)
  end
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

  if ( envShape == 4 ) then
    envShape = 6
  end

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
    if ( self.track ) then
      local autoidxs = {}
      local envelopeidxs = {}
      local signed = {}
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

        if ( value and ( value == value ) ) then
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

function tracker:addColAll()
  if ( self.showMod == 1 ) then
    tracker.renaming = 4
    tracker.newCol = ''
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

function tracker:createCCColAll()
  local data = self.data

  if ( not data.modtypes ) then
    data.modtypes = {}
  end

  if ( pcall( function () tonumber( tracker.newCol ) end ) ) then
    local newCol = tonumber( tracker.newCol )
    if ( newCol and ( newCol > -1 ) ) then
      for i=1,15 do
        data.modtypes[#data.modtypes+1] = newCol + self.CCjump * i
      end
      self:storeOpenCC()
    end
  else
    print("Passed invalid number")
  end
end

function tracker:addPatchSelect()
  local data = self.data

  if ( not data.modtypes ) then
    data.modtypes = {}
  end

  for i=1,15 do
    data.modtypes[#data.modtypes+1] = self.PCloc + self.CCjump * i
  end
  self:storeOpenCC()
end


function tracker:remCol()
  local data = self.data
  if ( self.showMod == 1 ) then
    if ( data.modtypes ) then
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

-- Seek tracker view to take starting at song position
function tracker:findTakeStartingAtSongPos(overridePosition)
  local playPos = overridePosition or reaper.GetPlayPosition()
  local nItems = reaper.GetTrackNumMediaItems(self.track)
  for i=0,nItems-1 do
    local item = reaper.GetTrackMediaItem(self.track, i)
    local loc = reaper.GetMediaItemInfo_Value(item, "D_POSITION")

    if ( playPos == loc ) then
      if ( self:tryTake(i) == true ) then
        self:update()
        self:resetShiftSelect()
        return 1
      end
    end
  end
end

-- Seek tracker view to take that contains song position
function tracker:findTakeAtSongPos()
  local playPos = reaper.GetPlayPosition()
  local nItems = reaper.GetTrackNumMediaItems(self.track)
  for i=0,nItems-1 do
    local item = reaper.GetTrackMediaItem(self.track, i)
    local loc = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
    local loc2 = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

    if ( playPos > loc and playPos < (loc+loc2) ) then
      if ( self:tryTake(i) == true ) then
        self:update()
        self:resetShiftSelect()
        return 1
      end
    end
  end
end

-- Check if a media item has MIDI
function tracker:hasMIDI(item)
  if ( item ) then
    local take = reaper.GetActiveTake(item)
    if ( take ) then
      if ( reaper.TakeIsMIDI( take ) == true ) then
        return true
      end
    end
  end
end

function tracker:useItem(item)
  local take = reaper.GetActiveTake(item)
  if ( take ) then
    if ( reaper.TakeIsMIDI( take ) == true ) then
      tracker:setItem( item )
      tracker:setTake( take )
      self:update()
      self:resetShiftSelect()
      return true
    end
  end
end

function tracker:findTakeClosestToSongPos(overridePos)

  local playPos
  if ( reaper.GetPlayState() > 0 ) then
    playPos = reaper.GetPlayPosition()
  else
    playPos = reaper.GetCursorPosition()
  end
  playPos = overridePos or playPos

  local nItems = reaper.GetTrackNumMediaItems  (self.track)
  local lastItem

  for i=0,nItems-1 do
    local item = reaper.GetTrackMediaItem(self.track, i)

    -- Is this a MIDI item that is usable to us?
    if ( self:hasMIDI(item) ) then
      local loc = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      local loc2 = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")

      -- Does the block we are looking at end beyond the play position?
      if ( (loc+loc2) > playPos ) then

        -- Did the block start before the play position?
        if ( loc <= playPos ) then
          self:useItem(item)
          return 1

        -- No? then if there is a last one, just take that one
        elseif (lastItem) then
          self:useItem(lastItem)
          return 1
        else
          self:useItem(item)
          return 1
        end
      end
      lastItem = item
    end
  end

  return nil
end

function tracker:setChannelMute(muteChannel, muteStatus)
  local retval, notecntOut, ccevtcntOut, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,notecntOut do
    local retval, selected, muted, startppqpos, endppqpos, chan, pitch, vel = reaper.MIDI_GetNote(self.take, i)
    if retval and chan == muteChannel then
      reaper.MIDI_SetNote(self.take, i, nil, muteStatus, nil, nil, nil, nil, nil, true)
    end
  end
  self.muted_channels[muteChannel] = muteStatus
end

function tracker:toggleSoloChannel()
  if not self.take then
    return
  end

  local _, soloChannel, _ = self:getLocation()
  
  -- Check if we are the only channel playing
  local isSolo = true
  for i=0,#self.muted_channels do
    if i == soloChannel then
      if self.muted_channels[i] then
        isSolo = false
      end
    else
      if not self.muted_channels[i] then
        isSolo = false
      end
    end
  end

  if isSolo then
    for i=0,#self.muted_channels do    
      self:setChannelMute(i, false)
    end
  else
    for i=0,#self.muted_channels do
      if i == soloChannel then
        self:setChannelMute(i, false)
      else
        self:setChannelMute(i, true)
      end
    end
  end
  
  reaper.MIDI_Sort(self.take)
end

function tracker:toggleMuteChannel()
  if not self.take then
    return
  end

  local _, muteChannel, _ = self:getLocation()
  self:setChannelMute(muteChannel, not self.muted_channels[muteChannel])
  reaper.MIDI_Sort(self.take)  
end

--------------------------------------------------------------
-- Update function
-- heavy-ish, avoid calling too often (only on MIDI changes)
--------------------------------------------------------------
function tracker:update()
  local reaper = reaper

  if ( self.debug == 1 ) then
    print( "Updating the grid ..." )
  end

  self:getRowInfo()
  self:getSettings()
  self:getTakeEnvelopes()
  self:initializeGrid()
  self:updateEnvelopes()
  self:updateNames()

  if ( self.take and self.item ) then

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
      local skip = self.CCjump
      if ( self.showMod == 1 ) then
        local modmode = self.modMode == 1 or self.cfg.channelCCs == 1
        if ( modmode ) then
          local all = self:getOpenCC()
          for i=0,ccevtcntOut do
            local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
            msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )

            all[msg2 + (chan)*skip] = 1
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
            modtypes[#modtypes+1] = v
          end
          if ( #modtypes > 0 ) then
            tracker:initializeModChannels(modtypes)
            for i=0,ccevtcntOut do
              local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
              msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )
              self:assignCC2( ppqpos, msg2 + (chan)*skip, msg3 )
            end
            self:storeOpenCC()
          else
            self:storeSettings()
          end
        end
        if ( modmode == false ) then
          for i=0,ccevtcntOut do
            local retval, selected, muted, ppqpos, chanmsg, chan, msg2, msg3 = reaper.MIDI_GetCC(self.take, i)
            --msg2, msg3 = encodeProgramChange( chanmsg, msg2, msg3 )
            if ( chanmsg ~= 192 and chan == 0 ) then
              self:assignCC( ppqpos, msg2, msg3 )
            end
          end
        end
      end

      ---------------------------------------------
      -- NOTES
      ---------------------------------------------
      local channels = {}
      local muted_channels = self.muted_channels
      if not self.muted_channels then
        muted_channels = {}
        for i = 0,self.channels do
          muted_channels[i] = false
        end
      end
      
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
          
          if muted then
            muted_channels[chan] = true
          end
        end
      end
      self.notes = notes
      self.muted_channels = muted_channels

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
  if not self.lastItem then
    self.lastItem = {}
  end
  self.lastItem[#self.lastItem + 1] = self.item
  self.item = item
  self.itemStart = reaper.GetMediaItemInfo_Value( self.item, "D_POSITION" )
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
      if self:validateCurrentItem() then      
        self.track = reaper.GetMediaItem_Track(self.item)
  
        -- Store note hash (second arg = notes only)
        self.hash = reaper.MIDI_GetHash( self.take, false, "?" )
        self.newRowPerQn = self:getResolution()
        self.outChannel = self:getOutChannel()
        self:update()
  
        if ( self.cfg.alwaysRecord == 1 ) then
          tracker:arm()
        end
  
        if tracker.noteNamesActive == 1 then
          tracker:getNoteNames()
        end
        
        self.muted_channels = nil
        return true
        
      else
        return false
      end
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

  -- If we have no take active at the moment, any take is better, so switch even when
  -- follow selection is off.
  if ( self.cfg.followSelection == 1 or not self.take ) then
    tracker:grabActiveItem()
    if ( tracker.cfg.loopFollow == 1 ) then
      tracker:setLoopToPattern()
    end
  end

  -- Did our take disappear?
  -- This can have many causes.
  if not pcall( self.testGetTake ) then

    -- Defer to the next update cycle (we may be glueing an object right now)
    -- When glueing from the arrange view, the item disappears and it takes a
    -- short while before the item is back.
    if ( not self.itemMissingDelay or self.itemMissingDelay < 10 ) then
      --reaper.defer(self.updateLoop)
      self.itemMissingDelay = (self.itemMissingDelay or 0) + 1
      return false
    else
      -- Try to find a new take
      self:tryPreviousItem()

      -- Try if we have a take now, if not, terminate...
      if not pcall( self.testGetTake ) then
        -- If it fails, we can't recover from the situation
        return false
      else
        -- If we do, make sure we reset the flag in case we glue more in the future
        self.itemMissingDelay = nil
        return true
      end
    end
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
        local envelopeCount = reaper.CountTrackEnvelopes(self.track)
        if ( ( currentHash ~= self.hash ) or ( self.modified == 1 ) or ( self.lastEnvelopeCount ~= envelopeCount ) ) then
          self.hash = currentHash
          self:update()
          self.lastEnvelopeCount = envelopeCount
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
function tracker:clearBlock(incp, cleanOffs)
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local notes     = self.notes
  local noteGrid  = data.note
  local noteStart = data.noteStart
  local rows      = self.rows
  local singlerow = self:rowToPpq(1)
  local cp        = incp or self.cp

  if ( self.debug == 1 ) then
    print( "Clearing block [" .. cp.xstart .. ", " .. cp.xstop .. "] [" .. cp.ystart .. ", " .. cp.ystop .. "]" )
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
  if ( cleanOffs ) then
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
  end
end

------------------
-- Mend block (check if notes at top can be extended)
------------------
function tracker:mendBlock(incp)
  local datafields, padsizes, colsizes, idxfields, headers, grouplink = self:grabLinkage()
  local data      = self.data
  local noteGrid  = data.note
  local noteStart = data.noteStart
  local notes     = self.notes
  local txtList   = self.txtList
  local rows      = self.rows
  local singlerow = self:rowToPpq(1)
  local cp        = incp or self.cp

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
  elseif ( chtype == 'end1' ) then
    return 2
  elseif ( chtype == 'end2' ) then
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
tracker.colgroups['delay1'] = { 'delay1', 'delay2' }
tracker.colgroups['delay2'] = { 'delay1', 'delay2' }
tracker.colgroups['end1'] = { 'end1', 'end2' }
tracker.colgroups['end2'] = { 'end1', 'end2' }
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
tracker.colref['delay1'] = 0
tracker.colref['delay2'] = -1
tracker.colref['end1'] = 0
tracker.colref['end2'] = -1
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

              local resize = self:ppqToRow(data[4]+refppq-endppqpos+self.magicOverlap)
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
              self:resizeNote(chan, self:ppqToRow(startppqpos), self:ppqToRow(data[2]+refppq-endppqpos+self.magicOverlap) )
              firstNote = 0
            else
              -- Otherwise, make it an explicit off
              self:addNoteOFF(data[2] + refppq, chan)
              firstNote = 0
            end
          elseif ( data[1] == 'LEG' ) then
            -- 'LEG', ppqposition
            --self:addLegato( self:ppqToRow(data[2] + refppq) )
            self:setLegato( self:ppqToRow(data[2] + refppq), true )
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

  local cp = self.cp
  local xstop = jx
  local xstart = self.xpos
  local ystart = self.ypos
  local yend = self.ypos + self.clipboard.maxrow

  if ( self.cfg.oldBlockBehavior == 0 ) then

    -- Before updating, take note of true note offs
    local trueOff = {}
    for jx = xstart,xstop do
      local chan = idxfields[ jx ]
      if ( datafields[jx] == 'text' ) then
        if ( noteGrid[chan * rows + yend] and noteGrid[chan * rows + yend] < 0 ) then
          trueOff[jx] = 1
        end
      end
    end

    -- Now the whole block will end with note offs
    self:insertNow()
    self:deleteNow()
    self:clearDeleteLists()
    self:clearInsertLists()

    reaper.MIDI_Sort(self.take)
    self:forceUpdate()

    local data      = self.data
    local noteGrid  = data.note

    for jx = xstart,xstop do
      local chan = idxfields[ jx ]

      if ( datafields[jx] == 'text' ) then
        -- If the last note is a note and it wasn't covered by a note off at first, then we need to do mending //and noteGrid[chan * rows + yend-1] and noteGrid[chan * rows + yend-1] > 0
        if ( noteGrid[chan * rows + yend]  ) then
          -- Only mend if we're dealing with a note off that was just generated, and not with a note
          if ( not trueOff[jx] and ( noteGrid[chan * rows + yend] ) < 0 ) then
            noteGrid[chan * rows + yend] = nil
            self:mendBlock({xstart=jx, xstop=jx, ystart=yend+1, yend=yend+1})
          end
        end
      end
    end
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
  newclipboard.maxrow = cp.ystop - cp.ystart

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
            if ( legato[lpos] and legato[lpos] > -1 ) then
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
  self:clearBlock(nil, 1)
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

  if ( cp.ystart == cp.ystop ) then
    return
  end

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

local function isPlaying()
  --local state = 0
  --local HasState = reaper.HasExtState("PlayPauseToggle", "ToggleValue")

  --if HasState == 1 then
  --  state = reaperGetExtState("PlayPauseToggle", "ToggleValue")
  --end

  return reaper.GetPlayState()
end

local function togglePlayPause()
  local reaper = reaper

  reaper.Main_OnCommand(40044, 0)
--  if ( isPlaying() == 0 ) then
--
--  else
--    reaper.Main_OnCommand(40073, 0)
--  end
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
  if checkMask then
    if ( checkMask[1] == control ) then
      if ( checkMask[2] == alt ) then
        if ( checkMask[3] == shift ) then
          if ( lastChar == checkMask[4] ) then
            return true
          end
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
        self:seen_item()
      end
    end
  end
end

function tracker:seen_item(ch)
  local _, _, _, textsyxevtcntOut = reaper.MIDI_CountEvts(self.take)
  for i=0,textsyxevtcntOut do
    local _, _, _, ppqpos, typeidx, msg = reaper.MIDI_GetTextSysexEvt(self.take, i, nil, nil, 1, 0, "")

    if ( string.sub(msg,1,7) == 'HT_SEEN' ) then
      return true
    end
  end
  
  reaper.MIDI_InsertTextSysexEvt(self.take, false, false, 0, 1, 'HT_SEEN' )
  return false
end

function tracker:getOutChannel( ch )
  if not pcall( self.testGetTake ) then
    return false
  end

  local chOut
  local retval, str = reaper.GetItemStateChunk( self.item, "")
  if ( not str:find("OUTCH") ) then
    if ( self:seen_item() ) then
      chOut = 0
    else
      chOut = tracker.outChannel
    end
  else
    chOut = tonumber(str:match("\nOUTCH ([-]*%d+)", 1))
  end

  return chOut
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
  if ( self.armed == 1 and self.track ) then
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
  if ( self.track ) then
    reaper.SetMediaTrackInfo_Value(self.track, "I_RECARM",   self.oldarm)
    reaper.SetMediaTrackInfo_Value(self.track, "I_RECINPUT", self.oldinput)
    reaper.SetMediaTrackInfo_Value(self.track, "I_RECMON",   self.oldmonitor)
    self.armed = 0
    self.hash = 0
    self:update()
  end
end

function tracker:playNote(chan, pitch, vel)
  self:checkArmed()
  
  local line_played = self.line_played or {}   
  if ( self.armed == 1 ) then
    local ch = 1
    self:stopNote()
    reaper.StuffMIDIMessage(0, 0x90 + ch - 1, pitch, vel)
    self.lastNote = {ch, pitch, vel}
    
    line_played[ch] = {}
    line_played[ch][0] = pitch
    line_played[ch][1] = vel
  end
  self.line_played = line_played
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

function tracker:stopAllNotes()
  self:checkArmed()
  if ( self.armed == 1) then
    self:stopNote()
    if self.line_played then
      local line_played = self.line_played
      for c = 1,self.channels do 
        if self.line_played[c] then
          reaper.StuffMIDIMessage(0, 0x80 + c - 1, line_played[c][0], line_played[c][1])
        end
      end
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
            break
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

function tracker:validateCurrentItem()
  local valid = reaper.ValidatePtr(self.take, "MediaItem_Take*") and reaper.ValidatePtr(self.item, "MediaItem*")
  if not valid then
    self.item = nil
    self.take = nil
    self:tryPreviousItem()
  end
  return valid
end

function tracker:setLoopToPattern()
  if self:validateCurrentItem() then
    local mpos = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
    local mlen = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
    reaper.GetSet_LoopTimeRange2(0, true, true, mpos, mpos+mlen, true)
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
        local retval, str = reaper.GetSetMediaItemTakeInfo_String(take, "P_NAME", "", false)
        if ( str == tracker.offTag ) then
          return false
        end

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
    local newItem = reaper.CreateNewMIDIItemInProj(self.track, mpos+mlen, mpos+2*mlen, false)
    local newTake = reaper.GetActiveTake(newItem)

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

  local targetChannel = tracker.outChannel
  tracker:seekMIDI(1)
  tracker.outChannel = targetChannel
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

function tracker:setPos(cpos)
  local mpos = reaper.GetMediaItemInfo_Value(self.item, "D_POSITION")
  local mlen = reaper.GetMediaItemInfo_Value(self.item, "D_LENGTH")
  self.ypos = math.floor( ( ( cpos - mpos ) / mlen ) * self.rows )
  self.fov.scrolly = 0
  self:forceCursorInRange()
end

function tracker:seekTrack( dir )
  local eps = 0.0001
  local oldtrack = self.track

  -- Find the location of the cursor
  local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
  local mlen = reaper.GetMediaItemInfo_Value(tracker.item, "D_LENGTH")
  local cpos = mpos + mlen * tracker.ypos / tracker.rows

  local trackidx
  local thisTrack = reaper.GetMediaItem_Track(self.item)
  for i=0,reaper.GetNumTracks() do
    if ( thisTrack == reaper.GetTrack(0, i) ) then
      trackidx = i
    end
  end
  local ntracks = reaper.GetNumTracks()

  -- Try ntracks times to find a new one (skips over empty tracks)
  local curTrack = trackidx
  for q = 1,ntracks do
    curTrack = curTrack + dir
    local ntracks = reaper.GetNumTracks()
    if ( curTrack < 0 ) then
      curTrack = ntracks-1
    elseif ( curTrack > ntracks-1 ) then
      curTrack = 0
    end
    self.track = reaper.GetTrack(0,curTrack)
    local nItems = reaper.GetTrackNumMediaItems(self.track)

    -- Attempt to find one we actually overlap with first
    local cur
    for i=0,nItems-1 do
      local mediaItem = reaper.GetTrackMediaItem(self.track, i)
      local item = reaper.GetTrackMediaItem(self.track, i)
      local mpos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      local mlen = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      local mend = mpos + mlen
      if ( cpos > ( mpos - eps ) ) and ( cpos < ( mend + eps ) ) then
        if ( self:tryTake(i) ) then
          if ( self.selectionFollows == 1 ) then
            self:selectCurrent()
          end
          self.track = proposedTrack
          tracker:setPos(cpos)
          return
        end
      end
    end

    -- Loop over all and find the distances to the cursor position
    local distances = {}
    for i=0,nItems-1 do

      local item = reaper.GetTrackMediaItem(self.track, i)
      local mpos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
      local mlen = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
      local mend = mpos + mlen
      local dist

      -- One we are considering is before the end
      if ( mend < cpos ) then
        dist = cpos - mend
      else
        dist = mpos - cpos
      end

      distances[i+1] = {i, dist}
    end

    table.sort(distances, function(a,b) return a[2] < b[2] end)
    for i,v in ipairs(distances) do
      if ( self:tryTake(v[1]) ) then
        if ( self.selectionFollows == 1 ) then
          self:selectCurrent()
        end
        self.track = proposedTrack
        tracker:setPos(cpos)
        return
      end
    end
  end

  self.track = oldtrack
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


-- Capture the mouse?
mouse_cap = 0
capture = {}
local function setCapMode( mode, ref, min, max )
  mouse_cap = mode
  capture.lastY = gfx.mouse_y
  capture.ref = ref
  capture.min = min
  capture.max = max
end

local function getCapValue( sensitivity )
  local movement = math.floor( sensitivity * ( capture.lastY - gfx.mouse_y ) )
  local value = capture.ref + movement

  return ( ( value - capture.min ) % (capture.max - capture.min + 1) ) + capture.min
end

function tracker:playLine()
  if ( self.armed == 0 ) then
     self:arm()
  end
     
  local line_played = self.line_played or {} 
  local data      = self.data
  local rows      = self.rows
  local notes     = self.notes
  local noteStart = data.noteStart
  local noteGrid  = data.note
  local ftype, chan, row = self:getLocation()
  for c = 1,self.channels do  
    local noteToEdit = noteStart[rows*c+row]
    local noteOff = noteGrid[rows*c+row] and noteGrid[rows*c+row] == -1
    
    if (noteOff) then
      if line_played[c] then
        reaper.StuffMIDIMessage(0, 0x80 + c - 1, line_played[c][0], line_played[c][1])
      end
    elseif noteToEdit then
      if line_played[c] then
         reaper.StuffMIDIMessage(0, 0x80 + c - 1, line_played[c][0], line_played[c][1])
      end
    
      local pitch, vel = table.unpack(notes[noteToEdit])
      reaper.StuffMIDIMessage(0, 0x90 + c - 1, pitch, vel)
      line_played[c] = {}
      line_played[c][0] = pitch
      line_played[c][1] = vel
    end
  end
  self.line_played = line_played
end

function tracker:gotoCurrentPosition()
  -- Check where we are
  local playPos = reaper.GetPlayPosition()
  local loc = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
  local loc2 = reaper.GetMediaItemInfo_Value(tracker.item, "D_LENGTH")
  if ( playPos < loc or playPos > ( loc+loc2 ) ) then
    if ( tracker.track ) then
      tracker:findTakeAtSongPos()
    end
  end
  local row = math.floor( ( playPos - loc ) * tracker.rowPerSec)
  tracker:forceCursorInRange(row)
end

function tracker:noteEdit()
  if self.take then
    reaper.Undo_OnStateChange2(0, "Tracker: Add note / Edit volume")
    reaper.MarkProjectDirty(0)
    local shift = gfx.mouse_cap & 8 > 0
    
    local ok, char = pcall(function () return string.char(lastChar) end)
    if shift and string.match(char,"[^%w]") == nil then
      if not tracker.shiftChordInProgress then
        tracker.shiftChordInProgress = true
        tracker.shiftChordStartXpos = tracker.xpos
      end
      tracker:createNote(lastChar + 32, true)
    else
      tracker:createNote(lastChar, false)
    end

    tracker:deleteNow()
    reaper.MIDI_Sort(tracker.take)
  end
end

------------------------------
-- Main update loop
-----------------------------
local function updateLoop()
  updateFontScale();
  
  local tracker = tracker
  tracker.updateLoop = updateLoop

  -- Check if the note data or take changed, if so, update the note contents
  if ( not tracker:checkChange() ) then
    tracker:lostItem()
  end

  -- Auto resize y
  if ( gfx.h > 1 ) then
    local grid = tracker.grid
    local newRows = math.floor(gfx.h / grid.dy)-3
    if ( newRows ~= self.rows and newRows > 2) then
      self.rows = newRows
      tracker.fov.height = newRows
      tracker:resetBlock()
      tracker:update()
    end
  end

  if ( tracker.cfg.colResize == 1 ) then
    tracker:autoResize()
    tracker:computeDims(tracker.rows)
    if ( tracker.fov.abswidth ~= tracker.fov.lastabswidth ) then
      tracker.fov.lastabswidth = tracker.fov.abswidth
      tracker:update()
    end
  end

  tracker:clearDeleteLists()
  tracker:clearInsertLists()

  tracker:resizeWindow()
  tracker:checkArmed()

  -- Maintain the loop until the window is closed or escape is pressed
  prevChar = lastChar
  lastChar = gfx.getchar()

  -- Check if the length changed, if so, update the time data
  if ( tracker:getRowInfo() == true ) then
    tracker:update()
  end

  if ( tracker.printKeys == 1 ) then
    if ( lastChar ~= 0 ) then
      print(lastChar)
      local control = gfx.mouse_cap & 4
      if ( control > 0 ) then print("ctrl") end
      local shift   = gfx.mouse_cap & 8
      if ( shift > 0 ) then  print("shift") end
      local alt     = gfx.mouse_cap & 16
      if ( alt > 0 ) then  print("alt") end
    end
  end

  -- if they were inputting a chord with shift but have just released it:
  if tracker.shiftChordInProgress and gfx.mouse_cap & 8 == 0 then
    tracker.shiftChordInProgress = false
    if tracker.cfg.returnAfterChord == 1 then
      tracker.xpos = tracker.shiftChordStartXpos
      tracker.ypos = tracker.ypos + tracker.advance
      tracker.shiftChordStartXpos = nil
    end
  end

  -- Mouse
  local left, right = mouseStatus()
  if ( tracker.fov.height < tracker.rows ) then
    if ( mouse_cap == 0 ) then
      local loc = tracker.scrollbar:mouseUpdate(gfx.mouse_x, gfx.mouse_y, left)
      if ( loc ) then
        tracker.ypos = math.floor(loc*(tracker.rows+1))
        tracker:forceCursorInRange()
      end
    end
  end

  if ( left == 1 and mouse_cap > 0 ) then
    if ( mouse_cap == 1 ) then
      -- Out
      tracker.outChannel = getCapValue( 0.05 )
    elseif ( mouse_cap == 2 ) then
      -- Envelope
      tracker.envShape = getCapValue( 0.05 )
    elseif ( mouse_cap == 3 ) then
      -- Advance
      tracker.advance = getCapValue( 0.05 )

      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif ( mouse_cap == 4 ) then
      -- Octave
      tracker.transpose = getCapValue( 0.05 )
    elseif ( mouse_cap == 5 ) then
      -- Resolution
      tracker.newRowPerQn = getCapValue( 0.05 )

      if ( right == 1 and tracker.lastright == 0 ) then
        tracker:setResolution( tracker.newRowPerQn )
        tracker:saveConfig(tracker.configFile, tracker.cfg)
        self.hash = math.random()
      end
    end
  end
  if ( left == 0 ) then
    if ( mouse_cap > 0 ) then
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    end
    mouse_cap = 0
  end

  if ( right == 1 ) then
    local plotData  = tracker.plotData
    local xloc      = plotData.xloc
    local yloc      = plotData.yloc
    if ( ( ( gfx.mouse_cap & 4 ) > 0 ) and ( ( gfx.mouse_cap & 8 ) > 0 ) ) then
      if ( gfx.mouse_x < xloc[1] ) then
        tracker.cfg.rowOverride = 0
        tracker:storeSettings()
      end
    end
  end

  if ( left == 1 and mouse_cap == 0 ) then
    local Inew
    local Jnew
    local plotData  = tracker.plotData
    local fov       = tracker.fov
    local xloc      = plotData.xloc
    local yloc      = plotData.yloc

    -- Mouse on track size indicator?
    local xl, yl, xm, ym = tracker:getSizeIndicatorLocation()
    if ( gfx.mouse_x > xl ) and ( gfx.mouse_x < xm ) and ( gfx.mouse_y < ym ) then
      if ( gfx.mouse_y > yl ) then
        tracker.renaming = 3
        tracker.newLength = tostring(tracker.max_ypos)
      else
        local function goto_position(i)
          tracker.ypos = i + fov.scrolly
          local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
          local loc = reaper.AddProjectMarker(0, 0, mpos + tracker:toSeconds(tracker.ypos-1), 0, "", -1)
          reaper.GoToMarker(0, loc, 0)
          reaper.DeleteProjectMarker(0, loc, 0)
        end
      
        -- Check where we need to move the play position
        for i=1,#yloc-1 do
          if ( ( gfx.mouse_y > yloc[i] ) and ( gfx.mouse_y < yloc[i+1] ) ) then
            goto_position(i)
          end
        end
        if ( gfx.mouse_y > yloc[#yloc] ) then
          goto_position(#yloc)
        end
      end
    end

    -- Mouse in range of bottom fields?
    if ( tracker.take ) then
      local strs, locs, yh = tracker:infoString()
      if ( gfx.mouse_y > yh and gfx.mouse_y < yh + 10 and gfx.mouse_x < xloc[#xloc] ) then
        -- Calculate the positions
        local strs, locs, yh = tracker:infoString()
        if ( gfx.mouse_x > locs[1] ) then
          setCapMode(1, tracker.outChannel, 0, 16) -- Out
        elseif ( gfx.mouse_x > locs[2] ) then
          setCapMode(2, tracker.envShape, 0, #tracker.envShapes ) -- Env
        elseif ( gfx.mouse_x > locs[3] ) then
          setCapMode(3, tracker.advance, -99, 99) -- Adv
        elseif ( gfx.mouse_x > locs[4] ) then
          setCapMode(4, tracker.transpose, tracker.minoct, tracker.maxoct) -- Oct
        elseif ( gfx.mouse_x > locs[5] ) then
          setCapMode(5, tracker.newRowPerQn, 1, tracker.maxRowPerQn) -- Res
        elseif ( gfx.mouse_x < plotData.xstart + gfx.measurestr("[Rec]") ) and ( gfx.mouse_x > plotData.xstart ) then
          if ( tracker.lastleft ~= 1 ) then
            tracker:toggleRec()
          end
        end
      end
    end

    if ( ( ( gfx.mouse_cap & 4 ) > 0 ) and ( ( gfx.mouse_cap & 8 ) > 0 ) ) then
      if ( gfx.mouse_x < xloc[1] ) then
        tracker.cfg.rowOverride = math.floor((gfx.mouse_y - yloc[1])/(yloc[2]-yloc[1]))
        tracker:storeSettings()
      end
    end

    -- Mouse in range of pattern data?
    if ( tracker.take ) then
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

    if ( tracker.harmonyActive == 1 ) then
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
            tracker:saveConfig(tracker.configFile, tracker.cfg)
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
            tracker:saveConfig(tracker.configFile, tracker.cfg)
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
      local themeMenu, keymapMenu, layoutMenu, fontsizeMenu, binaryOptions, fx1Menu, fx2Menu = tracker:optionLocations()

      if not tracker.holding then
        local sel
        -- Color schemes
        sel = themeMenu:processMouseMenu()
        if ( tracker.colorschemes[sel] ) then
          if ( tracker.colorschemes[sel] ~= tracker.cfg.colorscheme ) then
            changedOptions = 1
          end
          tracker.cfg.colorscheme = tracker.colorschemes[sel]
        end
  
        -- Key mappings
        sel = keymapMenu:processMouseMenu()
        if ( keysets[sel] ) then
          if ( keysets[sel] ~= tracker.cfg.keyset ) then
            changedOptions = 1
          end
          tracker.cfg.keyset = keysets[sel]
          setKeyboard(tracker.cfg.keyset)
        end
  
        -- Key Layout
        sel = layoutMenu:processMouseMenu()
        if ( keyLayouts[sel] ) then
          if ( keyLayouts[sel] ~= tracker.cfg.keyLayout ) then
            changedOptions = 1
          end
          tracker.cfg.keyLayout = keyLayouts[sel]
          setKeyboard(tracker.cfg.keyset)
        end
        
        changedOptions = fontsizeMenu:processSimple("fontSize", fontSizes) or changedOptions
        changedOptions = fx1Menu:processSimple("fx1", fx1Options) or changedOptions
        changedOptions = fx2Menu:processSimple("fx2", fx2Options) or changedOptions
        
        -- Binary options
        if ( gfx.mouse_x > binaryOptions.x ) then
          if ( gfx.mouse_y > binaryOptions.y ) then
            for i=1,#tracker.binaryOptions do
              local xs = binaryOptions.x
              local ys = binaryOptions.y + i * binaryOptions.h
              local xm = xs + 8
              local ym = ys + 8
              if ( ( gfx.mouse_x > xs ) and  ( gfx.mouse_x < xm ) and ( gfx.mouse_y > ys ) and ( gfx.mouse_y < ym ) ) then
                tracker.cfg[tracker.binaryOptions[i][1]] = 1 - tracker.cfg[tracker.binaryOptions[i][1]]
                changedOptions = 1
                tracker.holding = 1
              end
            end
          end
        end
      end  

      if ( changedOptions == 1 ) then
        tracker.holding = 1
        local cfg = tracker.cfg
        tracker:saveConfig(tracker.configFile, cfg)
        tracker:loadColors(cfg.colorscheme)
        tracker:initColors()
        tracker:loadKeys(cfg.keyset)
        tracker:forceUpdate()
        updateShown()
      end
    end
  else
    if ( tracker.lastChord ) then
      tracker:stopChord()
    end
    tracker.holding = nil
  end
  tracker.lastleft = left
  tracker.lastright = right

  if ( gfx.mouse_wheel ~= 0 ) then
    tracker.ypos = tracker.ypos - math.floor( gfx.mouse_wheel / 120 )
    tracker:resetShiftSelect()
    gfx.mouse_wheel = 0
  end

  local modified = 0
  if ( tracker.renaming == 0 ) then
    if inputs('left') and tracker.take then
      tracker.xpos = tracker.xpos - 1
      tracker:resetShiftSelect()
    elseif inputs('right') and tracker.take then
      tracker.xpos = tracker.xpos + 1
      tracker:resetShiftSelect()
    elseif inputs('up') and tracker.take then
      tracker.ypos = tracker.ypos - 1
      tracker:resetShiftSelect()
    elseif inputs('down') and tracker.take then
      tracker.ypos = tracker.ypos + 1
      tracker:resetShiftSelect()
    elseif inputs('upByAdvance') and tracker.take then
      tracker.ypos = tracker.ypos - tracker.advance
      tracker:resetShiftSelect()
    elseif inputs('downByAdvance') and tracker.take then
      tracker.ypos = tracker.ypos + tracker.advance
      tracker:resetShiftSelect()
    elseif inputs('shiftleft') and tracker.take then
      tracker:dragBlock()
      tracker.xpos = tracker.xpos - 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftright') and tracker.take then
      tracker:dragBlock()
      tracker.xpos = tracker.xpos + 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftup') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos - 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftdown') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos + 1
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftpgdn') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos + tracker.cfg.page
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftpgup') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = tracker.ypos - tracker.cfg.page
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shifthome') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = 0
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('shiftend') and tracker.take then
      tracker:dragBlock()
      tracker.ypos = tracker.rows
      tracker:forceCursorInRange()
      tracker:dragBlock()
    elseif inputs('off') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Place OFF")
      reaper.MarkProjectDirty(0)
      tracker:placeOff()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('off2') and tracker.take then
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()

      if ( datafields[tracker.xpos] == "text" ) then
        modified = 1
        reaper.Undo_OnStateChange2(0, "Tracker: Place OFF")
        reaper.MarkProjectDirty(0)
        tracker:placeOff()
        tracker:deleteNow()
        reaper.MIDI_Sort(tracker.take)
      else
        tracker:noteEdit()
      end
    elseif ( inputs('delete') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete (Del)")
      tracker:delete()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('delete2') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete (Del)")
      tracker:delete()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      tracker.ypos = tracker.ypos + tracker.advance
    elseif ( inputs('deleteRow') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete row (Del)")
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      tracker:clearBlock({xstart=1, ystart=tracker.ypos, xstop=#datafields, ystop=tracker.ypos})
      tracker:mendBlock({xstart=1, ystart=tracker.ypos, xstop=#datafields, ystop=tracker.ypos})
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      tracker.ypos = tracker.ypos + tracker.advance
    elseif ( inputs('insertRow') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Insert Row")
      local cpS = tracker:saveClipboard()
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      tracker.cp = {xstart=1, ystart=tracker.ypos, xstop=#datafields, ystop=tracker.rows-1}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      local oldx = tracker.xpos
      tracker.xpos = 1
      tracker.ypos = tracker.ypos + 1
      tracker:pasteBlock()
      tracker.xpos = oldx
      tracker.ypos = tracker.ypos - 1
      tracker:loadClipboard(cpS)
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('removeRow') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Remove Row")
      local cpS = tracker:saveClipboard()
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      tracker.cp = {xstart=1, ystart=tracker.ypos+1, xstop=#datafields, ystop=tracker.rows}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      local oldx = tracker.xpos
      tracker.xpos = 1
      tracker:pasteBlock()
      tracker.xpos = oldx
      tracker:loadClipboard(cpS)
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('wrapDown') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Wrap down")
      local oldx = tracker.xpos
      local oldy = tracker.ypos
      local cpS = tracker:saveClipboard()

      -- Cut  last line to a special clipboard
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      tracker.cp = {xstart=1, ystart=tracker.rows, xstop=#datafields, ystop=tracker.rows}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      local lastLineClipboard = tracker.clipboard

      -- Shift block
      tracker.cp = {xstart=1, ystart=1, xstop=#datafields, ystop=tracker.rows-1}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)

      -- Paste block one shifted
      tracker.ypos = 2
      tracker.xpos = 1
      tracker:pasteBlock()

      -- Restore clipboard and paste line that fell off
      tracker.clipboard = lastLineClipboard
      tracker.ypos = 1
      tracker.xpos = 1
      tracker:pasteBlock()

      tracker:loadClipboard(cpS)
      tracker.xpos = oldx
      tracker.ypos = oldy
    elseif ( inputs('wrapUp') and tracker.take ) then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Wrap up")
      local oldx  = tracker.xpos
      local oldy  = tracker.ypos
      local cpS   = tracker:saveClipboard()

      -- Cut block to special clipboard
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      tracker.cp = {xstart=1, ystart=2, xstop=#datafields, ystop=tracker.rows}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
      local chunk = tracker.clipboard

      -- Cut  first line to a special clipboard
      tracker.cp = {xstart=1, ystart=1, xstop=#datafields, ystop=1}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)

      -- Paste line that fell off
      tracker.xpos = 1
      tracker.ypos = tracker.rows
      tracker:pasteBlock()

      -- Paste block one shifted up
      tracker.xpos = 1
      tracker.ypos = 1
      tracker.clipboard = chunk
      tracker:pasteBlock()
      tracker:deleteNow()
      tracker:insertNow()
      reaper.MIDI_Sort(tracker.take)


      tracker:loadClipboard(cpS)
      tracker.xpos = oldx
      tracker.ypos = oldy

    elseif inputs('home') and tracker.take then
      tracker.ypos = 0
    elseif inputs('End') and tracker.take then
      tracker.ypos = tracker.rows
    elseif inputs('m0') and tracker.take then
      tracker.ypos = 0
    elseif inputs('m25') and tracker.take then
      tracker.ypos = math.ceil(tracker.rows * 0.25)+1
    elseif inputs('m50') and tracker.take then
      tracker.ypos = math.ceil(tracker.rows * 0.5)+1
    elseif inputs('m75') and tracker.take then
      tracker.ypos = math.ceil(tracker.rows * 0.75)+1
    elseif inputs('toggle') then
      togglePlayPause()
    elseif inputs('renoiseplay') and tracker.take then
      local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
      local loc = reaper.AddProjectMarker(0, 0, mpos + tracker:toSeconds(0), 0, "", -1)
      reaper.GoToMarker(0, loc, 0)
      reaper.DeleteProjectMarker(0, loc, 0)
      togglePlayPause()
    elseif inputs('playfrom') and tracker.take then
      if ( isPlaying() > 0 ) then
        -- Determine where we stopped relative to the current media object
        local playpos = reaper.GetPlayPosition()
        local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
        local mlen = reaper.GetMediaItemInfo_Value(tracker.item, "D_LENGTH")
        if ( playpos > mpos and playpos < (mpos+mlen) ) then
          tracker.ypos = math.floor( (playpos-mpos) / mlen * tracker.rows ) + 1
        end
      end

      local mpos = reaper.GetMediaItemInfo_Value(tracker.item, "D_POSITION")
      local loc = reaper.AddProjectMarker(0, 0, mpos + tracker:toSeconds(tracker.ypos-1), 0, "", -1)
      reaper.GoToMarker(0, loc, 0)
      reaper.DeleteProjectMarker(0, loc, 0)
      togglePlayPause()
    elseif inputs('insert') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Insert")
      reaper.MarkProjectDirty(0)
      tracker:insert()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('remove') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Backspace")
      reaper.MarkProjectDirty(0)
      tracker:backspace()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('pgup') and tracker.take then
      tracker.ypos = tracker.ypos - tracker.cfg.page
    elseif inputs('pgdown') and tracker.take then
      tracker.ypos = tracker.ypos + tracker.cfg.page
    elseif inputs('undo') and tracker.take then
      modified = 1
      reaper.Undo_DoUndo2(0)
    elseif inputs('redo') and tracker.take then
      modified = 1
      reaper.Undo_DoRedo2(0)
    elseif inputs('deleteBlock') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Delete block")
      reaper.MarkProjectDirty(0)
      tracker:deleteBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('beginBlock') and tracker.take then
      tracker:beginBlock()
    elseif inputs('endBlock') and tracker.take then
      tracker:endBlock()
    elseif ( inputs('copyBlock') or inputs('copyBlock2') ) and tracker.take then
      tracker:copyBlock()
    elseif inputs('copyColumn') and tracker.take then
      local oldcp = tracker.cp
      tracker.cp = {xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows}
      tracker:copyBlock()
      tracker.cp = oldcp
    elseif inputs('copyPattern') and tracker.take then
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local oldcp = tracker.cp
      tracker.cp = {xstart=1, ystart=1, xstop=#datafields, ystop=tracker.rows}
      tracker:copyBlock()
      tracker.cp = oldcp
    elseif ( inputs('cutBlock') or inputs('cutBlock2') ) and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Cut block")
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('cutColumn') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Cut column")
      local oldcp = tracker.cp
      tracker.cp = {xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker.cp = oldcp
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('cutPattern') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Cut pattern")
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local oldcp = tracker.cp
      tracker.cp = {xstart=1, ystart=1, xstop=#datafields, ystop=tracker.rows}
      reaper.MarkProjectDirty(0)
      tracker:cutBlock()
      tracker.cp = oldcp
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('pasteBlock') or inputs('pasteBlock2') ) and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Paste block")
      reaper.MarkProjectDirty(0)
      tracker:pasteBlock()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('pasteColumn') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Paste column")
      reaper.MarkProjectDirty(0)
      local oldpos = tracker.ypos
      tracker.ypos = 1
      tracker:pasteBlock()
      tracker.ypos = oldpos
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('pastePattern') and tracker.take then
      modified = 1
      reaper.Undo_OnStateChange2(0, "Tracker: Paste pattern")
      reaper.MarkProjectDirty(0)
      local oldx = tracker.xpos
      local oldy = tracker.ypos
      tracker.xpos = 1
      tracker.ypos = 1
      tracker:pasteBlock()
      tracker.xpos = oldx
      tracker.ypos = oldy
      reaper.MIDI_Sort(tracker.take)
    elseif ( inputs('shiftItemUp') or inputs('shblockup') ) and tracker.take then
      modified = 1
      tracker:shiftup()
    elseif ( inputs('shiftItemDown') or inputs('shblockdown') ) and tracker.take then
      modified = 1
      tracker:shiftdown()
    elseif inputs('shcoldown') and tracker.take then
      modified = 1
      tracker:shiftdown({xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows})
    elseif inputs('shcolup') and tracker.take then
      modified = 1
      tracker:shiftup({xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows})
    elseif inputs('shpatdown') and tracker.take then
      modified = 1
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local x = 1
      while ( x < #datafields ) do
        if ( datafields[x] == 'text' ) then
          break
        end
        x = x + 1
      end
      tracker:shiftdown({xstart=x, ystart=1, xstop=#datafields, ystop=tracker.rows}, 1)
    elseif inputs('shpatup') and tracker.take then
      modified = 1
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local x = 1
      while ( x < #datafields ) do
        if ( datafields[x] == 'text' ) then
          break
        end
        x = x + 1
      end
      tracker:shiftup({xstart=x, ystart=1, xstop=#datafields, ystop=tracker.rows}, 1)
    elseif inputs('colOctDown') and tracker.take then
      modified = 1
      tracker:shiftdown({xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows}, 1, 12)
    elseif inputs('colOctUp') and tracker.take then
      modified = 1
      tracker:shiftup({xstart=tracker.xpos, ystart=1, xstop=tracker.xpos, ystop=tracker.rows}, 1, 12)
    elseif inputs('patternOctDown') and tracker.take then
      modified = 1
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local x = 1
      while ( x < #datafields ) do
        if ( datafields[x] == 'text' ) then
          break
        end
        x = x + 1
      end
      tracker:shiftdown({xstart=x, ystart=1, xstop=#datafields, ystop=tracker.rows}, 1, 12)
    elseif inputs('patternOctUp') and tracker.take then
      modified = 1
      local datafields, padsizes, colsizes, idxfields, headers, grouplink = tracker:grabLinkage()
      local x = 1
      while ( x < #datafields ) do
        if ( datafields[x] == 'text' ) then
          break
        end
        x = x + 1
      end
      tracker:shiftup({xstart=x, ystart=1, xstop=#datafields, ystop=tracker.rows}, 1, 12)
    elseif inputs('blockOctUp') and tracker.take then
      modified = 1
      tracker:shiftup(nil, 1, 12)
    elseif inputs('blockOctDown') and tracker.take then
      modified = 1
      tracker:shiftdown(nil, 1, 12)
    elseif inputs('scaleUp') and tracker.take then
      modified = 1
      tracker:shiftScaleUp()
    elseif inputs('scaleDown') and tracker.take then
      modified = 1
      tracker:shiftScaleDown()
    elseif inputs('octaveup') and tracker.take then
      tracker.transpose = tracker.transpose + 1
      if ( tracker.transpose > tracker.maxoct ) then
        tracker.transpose = tracker.maxoct
      end
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('octavedown') and tracker.take then
      tracker.transpose = tracker.transpose - 1
      if ( tracker.transpose < tracker.minoct ) then
        tracker.transpose = tracker.minoct
      end
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('envshapeup') and tracker.take then
      tracker.envShape = tracker.envShape + 1
      if ( tracker.envShape > #tracker.envShapes ) then
        tracker.envShape = 0
      end
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('envshapedown') and tracker.take then
      tracker.envShape = tracker.envShape - 1
      if ( tracker.envShape < 0 ) then
        tracker.envShape = #tracker.envShapes
      end
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('outchanup') and tracker.take then
      tracker.outChannel = tracker.outChannel + 1
      if ( tracker.outChannel > 16 ) then
        tracker.outChannel = 0
      end
      tracker:setOutChannel( tracker.outChannel )
    elseif inputs('outchandown') and tracker.take then
      tracker.outChannel = tracker.outChannel - 1
      if ( tracker.outChannel < 0) then
        tracker.outChannel = 16
      end
      tracker:setOutChannel( tracker.outChannel )
    elseif inputs('advanceup') and tracker.take then
      tracker.advance = tracker.advance + 1
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('advancedown') and tracker.take then
      tracker.advance = math.max(tracker.advance - 1, 0)
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('advanceDouble') and tracker.take then
      -- max() with 1 because if they are doubling from 0 they probably
      -- want it to actually increase and not just stay there
      tracker.advance = math.max(tracker.advance * 2, 1)
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('advanceHalve') and tracker.take then
      tracker.advance = math.ceil(tracker.advance / 2)
      tracker:storeSettings()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('resolutionUp') and tracker.take then
      if ( prevChar ~= lastChar ) then
        tracker.newRowPerQn = tracker.newRowPerQn + 1
        if ( tracker.newRowPerQn > tracker.maxRowPerQn ) then
          tracker.newRowPerQn = 1
        end
      end
    elseif inputs('resolutionDown') and tracker.take then
      if ( prevChar ~= lastChar ) then
        tracker.newRowPerQn = tracker.newRowPerQn - 1
        if ( tracker.newRowPerQn < 1 ) then
          tracker.newRowPerQn = tracker.maxRowPerQn
        end
      end
    elseif inputs('stop2') then
      reaper.Main_OnCommand(1016, 0)
    elseif inputs('panic') then
      reaper.Main_OnCommand(40345, 0)
    elseif inputs('harmony') then
      tracker.harmonyActive = 1-(tracker.harmonyActive or 0)
      tracker:resizeWindow()
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('noteNames') then
      if tracker.noteNamesActive == 0 then
        tracker:getNoteNames()
        tracker.noteNamesActive = 1
      else
        tracker.noteNamesActive = 0
      end
      tracker:resizeWindow()
    elseif inputs('help') then
      tracker.helpActive = 1-tracker.helpActive
      tracker:resizeWindow()
    elseif inputs('options') or inputs('options2') then
      tracker.optionsActive = 1-tracker.optionsActive
      tracker:resizeWindow()
    elseif inputs('nextMIDI') then
      tracker:seekMIDI(1)
      tracker:resizeWindow()
      if ( tracker.cfg.loopFollow == 1 ) then
        tracker:setLoopToPattern()
      end
    elseif inputs('prevMIDI') then
      tracker:seekMIDI(-1)
      tracker:resizeWindow()
      if ( tracker.cfg.loopFollow == 1 ) then
        tracker:setLoopToPattern()
      end
    elseif inputs('nextTrack') then
      tracker:seekTrack(1)
      tracker:resizeWindow()
      if ( tracker.cfg.loopFollow == 1 ) then
        tracker:setLoopToPattern()
      end
    elseif inputs('prevTrack') then
      tracker:seekTrack(-1)
      tracker:resizeWindow()
      if ( tracker.cfg.loopFollow == 1 ) then
        tracker:setLoopToPattern()
      end
    elseif inputs('duplicate') and tracker.take then
      reaper.Undo_OnStateChange2(0, "Tracker: Duplicate pattern")
      reaper.MarkProjectDirty(0)
      tracker:duplicate()
    elseif inputs('commit') and tracker.take then
      tracker:setResolution( tracker.newRowPerQn )
      tracker:saveConfig(tracker.configFile, tracker.cfg)
      self.hash = math.random()
    elseif inputs('setloop') and tracker.take then
      tracker:setLoopToPattern()
    elseif inputs('setloopstart') and tracker.take then
      tracker:setLoopStart()
    elseif inputs('setloopend') and tracker.take then
      tracker:setLoopEnd()
    elseif inputs('follow') and tracker.take then
      tracker.cfg.followSong = 1 - tracker.cfg.followSong
      tracker:saveConfig(tracker.configFile, tracker.cfg)
    elseif inputs('interpolate') and tracker.take then
      reaper.Undo_OnStateChange2(0, "Tracker: Interpolate")
      reaper.MarkProjectDirty(0)
      tracker:interpolate()
      tracker:deleteNow()
      reaper.MIDI_Sort(tracker.take)
    elseif inputs('showMore') and tracker.take then
      tracker:showMore()
    elseif inputs('showLess') and tracker.take then
      tracker:showLess()
    elseif inputs('tab') and tracker.take then
      tracker:tab()
    elseif inputs('shifttab') and tracker.take then
      tracker:shifttab()
    elseif inputs('addCol') and tracker.take then
      tracker:addCol()
    elseif inputs('addColAll') and tracker.take then
      tracker:addColAll()
    elseif inputs('addPatchSelect') and tracker.take then
      tracker:addPatchSelect()
    elseif inputs('remCol') and tracker.take then
      tracker:remCol()
    elseif inputs('rename') and tracker.take then
      tracker.oldMidiName = tracker.midiName
      tracker.midiName = ''
      tracker.renaming = 1
      tracker:updateMidiName()
    elseif inputs('playline') then
      tracker:playLine()
    elseif inputs('toggleRec') then
      tracker:toggleRec()
    elseif inputs('mute') then
      tracker:toggleMuteChannel()
    elseif inputs('solo') then
      tracker:toggleSoloChannel()
    elseif( inputs('closeTracker') ) then
      tracker:terminate()
    elseif inputs('escape') then
      if ( tracker.armed == 1 ) then
        tracker.onlyListen = 1 - tracker.onlyListen
      end
    elseif ( lastChar == 0 ) then
      -- No input
    elseif ( lastChar == -1 ) then
      -- Closed window
    else
      for i,v in pairs( commandKeys ) do
        if ( inputs(i) ) then
          local cmd = reaper.NamedCommandLookup( v[5] )
          if ( cmd and ( cmd > 0 ) ) then
            reaper.Main_OnCommand(cmd, 0)
          else
            tracker.callScript( tracker, v[5] )
            if ( v[6] and v[6] == 1 and tracker.cfg.closeWhenSwitchingToHP == 1 ) then
              tracker:terminate()
            end
          end
        end
      end

      -- Notes here
      modified = 1
      tracker:noteEdit()
    end
  elseif( tracker.renaming == 1 ) then
    -- Renaming pattern
    if inputs( 'enter' ) then
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
    if inputs( 'enter' ) then
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
    if inputs( 'enter' ) then
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
  elseif ( tracker.renaming == 4 ) then
    -- Adding column to all patterns
    if inputs( 'enter' ) then
      tracker.renaming = 0
      tracker:createCCColAll()
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
  end

  tracker:forceCursorInRange()
  if ( tracker.cfg.followSong == 1 ) then
    if ( reaper.GetPlayState() ~= 0 ) then
      tracker:gotoCurrentPosition()
    end
  end

  if ( not self.noDraw or self.noDraw == 0 ) then
    tracker:printGrid()
  end
  gfx.update()
  tracker:insertNow()

  -- Remove duplicates potentially caused by legato system
  if ( modified == 1 and tracker.take and not tracker.terminated ) then
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
    tracker:terminate()
  end
end

function tracker:saveClipboard()
  local storage = {}
  storage.oldcp = self.cp
  storage.oldcpcontent = self.clipboard
  return storage
end

function tracker:loadClipboard(storage)
  self.cp         = storage.oldcp
  self.clipboard  = storage.oldcpcontent
end

function tracker:terminate()
  self:stopAllNotes()
  self.terminated = 1

  local d, x, y, w, h = gfx.dock(-1,1,1,1,1)
  tracker:saveConfigFile("_wpos.cfg", {
    d=d,
    x=x,
    y=y,
    w=w,
    h=h,
    harmonyActive=tracker.harmonyActive,
    noteNamesActive=tracker.noteNamesActive,
    helpActive=tracker.helpActive,
    optionsActive=tracker.optionsActive,
  })
  tracker:saveConfig(tracker.configFile, tracker.cfg)

  gfx.quit()
end

function tracker:toggleRec()
  if ( self.armed == 1 ) then
     self:stopNote()
     self:disarm()
  else
     self:arm()
  end
end

function tracker:autoResize()
  local siz = gfx.w
  if ( tracker.harmonyActive == 1 ) then
    siz = siz - self.harmonyWidth
  end
  if ( tracker.noteNamesActive == 1 ) then
    siz = siz - self.noteNamesWidth
  end
  if ( tracker.helpActive == 1 ) then
    siz = siz - self.helpwidth
  end
  if ( tracker.optionsActive == 1 ) then
    siz = siz - self.optionswidth
  end

  gfx.setfont(1, self.colors.patternFont, self.colors.patternFontSize)
  local minsize = gfx.measurestr("Res [88] Oct [88] Adv [88] Env [Fst] Out [88] [Rec] 8888888888 ")
  self.toosmall = 0
  if ( tracker.cfg.minimumSize == 1) then
    if ( siz < minsize ) then
      siz = minsize
      local v, wx, wy, ww, wh
      local d, wx, wh = gfx.dock(-1, 1, 1, nil, nil)
      reinitializeWindow(self.windowTitle, width, height, d, wx, wh)
    end
  elseif ( siz < 130 ) then
    siz = 130
    self.toosmall = 1
    local v, wx, wy, ww, wh
    local d, wx, wh = gfx.dock(-1, 1, 1, nil, nil)
    reinitializeWindow(self.windowTitle, width, height, d, wx, wh)
  elseif ( siz < minsize ) then
    self.toosmall = 1
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
  if tracker.harmonyActive == 1 then
    width = width + self.harmonyWidth
    if rows < 26 then
      rows = 26
    end
  end
  if tracker.noteNamesActive == 1 then
    width = width + self.noteNamesWidth
    if rows < 16 then
      rows = 16
    end
  end
  if tracker.helpActive == 1 then
    width = width + self.helpwidth
    if rows < 16 then
      rows = 16
    end
  end
  if tracker.optionsActive == 1 then
    width = width + self.optionswidth
    if rows < 16 then
      rows = 16
    end
  end

  local grid = tracker.grid
  height = grid.originy + (rows+1) * grid.dy + 2*grid.itempady

  if ( tracker.helpActive == 1 ) then
    local mhelp = #help * 14 + 12
    if ( height < mhelp ) then
      height = mhelp
    end
  end

  if ( tracker.cfg.autoResize == 0 ) then
    if ( self.lastY ) then
      height = self.lastY
    else
      local wpos = tracker:loadConfig("_wpos.cfg", {})
      height = wpos.h
      width = wpos.w
    end
  end

  local changed
  if ( not self.lastY or ( self.lastY ~= height ) or not self.lastX or ( self.lastX ~= width ) ) then
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
    reinitializeWindow( self.windowTitle, width, height, d, wx, wh )
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

  if ( self.trackName ) then
    self.windowTitle = string.format('%s [%s], ', self.name, self.trackName)
  else
    self.windowTitle = string.format('%s', self.name)
  end
  if ( self.midiName:len() > maxsize ) then
    self.patternName = string.format('%s/%s>', self.trackName, self.midiName:sub(1,maxsize))
  else
    self.patternName = string.format('%s/%s', self.trackName, self.midiName:sub(1,maxsize))
  end
end

function tracker:getNoteNames()
  if tracker.track then
    -- track_num as returned here is one-indexed, but as used by GetTrackMIDINoteName, it's zero-indexed (christ)
    local track_num = reaper.GetMediaTrackInfo_Value(tracker.track, 'IP_TRACKNUMBER') - 1

    -- can't actually tell whether channel makes a difference here?
    -- sorta seems like it does not, but whatever

    -- GetTrackMIDINoteName takes a channel to query, and note names can be set for a particular channel, at least in theory
    -- but it seems that in practice they're generally just set for all channels, so here we just query channel zero instead of bothering to query the tracker's specific channel
    -- if it turns out to matter, we can get the channel from tracker.outChannel
    local channel = 0

    -- start at 12 because notes 0-11 are octave -1, which isn't in pitchTable
    for note = 12, 127 do
      noteNames[note] = reaper.GetTrackMIDINoteName(track_num, note, channel)
    end
  end
end

function tracker:loadConfig(fn, cfg)
    local file = io.open(get_script_path()..fn, "r")

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

function tracker:saveConfig(fn, cfg)
  cfg.root      = scales.root
  cfg.scale     = scales.curScale
  cfg.rowPerQn  = tracker.rowPerQn
  cfg.transpose = tracker.transpose
  cfg.advance   = tracker.advance
  cfg.envShape  = tracker.envShape

  tracker:saveConfigFile( fn, cfg )
end

function tracker:saveConfigFile(fn, cfg)
  local dir = get_script_path()
  local filename = dir..fn
  local file = io.open(filename, "w+")

  if ( file ) then
    io.output(file)
    for i,v in pairs(cfg) do
      io.write( string.format('%s=%s\n', i, v) )
    end
    io.close(file)
  end
end

function tracker:readInt(var)
  local ok, v = reaper.GetProjExtState(0, "MVJV001", var)
  if ( ok ) then v = tonumber( v ) end
  return v
end

function tracker:grabActiveItem()
    -- Check if there is an override going on
    local v = self:readInt("initialiseAtTrack")
    local v2 = self:readInt("initialiseAtRow")
    reaper.SetProjExtState(0, "MVJV001", "initialiseAtTrack", "")
    reaper.SetProjExtState(0, "MVJV001", "initialiseAtRow", "")
    if ( v ) then
      self.track = reaper.GetTrack(0,v)
      return self:findTakeClosestToSongPos(v2)
    else
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
end

local function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function Main()
  local tracker = tracker
  local reaper = reaper

  local kfn = get_script_path()..tracker.keyFile
  if ( not file_exists(kfn) ) then
    local fhandle = io.open(kfn, "w")
    io.output(fhandle)
    io.write("  -- This file can be used to define own custom keysets. Every keyset needs to be declared in\n")
    io.write("  -- extrakeysets. The actual keyset can then be defined in an if-statement in loadCustomKeys().\n")
    io.write("  -- This file will not be overwritten when hackey trackey updates, so your keysets are safe.\n")
    io.write("  -- Note that if new keys get added in the future, that you will have to update this file manually\n")
    io.write("  -- or else the new keys will revert to their defaults.\n")
    io.write("  --\n")
    io.write("  -- Missing keys will be taken from the default set.\n")
    io.write("\n")
    io.write("  extrakeysets = { \"custom\" }\n")
    io.write("\n")
    io.write("  function loadCustomKeys(keyset)\n")
    io.write("    if keyset == \"custom\" then\n")
    io.write("    --                    CTRL    ALT SHIFT Keycode\n")
    io.write("    keys.left           = { 0,    0,  0,    1818584692 }    -- <-\n")
    io.write("    keys.right          = { 0,    0,  0,    1919379572 }    -- ->\n")
    io.write("    keys.up             = { 0,    0,  0,    30064 }         -- /\\\n")
    io.write("    keys.down           = { 0,    0,  0,    1685026670 }    -- \\/\n")
    io.write("    keys.off            = { 0,    0,  0,    45 }            -- -\n")
    io.write("    keys.delete         = { 0,    0,  0,    6579564 }       -- Del\n")
    io.write("    keys.delete2        = { 0,    0,  0,    46 }            -- .\n")
    io.write("    keys.home           = { 0,    0,  0,    1752132965 }    -- Home\n")
    io.write("    keys.End            = { 0,    0,  0,    6647396 }       -- End\n")
    io.write("    keys.toggle         = { 0,    0,  0,    32 }            -- Space\n")
    io.write("    keys.playfrom       = { 0,    0,  0,    13 }            -- Enter\n")
    io.write("    keys.enter          = { 0,    0,  0,    13 }            -- Enter\n")
    io.write("    keys.insert         = { 0,    0,  0,    6909555 }       -- Insert\n")
    io.write("    keys.remove         = { 0,    0,  0,    8 }             -- Backspace\n")
    io.write("    keys.pgup           = { 0,    0,  0,    1885828464 }    -- Page up\n")
    io.write("    keys.pgdown         = { 0,    0,  0,    1885824110 }    -- Page down\n")
    io.write("    keys.undo           = { 1,    0,  0,    26 }            -- CTRL + Z\n")
    io.write("    keys.redo           = { 1,    0,  1,    26 }            -- CTRL + SHIFT + Z\n")
    io.write("    keys.beginBlock     = { 1,    0,  0,    2 }             -- CTRL + B\n")
    io.write("    keys.endBlock       = { 1,    0,  0,    5 }             -- CTRL + E\n")
    io.write("    keys.cutBlock       = { 1,    0,  0,    24 }            -- CTRL + X\n")
    io.write("    keys.pasteBlock     = { 1,    0,  0,    22 }            -- CTRL + V\n")
    io.write("    keys.copyBlock      = { 1,    0,  0,    3 }             -- CTRL + C\n")
    io.write("    keys.shiftItemUp    = { 0,    0,  1,    43 }            -- SHIFT + Num pad +\n")
    io.write("    keys.shiftItemDown  = { 0,    0,  1,    45 }            -- SHIFT + Num pad -\n")
    io.write("    keys.scaleUp        = { 1,    1,  1,    267 }           -- CTRL + SHIFT + ALT + Num pad +\n")
    io.write("    keys.scaleDown      = { 1,    1,  1,    269 }           -- CTRL + SHIFT + ALT + Num pad -\n")
    io.write("    keys.octaveup       = { 1,    0,  0,    30064 }         -- CTRL + /\\\n")
    io.write("    keys.octavedown     = { 1,    0,  0,    1685026670 }    -- CTRL + \\/\n")
    io.write("    keys.envshapeup     = { 1,    0,  1,    30064 }         -- CTRL + SHIFT + /\\\n")
    io.write("    keys.envshapedown   = { 1,    0,  1,    1685026670 }    -- CTRL + SHIFT + /\\\n")
    io.write("    keys.help           = { 0,    0,  0,    26161 }         -- F1\n")
    io.write("    keys.outchandown    = { 0,    0,  0,    26162 }         -- F2\n")
    io.write("    keys.outchanup      = { 0,    0,  0,    26163 }         -- F3\n")
    io.write("    keys.advancedown    = { 0,    0,  0,    26164 }         -- F4\n")
    io.write("    keys.advanceup      = { 0,    0,  0,    26165 }         -- F5\n")
    io.write("    keys.stop2          = { 0,    0,  0,    26168 }         -- F8\n")
    io.write("    keys.harmony        = { 0,    0,  0,    26169 }         -- F9\n")
    io.write("    keys.noteNames      = { 0,    0,  0,    6697264 }       -- F10\n")
    io.write("    keys.options        = { 0,    0,  0,    6697265 }       -- F11\n")
    io.write("    keys.panic          = { 0,    0,  0,    6697266 }       -- F12\n")
    io.write("    keys.setloop        = { 1,    0,  0,    12 }            -- CTRL + L\n")
    io.write("    keys.setloopstart   = { 1,    0,  0,    17 }            -- CTRL + Q\n")
    io.write("    keys.setloopend     = { 1,    0,  0,    23 }            -- CTRL + W\n")
    io.write("    keys.interpolate    = { 1,    0,  0,    9 }             -- CTRL + I\n")
    io.write("    keys.shiftleft      = { 0,    0,  1,    1818584692 }    -- Shift + <-\n")
    io.write("    keys.shiftright     = { 0,    0,  1,    1919379572 }    -- Shift + ->\n")
    io.write("    keys.shiftup        = { 0,    0,  1,    30064 }         -- Shift + /\\\n")
    io.write("    keys.shiftdown      = { 0,    0,  1,    1685026670 }    -- Shift + \\/\n")
    io.write("    keys.deleteBlock    = { 0,    0,  1,    6579564 }       -- Shift + Del\n")
    io.write("    keys.resolutionUp   = { 0,    1,  1,    30064 }         -- SHIFT + Alt + Up\n")
    io.write("    keys.resolutionDown = { 0,    1,  1,    1685026670 }    -- SHIFT + Alt + Down\n")
    io.write("    keys.commit         = { 0,    1,  1,    13 }            -- SHIFT + Alt + Enter\n")
    io.write("    keys.nextMIDI       = { 1,    0,  0,    1919379572.0 }  -- CTRL + ->\n")
    io.write("    keys.prevMIDI       = { 1,    0,  0,    1818584692.0 }  -- CTRL + <-\n")
    io.write("    keys.duplicate      = { 1,    0,  0,    4 }             -- CTRL + D\n")
    io.write("    keys.rename         = { 1,    0,  0,    14 }            -- CTRL + N\n")
    io.write("    keys.escape         = { 0,    0,  0,    27 }            -- Escape\n")
    io.write("    keys.toggleRec      = { 1,    0,  0,    18 }            -- CTRL + R\n")
    io.write("    keys.showMore       = { 1,    0,  0,    11 }            -- CTRL + +\n")
    io.write("    keys.showLess       = { 1,    0,  0,    13 }            -- CTRL + -\n")
    io.write("    keys.addCol         = { 1,    0,  1,    11 }            -- CTRL + Shift + +\n")
    io.write("    keys.remCol         = { 1,    0,  1,    13 }            -- CTRL + Shift + -\n")
    io.write("    keys.addColAll      = { 1,    0,  1,    1 }             -- CTRL + Shift + A\n")
    io.write("    keys.addPatchSelect = { 1,    0,  1,    16 }            -- CTRL + Shift + P\n")
    io.write("    keys.tab            = { 0,    0,  0,    9 }             -- Tab\n")
    io.write("    keys.shifttab       = { 0,    0,  1,    9 }             -- SHIFT + Tab\n")
    io.write("    keys.follow         = { 1,    0,  0,    6 }             -- CTRL + F\n")
    io.write("    keys.deleteRow      = { 1,    0,  0,    6579564 }       -- Ctrl + Del\n")
    io.write("    keys.closeTracker   = { 1,    0,  0,    6697266 }       -- Ctrl + F12\n")
    io.write("    keys.nextTrack      = { 1,    0,  1,    1919379572.0 }  -- CTRL + Shift + ->\n")
    io.write("    keys.prevTrack      = { 1,    0,  1,    1818584692.0 }  -- CTRL + Shift + <-\n")
    io.write("\n")
    io.write("    keys.insertRow      = { 1,    0,  0,    6909555 }       -- Insert row CTRL+Ins\n")
    io.write("    keys.removeRow      = { 1,    0,  0,    8 }             -- Remove Row CTRL+Backspace\n")
    io.write("    keys.wrapDown       = { 1,    0,  1,    6909555 }       -- CTRL + SHIFT + Ins\n")
    io.write("    keys.wrapUp         = { 1,    0,  1,    8 }             -- CTRL + SHIFT + Backspace\n")
    io.write("\n")
    io.write("    keys.m0             = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.m25            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.m50            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.m75            = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.off2           = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.renoiseplay    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shpatdown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shpatup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shcoldown      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shcolup        = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shblockdown    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.shblockup      = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.upByAdvance    = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.downByAdvance  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.advanceDouble  = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("    keys.advanceHalve   = { 0,    0,  0,    500000000000000000000000 }    -- Unassigned\n")
    io.write("\n")
    io.write("    keys.cutPattern     = { 1,    0,  0,    500000000000000000000000 }\n")
    io.write("    keys.cutColumn      = { 1,    0,  1,    500000000000000000000000 }\n")
    io.write("    keys.cutBlock2      = { 1,    1,  0,    500000000000000000000000 }\n")
    io.write("    keys.copyPattern    = { 1,    0,  0,    500000000000000000000000 }\n")
    io.write("    keys.copyColumn     = { 1,    0,  1,    500000000000000000000000 }\n")
    io.write("    keys.copyBlock2     = { 1,    1,  0,    500000000000000000000000 }\n")
    io.write("    keys.pastePattern   = { 1,    0,  0,    500000000000000000000000 }\n")
    io.write("    keys.pasteColumn    = { 1,    0,  1,    500000000000000000000000 }\n")
    io.write("    keys.pasteBlock2    = { 1,    1,  0,    500000000000000000000000 }\n")
    io.write("    keys.patternOctDown = { 1,    0,  0,    500000000000000000000000.0 }\n")
    io.write("    keys.patternOctUp   = { 1,    0,  0,    500000000000000000000000.0 }\n")
    io.write("    keys.colOctDown     = { 1,    0,  1,    500000000000000000000000.0 }\n")
    io.write("    keys.colOctUp       = { 1,    0,  1,    500000000000000000000000.0 }\n")
    io.write("    keys.blockOctDown   = { 1,    1,  0,    500000000000000000000000.0 }\n")
    io.write("    keys.blockOctUp     = { 1,    1,  0,    500000000000000000000000.0 }\n")
    io.write("\n")
    io.write("    keys.shiftpgdn      = { 0,    0,  1,    1885824110 }    -- Shift + PgDn\n")
    io.write("    keys.shiftpgup      = { 0,    0,  1,    1885828464 }    -- Shift + PgUp\n")
    io.write("    keys.shifthome      = { 0,    0,  1,    1752132965 }    -- Shift + Home\n")
    io.write("    keys.shiftend       = { 0,    0,  1,    6647396 }       -- Shift + End\n")
    io.write("\n")
    io.write("    help = {\n")
    io.write("      { 'Shift + Note', 'Advance column after entry' },\n")
    io.write("      { 'Insert/Backspace/-', 'Insert/Remove/Note OFF' },\n")
    io.write("      { 'CTRL + Insert/Backspace', 'Insert Row/Remove Row' },\n")
    io.write("      { 'CTRL + Shift + Ins/Bksp', 'Wrap Forward/Backward' },\n")
    io.write("      { 'Del/.', 'Delete' },\n")
    io.write("      { 'Space/Return', 'Play/Play From' },\n")
    io.write("      { 'CTRL + L', 'Loop pattern' },\n")
    io.write("      { 'CTRL + Q/W', 'Loop start/end' },\n")
    io.write("      { 'Shift + +/-', 'Transpose selection' },\n")
    io.write("      { 'CTRL + B/E', 'Selection begin/End' },\n")
    io.write("      { 'SHIFT + Arrow Keys', 'Block selection' },\n")
    io.write("      { 'CTRL + C/X/V', 'Copy / Cut / Paste' },\n")
    io.write("      { 'CTRL + I', 'Interpolate' },\n")
    io.write("      { 'Shift + Del', 'Delete block' },\n")
    io.write("      { 'CTRL + (SHIFT) + Z', 'Undo / Redo' },\n")
    io.write("      { 'SHIFT + Alt + Up/Down', '[Res]olution Up/Down' },\n")
    io.write("      { 'SHIFT + Alt + Enter', '[Res]olution Commit' },\n")
    io.write("      { 'CTRL + Up/Down', '[Oct]ave up/down' },\n")
    io.write("      { 'CTRL + Shift + Up/Down', '[Env]elope change' },\n")
    io.write("      { 'F4/F5', '[Adv]ance De/Increase' },\n")
    io.write("      { 'F2/F3', 'MIDI [out] down/up' },\n")
    io.write("      { 'F8/F12', 'Stop / Panic' },\n")
    io.write("      { 'F10/F11', 'Note Names / Options' },\n")
    io.write("      { 'CTRL + Left/Right', 'Switch MIDI item/track' },\n")
    io.write("      { 'CTRL + Shift + Left/Right', 'Switch Track' },\n")
    io.write("      { 'CTRL + D', 'Duplicate pattern' },\n")
    io.write("      { 'CTRL + N', 'Rename pattern' },\n")
    io.write("      { 'CTRL + R', 'Play notes' },\n")
    io.write("      { 'CTRL + +/-', 'Advanced col options' },\n")
    io.write("      { 'CTRL + Shift + +/-', 'Add CC (adv mode)' },\n")
    io.write("      { 'CTRL + Shift + A/P', 'Per channel CC/PC' },\n")
    io.write("      { '', '' },\n")
    io.write("      { 'Harmony helper', '' },\n")
    io.write("      { 'F9', 'Toggle harmonizer' },\n")
    io.write("      { 'CTRL + Click', 'Insert chord' },\n")
    io.write("      { 'Alt', 'Invert first note' },\n")
    io.write("      { 'Shift', 'Invert second note' },\n")
    io.write("      { 'CTRL + Shift + Alt + +/-', 'Shift root note' },\n")
    io.write("    }\n")
    io.write("  end\n")
    io.write("end\n")
    io.write("\n")
    io.write("-- Defines where the notes are on the virtual keyboard\n")
    io.write("function loadCustomKeyboard(choice)\n")
    io.write("  if ( choice == \"custom\" ) then\n")
    io.write("    local c = 12\n")
    io.write("    keys.pitches = {}\n")
    io.write("    keys.pitches.z = 24-c\n")
    io.write("    keys.pitches.x = 26-c\n")
    io.write("    keys.pitches.c = 28-c\n")
    io.write("    keys.pitches.v = 29-c\n")
    io.write("    keys.pitches.b = 31-c\n")
    io.write("    keys.pitches.n = 33-c\n")
    io.write("    keys.pitches.m = 35-c\n")
    io.write("    keys.pitches.s = 25-c\n")
    io.write("    keys.pitches.d = 27-c\n")
    io.write("    keys.pitches.g = 30-c\n")
    io.write("    keys.pitches.h = 32-c\n")
    io.write("    keys.pitches.j = 34-c\n")
    io.write("    keys.pitches.q = 36-c\n")
    io.write("    keys.pitches.w = 38-c\n")
    io.write("    keys.pitches.e = 40-c\n")
    io.write("    keys.pitches.r = 41-c\n")
    io.write("    keys.pitches.t = 43-c\n")
    io.write("    keys.pitches.y = 45-c\n")
    io.write("    keys.pitches.u = 47-c\n")
    io.write("    keys.pitches.i = 48-c\n")
    io.write("    keys.pitches.o = 50-c\n")
    io.write("    keys.pitches.p = 52-c\n")
    io.write("\n")
    io.write("    keys.octaves = {}\n")
    io.write("    keys.octaves['0'] = 0\n")
    io.write("    keys.octaves['1'] = 1\n")
    io.write("    keys.octaves['2'] = 2\n")
    io.write("    keys.octaves['3'] = 3\n")
    io.write("    keys.octaves['4'] = 4\n")
    io.write("    keys.octaves['5'] = 5\n")
    io.write("    keys.octaves['6'] = 6\n")
    io.write("    keys.octaves['7'] = 7\n")
    io.write("    keys.octaves['8'] = 8\n")
    io.write("    keys.octaves['9'] = 9\n")
    io.write("  end\n")
    io.write("end\n")
    io.write("")
    io.close(fhandle)
  end

  local ret, str = pcall(function() dofile(kfn) end)
  if ( not ret ) then
    reaper.ShowMessageBox("Error parsing " .. tracker.keyFile .. "\nError: " .. str .. "\nTerminating.", "FATAL ERROR", 0)
    return
  else
    if ( not extrakeysets ) then
      reaper.ShowMessageBox("Error parsing " .. tracker.keyFile .. "\nDid not find variable extrakeysets. Please delete userkeys.lua.\nTerminating.", "FATAL ERROR", 0)
      return
    end

    for i,v in pairs( extrakeysets ) do
      table.insert(keysets, v)
    end
    tracker.loadCustomKeys      = loadCustomKeys
    tracker.loadCustomKeyboard  = loadCustomKeyboard
  end


  --if ( reaper.CountSelectedMediaItems(0) > 0 or tracker:readInt("initialiseAtTrack") ) then
    tracker.tick = 0
    tracker.xposunset = 1
    tracker.scrollbar = scrollbar.create(tracker.scrollbar.size)

    -- Load user options
    local cfg = tracker:loadConfig(tracker.configFile, tracker.cfg)
    updateShown()
    tracker:loadColors(cfg.colorscheme)
    tracker:initColors()

    -- Revert to default if selected keyset does not exist
    local found = 0
    for i,v in pairs( keysets ) do
      if ( cfg.keyset == v ) then
        found = 1
      end
    end
    if ( found == 0 ) then
      cfg.keyset = "default"
    end

    tracker:loadKeys(cfg.keyset)
    setKeyboard(cfg.keyset)
    tracker.cfg = cfg
    
    updateFontScale()

    if ( cfg.root and ( scales.root ~= cfg.root ) ) then
      scales:switchRoot( cfg.root )
    end
    if ( cfg.scale and ( scales.curScale ~= cfg.scale ) ) then
      scales:setScale( cfg.scale )
    end

    tracker:generatePitches()
    tracker:initColors()
    tracker:grabActiveItem()
    local wpos = tracker:loadConfig("_wpos.cfg", {})

    tracker.harmonyActive = wpos.harmonyActive or tracker.harmonyActive
    tracker.noteNamesActive = wpos.noteNamesActive or tracker.noteNamesActive
    tracker.helpActive = wpos.helpActive or tracker.helpActive
    tracker.optionsActive = wpos.optionsActive or tracker.optionsActive
    local width, height = tracker:computeDims(48)
    tracker:updateNames()

    --if ( wpos.w and wpos.w > width ) then
      width = wpos.w or width
    --end
    if ( wpos.h ) then
      height = wpos.h or height
    end
    local xpos = wpos.x or 200
    local ypos = wpos.y or 200

    if ( width > tracker.cfg.maxWidth ) then
      width = tracker.cfg.maxWidth
    end
    if ( height > tracker.cfg.maxHeight ) then
      height = tracker.cfg.maxHeight
    end
    gfx.init(tracker.windowTitle, width, height, wpos.d, xpos, ypos)
    tracker.windowHeight = height

    if ( tracker.outChannel ) then
      tracker:setOutChannel( tracker.outChannel )
    end

    if ( tracker.cfg.initLoopSet == 1 ) then
      tracker:setLoopToPattern()
    end

    reaper.defer(updateLoop)

  --else
  --  reaper.ShowMessageBox("Please select a MIDI item before starting the tracker", "No MIDI item selected", 0)
  --end
end

Main()
