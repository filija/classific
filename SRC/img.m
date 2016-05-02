addpath('lib');

% vlfeat library
run vlfeat-0.9.20/toolbox/vl_setup;

% experimental constant 
treshold = 7000000

% load images
target_train=read_img('target_train');
non_train=read_img('non_target_train');
% [target_test file1]=read_img('target_dev');
[non_test file2]=read_img('eval');
     
% load frames from training images        
for ii=1:length(target_train) 
	[frames{ii}, descriptors{ii}]=vl_sift(target_train{ii});
end
                        
for ii=1:length(non_train) 
	[n_frames{ii}, n_descriptors{ii}]=vl_sift(non_train{ii});
end

% rewrite output file
f = fopen('../result_image.txt', 'w');

test_set = non_test;

% loop over all test images
for ii=1:numel(test_set)
values_sum = 0;
	
	% load frames from current image
	[tmp_frames, tmp_descriptors]=vl_sift(test_set{ii});

	% compare current image against trained images
	for jj=1:numel(target_train)
		[matches, scores{jj}]=vl_ubcmatch(tmp_descriptors, descriptors{jj});
		scores_size(jj) = length(scores{jj});
    end
	
    % sum calculating
	for kk=1:length(target_train)
    	for ll=1:length(scores{kk})
    		values_sum=values_sum+scores{kk}(ll);
    	end
    end
	
	% output
	[pathstr, name, ext]=fileparts(file2{ii});
	fprintf(f, '%s %0.4f %d\n', name, values_sum/100000 - treshold/100000, values_sum > treshold);
end

fclose(f);
