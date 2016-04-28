function [image file_names] = sift_read_img(dir_name)

D=dir([dir_name '/*.png']);
file_names = {D.name};
for ii=1:length(file_names)
  disp(['Processing file: ' dir_name '/' file_names{ii}])
  s = imread([dir_name '/' file_names{ii}]);
  image{ii} = single(rgb2gray(s));
end
