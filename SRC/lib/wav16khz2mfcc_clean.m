function [features file_names] = wav16khz2mfcc_clean(dir_name)

D=dir([dir_name '/*.wav']);
file_names = {D.name};
for ii=1:length(file_names)
  disp(['Processing file: ' dir_name '/' file_names{ii}])
  [s fs] = audioread([dir_name '/' file_names{ii}]);
  s = s(2*fs:end);
  frame_duration = 0.1;
  frame_len = fs*frame_duration;
  N = length(s);
  num_frames = floor(N/frame_len);
  new_signal = zeros(N,1);
  count = 0;

  for jj=1:num_frames
    frame=s((jj-1)*frame_len + 1 : frame_len*jj);
    max_val = max(frame);
    if (max_val > 0.01)
      count = count + 1;
      new_signal((count-1)*frame_len + 1 : frame_len*count) = frame;
    end
  end

  new_signal(count*frame_len:end)=[];
  s = new_signal;
  features{ii} = mfcc(s, 400, 240, 512, 16000, 23, 13);
end
