# Hackey-Trackey

A lightweight LUA tracker plugin for REAPER. Hackey-Trackey is a small tracker 
for visualizing and editing MIDI data within REAPER.

Hackey trackey maps the M?IDI data to a tracked format. If the MIDI data was 
entered via another method than Hackey Trackey, the default behaviour is to 
map the notes to non-overlapping channels. Once this is done, the channels for 
the MIDI data are remapped such that the column in which a note appears can be 
maintained. Note that if your instruments use the MIDI channel information for 
specific purposes then this plugin is not useful to you.

If your plugins simply need their MIDI data to arrive at a specific channel, then 
you can always remap the MIDI channel by forcing a specific MIDI output channel.