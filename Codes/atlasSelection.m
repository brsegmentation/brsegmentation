%% Data-driven atlas selection

fprintf('\n\nFinding candidate atlas images\n\n');

% k-fold cross-validation
for fold_idx=1:cv.NumTestSets
    fprintf('\nCross validation fold %d ... \n', fold_idx);
    train_mask = cv.training(fold_idx);
    ret(fold_idx)=findCandidateAtlases(train_mask);
end

save('../Results/MIAS/cvAtlasSelectionResults.mat','ret');