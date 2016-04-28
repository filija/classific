
addpath('lib');
%Nahrani obrazku + namnozeni (rotace, priblizeni)
train=cell(1,31);
for ii=1:31
    makeMoreImages(strcat('train/',num2str(ii)));
    train{ii}=png2fea(strcat('train/',num2str(ii)));
end

[test_set file]=png2fea('eval');
test_set=cell2mat(test_set);

for ii=1:31
    train{ii}=cell2mat(train{ii});
end

%Within class kovariancni matice
cov_wc = zeros(6400,6400);
for ii=1:31
	cov_wc = cov_wc + cov((train{ii})',1);
end
cov_wc = cov_wc/31;

%Across class kovariencni matice
ac_mean=0;
for ii=1:31
	ac_mean = ac_mean + mean2(train{ii});
end
ac_mean = ac_mean/31;

cov_ac = zeros(6400,6400);
ac_ones = ones(54,54);
for ii=1:31
	tmp_ac = (ac_ones*(train{ii})')/54 - ac_mean;
	cov_ac = cov_ac + (tmp_ac'*tmp_ac)/54;
end
cov_ac = cov_ac/31;

clearvars ac_ones;
clearvars tmp_ac;

%Finalni kovariencni matice
final_cov = cov_ac*cov_wc';

clearvars cov_ac;
clearvars cov_wc;

train=cell2mat(train);
label = zeros(1,size(train,2));

for ii=1:31
	label(1,((ii-1)*54)+1:ii*54)=ii;
end


orig_train = train;
orig_train_set = test_set;

train = orig_train;
test_set = orig_train_set;

%Vypocet vlastnich vektoru
COVm = cov(orig_train',1);
[e,d] = eigs(final_cov, 25);

%Redukce dimenzionality
train = e' * train;
test_set = e' * test_set;

f = fopen('result.txt', 'at');

right = 0;
for zz=1:size(test_set, 2)
	difference=zeros(1,31*54);
	for ii=1:31*54
		%Vypocet euklidovske vzdalenosti
		difference(ii)=norm(train(:,ii)-test_set(:,zz));
	end
    
	%K nejblizsich, nastaveno na nejblizssi
	[k_n k_i] = sort(difference);
	k_i = k_i(1,1:1);
	for kk=1:1
		k_i(1,kk) = label(1,k_i(1,kk));
	end
	index = mode(k_i);
	
	if (index*2 == zz) | (index*2 - 1 == zz)
		right = right + 1;
	end	
	
	fprintf(f, '%s %s nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan\n', cell2mat(file(zz)), num2str(index));
	disp(['Final class for: ' cell2mat(file(zz)) ' is ' num2str(index)])
end	

fclose(f);
success = right/size(test_set, 2)








