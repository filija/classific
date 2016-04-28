function [features file_names] = wav16khz2mfcc(dir_name)

D=dir([dir_name '/*.wav']);
file_names = {D.name};
for ii=1:length(file_names)
  disp(['Processing file: ' dir_name '/' file_names{ii}])
  [s Fs] = wavread([dir_name '/' file_names{ii}]);
  s = s(2*Fs:end);
  frame_duration = 0.1;
  frame_len = frame_duration*Fs;
  N = length(s);
  num_frames = floor(N/frame_len);
  new_sig = zeros(N,1);
  count = 0;

  for jj=1:num_frames
	frame=s((jj-1)*frame_len + 1 : frame_len*jj);
	
	max_val = max(frame);
	
	if (max_val > 0.01)
		count = count + 1;
		new_sig((count-1)*frame_len + 1 : frame_len*count) = frame;
	end
  end	
  new_sig(count*frame_len:end)=[];
  s = new_sig;
  
  features{ii} = mfcc(s, 400, 240, 512, 16000, 23, 13);
end
