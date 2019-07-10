%% Segment selected atlases

fprintf('\n\nSegmenting candidate atlas images\n\n');

% k-fold cross-validation
for fold_idx=1:cv.NumTestSets
    for i=transpose(ret(fold_idx).candidateAtlases);
        atlasMask = imresize(imread(sprintf('../data/MIAS/ground_truth/mdb%03d.bmp', i)), [512 512]);
        atlas = imresize(imread(sprintf('../data/MIAS/images/mdb%03d.pgm', i)), [512 512]);

        atlas=flip_and_pad(atlas, i);
        atlas(atlasMask == 0) = 0;
        imwrite(atlas, sprintf('../Results/MIAS/DemonsAtlas/fold%d_atlas%03d.bmp',fold_idx,i));
    end
end