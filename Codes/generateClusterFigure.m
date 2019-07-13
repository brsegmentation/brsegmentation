%% Generate plot for cluster images
load ../Results/MIAS/cvAtlasSelectionResults.mat;

fold = 1:kfolds;
for fold_idx= fold
    images = find(cv.training(fold_idx));
    figure('Position', [50, 10, 500, 1000]);
    set(gcf,'Color','W');
    axes= gca;

    for i=1:ret(fold_idx).kStar
        numVert = ret(fold_idx).kStar;
        numHorz = 3;
        imIdx = images(ret(fold_idx).belongingCluster == i);
        for j=1:numHorz
            positionArray = [0.1 + (j-1)*0.8/numHorz (numVert-i)*1/numVert+0.05 0.8/numHorz 1/numVert-0.01];
            h=subplot(numVert,numHorz,(i-1)*3 + j,'Position', positionArray);
            im=imresize(imread(sprintf('../data/MIAS/images/mdb%03d.pgm',imIdx(j))),0.5);
            im=flip_and_pad(im,imIdx(j));
            imshow(im);
            if(j==1)
                y=ylabel(h,sprintf('Cluster-%d',i),'FontSize',13);
                set(y, 'Units', 'Normalized', 'Position', [-0.1, 0.4, 0]);
            end
        end
    end
    
    print(sprintf('../Results/MIAS/Plots/cluster%d.pdf',fold_idx), '-dpdf');
    print(sprintf('../Results/MIAS/Plots/cluster%d.jpg',fold_idx), '-djpeg');

%     Install and use export_fig for better rendering
%     export_fig(sprintf('../Results/MIAS/Plots/cluster%d.pdf',fold_idx));
%     export_fig(sprintf('../Results/MIAS/Plots/cluster%d.jpg',fold_idx));
end