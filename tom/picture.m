addpath('lib');

train_t=cell2mat(png2fea('target_train'));
train_n=cell2mat(png2fea('non_target_train'));
test_t=cell2mat(png2fea('target_dev'));
test_n=cell2mat(png2fea('non_target_dev'));


mat_t=[train_t train_n];
T=[ones(1, size(train_t, 2)) zeros(1, size(train_n, 2))];

