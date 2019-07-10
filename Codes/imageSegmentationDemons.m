%% Generate Image segmentation using Demons Deformable Registration

% Add paths -- http://www.mathworks.com/matlabcentral/fileexchange/21451
addpath(genpath('../Externals/demon_registration_version_8f/'));

fprintf('\n\nSegmenting images with Demons Deformable Registration\n\n');

% Initialize performance parameters
timeTaken = zeros(322,6);
corrValues = zeros(322, 800);
for fold_idx=1:cv.NumTestSets
    fprintf('\nCross validation fold %d ... \n', fold_idx);
    test_mask = cv.test(fold_idx);
    
    atlasImageMatrix = zeros(ret(fold_idx).kStar, 512*512, 'single');
    for i=1:ret(fold_idx).kStar
        atlas = imread(sprintf('../Results/MIAS/DemonsAtlas/fold%d_atlas%03d.bmp',fold_idx,ret(fold_idx).candidateAtlases(i)));
        atlasImageMatrix(i,:) = im2single(atlas(:));
    end
    
    for itt=find(test_mask)'
        val=segmentImage(itt,atlasImageMatrix);
        timeTaken(itt,:) = val.time;
        corrValues(itt,:) = val.crr;
    end
end

rmpath(genpath('../Externals/demon_registration_version_8f/'))

% Writing results
save('../Results/MIAS/correlationValues.mat','corrValues');

csvHeaders={'Iterations', 'Total', 'DisplacementVector','GaussianSmoothing', 'StoppingCriteria','Interpolaton'};
csvTable = array2table(timeTaken, 'VariableNames', csvHeaders);
write(csvTable,'../Results/MIAS/timeTakenDemons.csv');

