function [features file_names sizes] = makeMoreImages(dir_name)

D=dir([dir_name '/*.png']);
file_names = {D.name};

for ii=1:length(file_names)
	delete([dir_name '/*_added2.png'], [dir_name '/*_added6.png'], [dir_name '/*_subs6.png'], [dir_name '/*_subs2.png'], [dir_name '/*_rotated7.png'], [dir_name '/*_rotated-7.png'], [dir_name '/*_rotated4.png'], [dir_name '/*_rotated-4.png']);
end;


D=dir([dir_name '/*.png']);
file_names = {D.name};

for ii=1:length(file_names)
  disp(['Processing file: ' dir_name '/' file_names{ii}])
  s = imread([dir_name '/' file_names{ii}]);
  %s = double(rgb2gray(s));
 
  added2 = s + 2;
  imwrite(added2, [ dir_name '/' file_names{ii} '_added2.png']); %ulozeni
  added6 = s + 6;
  imwrite(added6, [ dir_name '/' file_names{ii} '_added6.png']); %ulozeni
  subst2 = s - 2;
  imwrite(subst2, [ dir_name '/' file_names{ii} '_subs2.png']); %ulozeni
  subst6 = s - 6;
  imwrite(subst6, [ dir_name '/' file_names{ii} '_subs6.png']); %ulozeni 

  rotated4 = imrotate(s, 4); %rotace
  rotatedmin4 = imrotate(s, -4);
  
  rotated4 = rotated4(4:83,4:83, : ); %orezani
  rotatedmin4 = rotatedmin4(4:83,4:83, : );

  imwrite(rotated4, [ dir_name '/' file_names{ii} '_rotated4.png']); %ulozeni 
  imwrite(rotatedmin4, [ dir_name '/' file_names{ii} '_rotated-4.png']);

  rotated7 = imrotate(s, 7);
  rotatedmin7 = imrotate(s, -7);

  rotated7 = rotated7(7:86,7:86, : );
  rotatedmin7 = rotatedmin7(7:86,7:86, : );

  imwrite(rotated7, [ dir_name '/' file_names{ii} '_rotated7.png']);
  imwrite(rotatedmin7, [ dir_name '/' file_names{ii} '_rotated-7.png']);
  
  sizes{ii}    = size(s);
end
