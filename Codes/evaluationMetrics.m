%% Compute evaluation metrics
% Metrics used:
% 1. Jaccard Index
% 2. Unidirectional Hausdorff distance

% Initializing evaluation metrics
JI=zeros(322,1);
HD=zeros(322,1);
fprintf('\n\nComputing evaluation metrics\n\n');

for itt=1:322
    fprintf('Image:mdb%03d\n',itt);
    % Read masks
    groundTruth = imresize(imread(sprintf('../data/MIAS/ground_truth/mdb%03d.bmp',itt)),0.5);
    dem = imread(sprintf('../Results/MIAS/DemonsMasks/mask%03d.bmp',itt));
    
    % Convert to logical
    groundTruth = logical(groundTruth);
    dem = logical(dem);
    
    % Compute Jaccard Index
    JI(itt,1) =  jaccardIndex(groundTruth,dem);
    
    % Compute edge coordinates
    gtXY = getEdgeCoordinates(groundTruth);
    demXY = getEdgeCoordinates(dem);
    
    % Compute Hausdorff distance
    % Multiply by 0.2 for 200 micron pixel edge of MIAS images
    % Multiple by 2 for compensation factor of downsampling
    % Final Hausdorff distance reported in mm
    HD(itt,1)=hausdorffUni(demXY,gtXY)*0.2*2;
end

% Writing results
csvHeaders={'Demons'};
jiTable = array2table(JI, 'VariableNames', csvHeaders);
hdTable = array2table(HD, 'VariableNames', csvHeaders);
write(jiTable,'../Results/MIAS/jaccardIndex.csv');
write(hdTable,'../Results/MIAS/hausdorffDistance.csv');