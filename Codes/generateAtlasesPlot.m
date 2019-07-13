%% Generate plot for selected atlases
load ../Results/MIAS/cvAtlasSelectionResults.mat;

for fold_idx= 1:kfolds
    numFoldAtlases = ret(fold_idx).kStar;
    figure('Position', [50, 300, 1000, 250]);
    set(gcf,'Color','W');
    for i=1:numFoldAtlases
        h=subplot(1,numFoldAtlases,i);
        set(h,'Position',[(i-1)*0.9/numFoldAtlases, 0, 0.9/numFoldAtlases, 1]);
        im = imread(sprintf('../Results/MIAS/DemonsAtlas/fold%d_atlas%03d.bmp',fold_idx,ret(fold_idx).candidateAtlases(i)));
        imshow(im);
    end

    print(sprintf('../Results/MIAS/Plots/atlasesFold%d.pdf',fold_idx),'-dpdf');
    print(sprintf('../Results/MIAS/Plots/atlasesFold%d.jpg',fold_idx),'-djpeg');
    
%     Install and use export_fig for better rendering
%     export_fig(sprintf('../Results/MIAS/Plots/atlasesFold%d.pdf',fold_idx));
%     export_fig(sprintf('../Results/MIAS/Plots/atlasesFold%d.jpg',fold_idx));
end