--[[
@noindex
]]--

SAMPLE_HEADER = 64;

function transfer_take()
  local mediaItem = reaper.GetSelectedMediaItem(0, 0);
  if reaper.ValidatePtr(mediaItem, "MediaItem*") then
    local take = reaper.GetActiveTake(mediaItem)
    if reaper.ValidatePtr(take, "MediaItem_Take*") then
      if not reaper.TakeIsMIDI(take) then
        local accessor = reaper.CreateTakeAudioAccessor(take)
        local start = reaper.GetAudioAccessorStartTime(accessor)
        local stop = reaper.GetAudioAccessorEndTime(accessor)
  
        local src = reaper.GetMediaItemTake_Source(take)
        local srate = reaper.GetMediaSourceSampleRate(src)
        local nChannels = reaper.GetMediaSourceNumChannels(src);
        
        srate = 48000;
        
        if nChannels > 2 then
          reaper.ShowConsoleMsg("More than stereo is not supported")
          return 0
        end
        
        local len = (stop - start) * srate
        local blockSize = 4096
        
        reaper.gmem_attach('saike_HT_sample')
        
        local samplebuffer = reaper.new_array(blockSize * nChannels)
        local gmem_ptr = SAMPLE_HEADER
        for idx=0, math.ceil(len/blockSize) do
          reaper.GetAudioAccessorSamples(accessor, srate, nChannels, start + idx * blockSize / srate, blockSize, samplebuffer)
          
          if nChannels == 1 then
            for cp=1,blockSize do
              reaper.gmem_write(gmem_ptr, samplebuffer[cp])
              gmem_ptr = gmem_ptr + 1;
              reaper.gmem_write(gmem_ptr, samplebuffer[cp])
              gmem_ptr = gmem_ptr + 1;
            end
          elseif nChannels == 2 then
            for cp=1,blockSize * nChannels do
              reaper.gmem_write(gmem_ptr, samplebuffer[cp])
              gmem_ptr = gmem_ptr + 1;
            end
          end
        end
        
        reaper.gmem_write(0, len * 2);
        reaper.gmem_write(1, srate);
      end
    end
  end
end

transfer_take()
