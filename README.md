# Hackey-Trackey

A lightweight LUA tracker plugin for REAPER. Hackey-Trackey is a small tracker 
for visualizing and editing MIDI data within REAPER.

Hackey trackey maps the MIDI data to a tracked format. If the MIDI data was 
entered via another method than Hackey Trackey, the default behaviour is to 
map the notes to non-overlapping channels. Once this is done, the channels for 
the MIDI data are remapped such that the column in which a note appears can be 
maintained. Note that if your instruments use the MIDI channel information for 
specific purposes then this plugin is not useful to you.

If your plugins simply need their MIDI data to arrive at a specific channel, then 
you can always remap the MIDI channel by forcing a specific MIDI output channel.

# Issues
There are some things which are unfortunately not possible as far as I am aware.
Voice stealing between different tracked patterns is one of them. Since the 
different tracker instances are unaware of each-other's existence, overlapping 
MIDI elements act independently.

There is a second annoyance that comes with this, which is that for notes to be 
held over a pattern, they must be restarted at the start of the new pattern. The 
tracker has no way of seeing what stuff may still be playing at the end of previous
MIDI items. It may be possible to find a workaround for this in the future by 
scanning the timeline for previous MIDI items and adding such notes automatically.