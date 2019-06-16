%% Segment a image with set of atlas images

function val = segmentImage(itt, atlasImageMatrix)

    % --- [1] Read images --- %
    fprintf('\n\nSegmenting image mdb%03d.pgm ... \n', itt);
    groundTruth = imresize(imread(sprintf('../data/MIAS/ground_truth/mdb%03d.bmp',itt)),0.5);
    Istatic = imresize(imread(sprintf('../data/MIAS/images/mdb%03d.pgm',itt)),0.5);
    Istatic = im2single(flip_and_pad(Istatic, itt));
    
    % Find best matching atlas image
    distAtlas = pdist2(atlasImageMatrix,Istatic(:)','euclidean');
    [~, minIdx]=min(distAtlas);
    Imoving = reshape(atlasImageMatrix(minIdx,:)',[512 512]);
    
    
    % --- [2] Preprocessing --- %
    % Contrast correction
    Istat = double(Istatic);
    Istat = Istat - min(Istat(:)); 
    Istat = Istat/max(Istat(:));
    
    Imov = double(Imoving);
    Imov = Imov - min(Imov(:)); 
    Imov = im2double(Imov/max(Imov(:)));

    % Cleaning 'salt' noise
    Istat = im2double(imopen(Istat,strel('disk',3)));
    IregRigidm = Imov;
    
    % --- [3] Set Parameters for registration --- %
    alpha = 1;
    sigma = 30; % for smoothing    
    
    % --- [4] Demon's Registration --- %
    [Ireg,val] = demons(Istat,IregRigidm,800,sigma,alpha,4);
    
    % --- [5] Morphological Cleaning and Upsampling--- %
    Ibwreg = imfill(imopen(im2bw(Ireg, 0.05), strel('disk', 10)), 'holes');
    
    % --- [6] Post-processing : Recover breast region lost around edges
    tempImage=ones(size(Ibwreg)+[2 1]);
    tempImage(2:end-1,1:end-1)=Ibwreg;     %Adding row of ones to top, bottom and right for creating holes
    tempImage=logical(tempImage);
    tempImage=imfill(tempImage,'holes');      % Filling holes
    Ibwreg=tempImage(2:end-1,1:end-1);     % Removing the added rows back
    
    
    % --- [7] Marking image borders ---
    Iresult = markImageBorders(Istatic,Ibwreg,groundTruth);
    
    % --- [8] Writing output to file ---
    imwrite(Ibwreg,sprintf('../Results/MIAS/DemonsMasks/mask%03d.bmp',itt));
    imwrite(Iresult,sprintf('../Results/MIAS/DemonsSegmentation/seg%03d.jpeg',itt));   
end