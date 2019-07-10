%% Evaluation using cross-validation

clear all;
close('all');
warning off;

%% Download images and ground truths
DownloadDataset('MIAS_IMAGES');

%% Generate Output folder for results
generateOutputDirectory;

%% Set up cross-validation
rng(0);
kfolds=5;
numSamples=322;
numGroups =2;
cv = CustomCvPartition(kfolds,numSamples,numGroups);

%% Data-driven atlas selection
atlasSelection;

%% Selected atlas segmentation
load ../Results/MIAS/cvAtlasSelectionResults.mat;
atlasSegmentation;

%% Image segmentation using demons algorithm
imageSegmentationDemons;

%% Compute evaluation metrics
evaluationMetrics;

%% Generate plots
generateProjectionPlots;
generateAtlasesPlot;
generateClusterFigure;