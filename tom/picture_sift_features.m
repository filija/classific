
addpath('lib');
run('vlfeat-0.9.20/toolbox/vl_setup');

%Nacteni a rozmnozeni obrazku
train=cell(1,31);
for ii=1:31
    makeMoreImages(strcat('train/',num2str(ii)));
    train{ii}=sift_read_img(strcat('train/',num2str(ii)));
end

[test_set file]=sift_read_img('eval');

label_test = zeros(1,size(test_set,2));

for ii=1:31
	label_test(1,((ii-1)*2)+1:ii*2)=ii;
end

descriptors=cell(31,54);
frames=cell(31,54);

%Ziskani sift priznaku
for ii=1:31
	for jj=1:54
		[frames{ii,jj},descriptors{ii,jj}]=vl_sift(train{1,ii}{1,jj});
	end
end

f = fopen('result.txt', 'at');
scores=cell(31,54);
right=0;
index = 0;
for ii=1:numel(test_set)
    scores_size=zeros(31,54);
	[tmp_frames, tmp_descriptors]=vl_sift(test_set{1,ii});
	for jj=1:31
		for kk=1:54
			%Zjisteni shody sift priznaku
			[matches, scores{jj,kk}]=vl_ubcmatch(tmp_descriptors, descriptors{jj,kk});
			scores_size(jj,kk) = length(scores{jj,kk});
		end
	end
	
	%Tridu pridelime podle toho jaka trida ma nejvetsi pocet matchu v sift priznacich 
	sum_scores = sum(scores_size,2);
	mat_max = max(cellfun('size', scores, 2),[],2);
	sum_scores = mat_max + sum_scores;
	[size, index] = max(sum_scores);
	
	
	if (index*2 == ii) | (index*2 - 1 == ii)
		right = right + 1;
	end

	fprintf(f, '%s %s nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan\n', cell2mat(file(ii)), num2str(index));
	disp(['Final class for: ' cell2mat(file(ii)) ' is ' num2str(index)])
	
	
end

fclose(f);
success = right/numel(test_set)












