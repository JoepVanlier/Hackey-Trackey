--[[
@noindex
]]--

SAMPLE_HEADER = 64;
SAMPLE_SIZE = 32768 * 16;
nSamples = 0;

function transfer_take(gmem_start, ix)
  local mediaItem = reaper.GetSelectedMediaItem(0, ix);
  local gmem_ptr = gmem_start
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
        local name = reaper.GetMediaSourceFileName(src, "")
        
        srate = 48000;
        
        if nChannels > 2 then
          reaper.ShowConsoleMsg("More than stereo is not supported")
          return 0
        end
        
        local len = math.min(math.ceil((stop - start) * srate), SAMPLE_SIZE)
        local remaining = len
        local blockSize = 4096
        
        local samplebuffer = reaper.new_array(blockSize * nChannels)
        gmem_ptr = gmem_ptr + SAMPLE_HEADER
        for idx=0,math.floor(len/blockSize) do
          reaper.GetAudioAccessorSamples(accessor, srate, nChannels, start + idx * blockSize / srate, blockSize, samplebuffer)
          
          if nChannels == 1 then
            for cp=1,math.min(remaining, blockSize) do
              reaper.gmem_write(gmem_ptr, samplebuffer[cp])
              gmem_ptr = gmem_ptr + 1
              reaper.gmem_write(gmem_ptr, samplebuffer[cp])
              gmem_ptr = gmem_ptr + 1
            end
          elseif nChannels == 2 then
            for cp=1,math.min(remaining, blockSize) * nChannels do
              reaper.gmem_write(gmem_ptr, samplebuffer[cp]);
              gmem_ptr = gmem_ptr + 1
            end
          end
          
          remaining = remaining - blockSize;
        end
        reaper.gmem_write(gmem_start, len * 2);
        reaper.gmem_write(gmem_start + 1, srate);
        
        reaper.gmem_write(gmem_ptr, 1337)
        nSamples = nSamples + 1;
        gmem_ptr = gmem_ptr + 1
        
        name = name:match("[\\/]([^\\/]+)%.(%w+)$")
        for char in name:gmatch('.') do
          reaper.gmem_write(gmem_ptr, string.byte(char))
          gmem_ptr = gmem_ptr + 1
        end
        reaper.gmem_write(gmem_ptr, 0)
      end
    end
  end
  
  return gmem_ptr + 1
end


reaper.gmem_attach('saike_HT_sample')
local gmem_start = 2
for ix = 0, reaper.CountSelectedMediaItems(0) - 1 do
  gmem_start = transfer_take(gmem_start, ix)
end
reaper.gmem_write(0, 72453);
reaper.gmem_write(1, nSamples);

