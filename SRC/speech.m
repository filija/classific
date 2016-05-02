addpath('lib');

% load audio files
target_train=wav16khz2mfcc_clean('target_train');
non_train=wav16khz2mfcc_clean('non_target_train'); 
[target_test file1]=wav16khz2mfcc_clean('target_dev');
[non_test file2]=wav16khz2mfcc_clean('eval');

% merge training matrices
target_train=cell2mat(target_train);
non_train=cell2mat(non_train);

% number of Gauss distibutions
M = 64;

% init for target
MUs=target_train(:, random('unid', size(target_train, 2), 1, M));
COVs = repmat(var((target_train)', 1)', 1, M);
Ws = ones(1,M) / M;

% init for non_target
MUs_n=non_train(:, random('unid', size(non_train, 2), 1, M));
COVs_n = repmat(var((non_train)', 1)', 1, M);
Ws_n = ones(1,M) / M;


% GMM training, EM algorithm
for jj=1:10
	[Ws, MUs, COVs, TTL_t] = train_gmm(target_train, Ws, MUs, COVs);
	[Ws_n, MUs_n, COVs_n, TTL_n] = train_gmm(non_train, Ws_n, MUs_n, COVs_n);
	disp(['Iteration targetf: ' num2str(jj) ' for ' num2str(jj) ' Total log-likelihood: ' num2str(TTL_t)])
	disp(['Iteration non_target: ' num2str(jj) ' for ' num2str(jj) ' Total log-likelihood: ' num2str(TTL_n)])
end

% a priori probability
p_t = 0.5;
p_n = 1 - p_t;

% sums likelihood over all voices
for ii=1:length(target_test)
	ll_t = logpdf_gmm(target_test{ii}, Ws, MUs, COVs);
	ll_n = logpdf_gmm(target_test{ii}, Ws_n, MUs_n, COVs_n);
	score_t(ii)=sum(ll_t + log(p_t)) - sum(ll_n + log(p_n));
end

for ii=1:length(non_test)
	ll_t = logpdf_gmm(non_test{ii}, Ws, MUs, COVs);
	ll_n = logpdf_gmm(non_test{ii}, Ws_n, MUs_n, COVs_n);
	score_n(ii)=sum(ll_t + log(p_t)) - sum(ll_n + log(p_n));
end

sum_target=sum(score_t>1)/length(score_t)
sum_non=sum(score_n<0)/length(score_n)

% output
f=fopen('result_audio.txt', 'w');

	for ii=1:length(target_test)
		[pathstr, name, ext]=fileparts(file1{ii});
		tmpScore = score_t(ii)/1000;
		% fprintf(f, '%s %0.4f %d\n', name, tmpScore, tmpScore > 0);
	end

	for ii=1:length(non_test)
		[pathstr, name, ext]=fileparts(file2{ii});
		tmpScore = score_n(ii)/1000;
		fprintf(f, '%s %0.4f %d\n', name, tmpScore, tmpScore > 0);
	end

fclose(f);