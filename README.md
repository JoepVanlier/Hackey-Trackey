# Hackey-Trackey
## What is it?
A lightweight tracker plugin for REAPER 5.x and up. Hackey-Trackey is a small 
tracker for visualizing and editing MIDI data within REAPER. Designed to mimick 
the pattern editor of Jeskola Buzz, this tracker is meant to enable MIDI note 
entry and effect automation in a tracked manner.

![Using Hackey Trackey](https://i.imgur.com/o6QXh8X.png)

## What is it not?
A sampler. Hackey-Trackey does not handle sample playback. For this you would 
need to add an additional VST that handles sample playback. Have a look at 
ReViSiT or linking Renoise to REAPER if this is what you seek.

## Small disclaimer
Hackey Trackey is still actively being developed. Not all planned features are finished yet. Be sure to check back in the future if you want to be kept up to date with the latest features. That said, basic tracking functionality works (note entry, FX sequencing) and directly updates MIDI and automation data.

## How do I use it?
Select a MIDI object and start the script. Note that scripts can be bound to 
shortcut keys, which I'd recommend if you're going to be using it.

The plugin remaps your MIDI data to different channels. New MIDI 
data that was not tracked has to come in on channel 0. Note also that the 
tracker outputs everything to MIDI channel 0 by default.

Parameters for which envelopes are active (see automation panel in image below), 
will automatically show up in the tracker. The tracker will store the tracked 
points in an automation take.
![Using FX](https://i.imgur.com/pZ0TV7k.png)

By default, tracked notes do not overlap. However, for some purposes, overlap may be
desirable (some monophonic VSTs interpret this as glide/legato mode). For this, one can 
use the column L. Setting 1 in a row here, means that this note will be glided into. 
This is implemented by simpliy stretching the previous note. Legato is only applied 
to channel 1 in the tracker. Note that performing a legato from and to the same note 
will result in the second note not displaying in the tracker. This is not a bug, but a 
workaround to fix note OFF issues with the resulting MIDI item.

## Special keys

| Key                   | Action                                                                |
|:----------------------|:----------------------------------------------------------------------|
| Arrow keys            | Navigate                                                              |
| Backspace             | Delete item and shift rows up                                         |
| Del                   | Delete item                                                           |
| Insert                | Shift all items down by one                                           |
| \-                    | Place note OFF                                                        |
| ENTER                 | Start play at cursor position                                         |
| Space                 | Start/Stop                                                            |
| CTRL \+ B             | Start selection block                                                 |
| CTRL \+ E             | End selection block                                                   |
| CTRL \+ Z             | Undo                                                                  |
| CTRL \+ SHIFT + Z     | Redo                                                                  |
| CTRL \+ X             | Cut \(To do\)                                                         |
| CTRL \+ V             | Paste \(To do\)                                                       |
| CTRL \+ C             | Copy \(To do\)                                                        |
| CTRL \+ /\\           | Shift current octave up                                               |
| CTRL \+ \\/           | Shift current octave down                                             |
| SHIFT \+ CTRL \+ /\\  | Switch envelope mode \(FX automation\)                                |
| SHIFT \+ CTRL \+ \\/  | Switch envelope mode \(FX automation\)                                |
| Shift \+ Numpad \+    | Shift selection up \(e.g. C\-1 \-> C\#1\)                             |
| Shift \+ Numpad \-    | Shift selection down                                                  |

## Feature requests
Feature requests are always welcome, preferably with an idea of how to achieve it with the Reaper API ( https://www.reaper.fm/sdk/reascript/reascripthelp.html#l ). If you've implemented a feature yourself and want it added to the trunk, submit a pull requests. If possible, try and make sure that the pull request is up to date with the latest version. I will do my best to review and incorporate these.

## How does it work?
Hackey trackey maps already existing MIDI data to a tracked format and allows 
editing of such data in a tracker-based manner. If the MIDI data was 
entered via another method than Hackey Trackey, the default behaviour is to 
map the notes to non-overlapping channels. Once this is done, the channels for 
the MIDI data are remapped such that the column in which a note appears is 
stable from that point on. Note that if your instruments use the MIDI channel 
information for specific purposes then this plugin is not useful to you. Note 
that depending on what you are doing, the plugin may also add text events to 
your MIDI data to keep track of information Hackey Trackey needs to preserve 
the tracked layout.

The plugin uses the MIDI note channel property to store which column a note 
is in. OFF note termination symbols not associated with a normal note end 
and legato symbols are stored in text (OFF+channel and LEG respectively).

Because the plugin remaps the channel, non-tracker input should be created with 
channel 0. The plugin remaps data in channel 0 to MIDI channel 1-16, automatically
assigning new incoming notes to a column where enough room is available. Notes in 
channel 1-16 are assigned first, to keep anything that was made in the tracker 
stable.

The location of the notes in the tracker view will be stable as long as no data 
is entered into MIDI channels other than zero via the piano roll or other methods.

Because typically, it is preferred to have MIDI data go to a specific out channel, 
the plugin optionally maps all the MIDI data to a specific channel via the out-channel 
property.

## Issues/Limitations
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

Note that when using the legato mode, it is no longer possible to have the same note 
be repeated on channel 1. Doing so would cause problems when playing the MIDI. Hence  
1 D-2  
1 D-2  
would be merged into one single MIDI note. I have not found a good workaround for this 
so far, but if you have a good idea, please contact me.

### Planned features
- Cut/Copy pasting blocks within the tracker.
- Interpolation.

### Features to be investigated whether they are feasible/reasonable
- Columns for MIDI controls.
- Cutting/Copying to MIDI editor clipboard.
