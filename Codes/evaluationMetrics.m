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
    groundTruth = imresize(imread(sprintf('../Data/MIAS/ground_truth/mdb%03d.bmp',itt)),0.5);
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
    HD(itt,1)=hausdorffUni(demXY,gtXY);
end

% Writing results
csvHeaders={'Demons'};
jiTable = array2table(JI, 'VariableNames', csvHeaders);
hdTable = array2table(HD, 'VariableNames', csvHeaders);
write(jiTable,'../Results/MIAS/jaccardIndex.csv');
write(hdTable,'../Results/MIAS/hausdorffDistance.csv');