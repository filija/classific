 
%Nacteni dat a odstraneni ticha
addpath('lib');
train=cell(1,31);
for ii=1:31
    train{ii}=wav16khz2mfcc_delete_silence(strcat('train/',num2str(ii)));
end



[test file] = wav16khz2mfcc_delete_silence('dev');


for ii=1:31
    train{ii}=cell2mat(train{ii});
end

%Konvoluce, vypocitame delta a double delta koeficienty

v=[-2,-1,0,1,2];
for ii=1:31
	for jj=1:13
		train{1,ii}(jj+13,:)=conv(train{1,ii}(jj,:),v,'same');
	end
end

for ii=1:numel(test)
	for jj=1:13
		test{1,ii}(jj+13,:)=conv(test{1,ii}(jj,:),v,'same');
	end
end


for ii=1:31
	for jj=14:26
		train{1,ii}(jj+13,:)=conv(train{1,ii}(jj,:),v,'same');
	end
end

for ii=1:numel(test)
	for jj=14:26
		test{1,ii}(jj+13,:)=conv(test{1,ii}(jj,:),v,'same');
	end
end






%Nastavime pocet gaussovek
M = 15

%Nahodne rozhodime gaussovky
MUs=cell(1,31);
for ii=1:31
	MUs{ii}  = train{ii}(:,random('unid', size(train{ii}, 2), 1, M));  
end

%Kovariancni matice 
COVs=cell(1,31);
for ii=1:31
	COVs{ii} = repmat(var((train{ii})', 1)', 1, M);
end

%Nastaveni pocatecni vahy
Ws = ones(1,M) / M;



%Natrenujeme GMM na 30 iteracich
for jj=1:31
	for ii=1:30
		[Ws, MUs{jj}, COVs{jj}, TTL] = train_gmm(train{jj}, Ws, MUs{jj}, COVs{jj});
		 disp(['Iteration: ' num2str(ii) ' for ' num2str(jj) ' Total log-likelihood: ' num2str(TTL)])
	end
end

%Spocitame score pro vsechny tridy
ll=cell(1,31);
for ii=1:numel(test)
	for jj=1:31
		ll{jj} = logpdf_gmm(test{ii}, Ws, MUs{jj}, COVs{jj});
		score{jj}(ii)=sum(ll{jj});
	end
end

%Zjistime nejvyssi pravdepodobnost tridy

f = fopen('result.txt', 'at');

right=0;
for ii=1:numel(test)
    final_class = 1;
	max_score=score{1}(ii);
	
	for jj=2:31
		if score{jj}(ii) > max_score
			max_score = score{jj}(ii);
			final_class = jj; 
		end	
	end
	if (final_class*2 == ii) | (final_class*2 - 1 == ii)
		right = right + 1;
	end	
	fprintf(f, '%s %s nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan\n', cell2mat(file(ii)), num2str(final_class));
	disp(['Final class for: ' cell2mat(file(ii)) ' is ' num2str(final_class)])
end

fclose(f);

success = right/numel(test)



