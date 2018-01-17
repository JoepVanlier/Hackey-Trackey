# Hackey-Trackey
A lightweight tracker plugin for REAPER 5.x and up. Hackey-Trackey is a small 
tracker for visualizing and editing MIDI data within REAPER. Note that it does not
function as a sampler. Designed to mimick the pattern editor of Jeskola Buzz, this
tracker is meant to enable note entry in a tracked manner.

Hackey trackey maps already existing MIDI data to a tracked format and allows 
editing of such data in a tracker based manner. If the MIDI data was 
entered via another method than Hackey Trackey, the default behaviour is to 
map the notes to non-overlapping channels. Once this is done, the channels for 
the MIDI data are remapped such that the column in which a note appears can be 
maintained. Note that if your instruments use the MIDI channel information for 
specific purposes then this plugin is not useful to you. Note that depending on 
what you are doing, the plugin may also add text events to your MIDI data to keep 
track of information Hackey Trackey needs to preserve the tracked layout.

Note that non-tracker input should be drawn with channel 0, to make the plugin 
work as intended. The plugin remaps data in channel 0 to MIDI channel 1-16. 
It does so after assigning the notes already in channel 1-16 to their respective 
columns in the tracker. If your plugins simply need their MIDI data to arrive at 
a specific channel, then you can always remap the MIDI channel by forcing a 
specific MIDI output channel. This limits you to one channel output per MIDI block 
however.

The location of the notes in the tracker view will be stable as long as no data 
is entered into MIDI channels other than zero via the piano roll or other methods.

# Issues/Limitations
There are some things which are unfortunately not possible as far as I am aware.
Voice stealing when placing overlapping tracked patterns is one of them. In Jeskola 
Buzz it was possible to play different patterns on the same row in the sequencer. 
This would cause notes that came from one pattern to stop notes coming from another 
pattern. This adaptive merging is not possible in this tracker since the 
different tracker instances are unaware of each-other's existence and overlapping 
MIDI elements act independently.

There is a second annoyance that comes with this, which is that for notes to be 
held over a pattern, they must be restarted at the start of the new pattern. The 
tracker has no way of seeing what notes may still be playing at the end of previous
MIDI items. It may be possible to find a workaround for this in the future by 
scanning the timeline for previous MIDI items and adding such notes automatically.

Velocities can only be entered at a note start. Whereas in a tracker, every row can 
have its own velocity (modulation the notes velocity over time), it is not possible 
to assign multiple velocities to a single MIDI note. By default, when entering a 
velocity in a new line, the last MIDI note on that tracked channel will be copied to 
mimick the same end behaviour.

# Special keys
| Key                   | Action 						|
| --------------------- | ----------------------------------------------------- |
| Arrow keys 		| Navigate						|
| Backspace 		| Delete item and move all subsequent rows one up	|
| Del 			| Delete item						|
| Insert 		| Shift all items down by one				|
| \- 			| Place note OFF					|
| CTRL + B 		| Start selection block 				|
| CTRL + E 		| End selection block 					|
| CTRL + Z   		| Undo							|
| CTRL + SHIFT + Z 	| Redo							|
| CTRL + X 		| Cut (To do)						|
| CTRL + V 		| Paste (To do)						|
| CTRL + C 		| Copy (To do)						|
| Shift + Numpad +	| Shift all elements in selection one up		|
| Shift + Numpad -	| Shift all elements in selection one down		|

# Planned features
- Cut/Copy pasting blocks within the tracker.
- Legato vs non-legato playing (non-legato makes sure that the MIDI notes do not touch).
  This is meant for monophonic plugins which 'glide' from one note to another when notes 
  overlap.
- Interpolation.

# Features to be investigated whether they are feasible/reasonable
- Columns for MIDI controls.
- Cutting/Copying to MIDI editor clipboard.
- Showing columns arising from different MIDI objects side by side

