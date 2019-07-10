%% Identify and generate set of candidate atlas images
% --- Written by Manish Kumar Sharma, Mainak Jas -----

function ret = findCandidateAtlases(indices)
	% Read images to matrix
	X=[];
	x=[];

	imageIndices = transpose(find(indices));

	fprintf('\nReading Images');
	for i=imageIndices
		imRaw = imresize(imread(sprintf('../data/MIAS/images/mdb%03d.pgm',i)),0.5);
		if(isLeftMammogram(i))
			imRaw = fliplr(imRaw);
		end
		imRaw = single(imRaw);
		imDownSized = imresize(imRaw,[32, 32]);
		X = cat(1, X, imRaw(:)');
		x = cat(1, x, imDownSized(:)');
	end
	fprintf('\n[Reading Done]');

	% --- 2-D projection with t-SNE
	fprintf('\n\nStarting t-SNE visualization\n\n');
	ret.projections = tsne(x,[],2,25);

	% --- Fit GMM
	fprintf('\nFinding number of clusters ... \n');
	% Initialize Bayesian Information Criteria
	ret.bics = zeros(8,1);     % for k in 2:9
	
	for k=2:9
	    options = statset('Display','Final');
	    obj = gmdistribution.fit(ret.projections,k,'Options',options,'Regularize',0.1);
	    ret.bics(k-1) = obj.BIC;
	end

	% --- Find no. of clusters using BIC criteria
	[~, minBic] = min(ret.bics);
	ret.kStar = minBic+1;     % k is in range 2:9 while index is in range 1:8
	fprintf('\nk*=%d selected as optimal no of clusters using BIC criteria', ret.kStar);
	fprintf('\nk=%d selected for k-means clustering\n', ret.kStar);

	% --- k-Means clustering
	fprintf('\nStarting k-Means clustering\n');
	[ret.belongingCluster, clusterCentroids] = kmeans(X, ret.kStar, 'Display', 'Iter');

	% Finding candidate atlases
	ret.candidateAtlases = zeros(ret.kStar,1);  %Initialize
	fprintf('\nFinding atlases from each cluster ... ');
	for i=1:ret.kStar
	    candidateImages=X(ret.belongingCluster==i,:);
	    candidateImageIndices=imageIndices(ret.belongingCluster==i);
	    centralClusterImage = clusterCentroids(i,:);
	    ret.candidateAtlases(i)=findImageClosestToCentre(candidateImages,candidateImageIndices,centralClusterImage);
	end

	fprintf('\nSelected atlases...\n');
	fprintf('mdb%03d\n',ret.candidateAtlases);
	fprintf('\n\n[Done]\n\n');


	% Plots : Uncomment to look
	% figure(); plot(2:9, ret.bics);
	% figure(); scatter(ret.projections(:,1),ret.projections(:,2),5,ret.belongingCluster);
end

%% Function to find the image closest to cluster centre
function ind = findImageClosestToCentre(candidateImages,candidateImageIndices,centralClusterImage)
   distCentre=pdist2(candidateImages,centralClusterImage,'euclidean');  %Compute distances
   [~, i]=min(distCentre);
   ind=candidateImageIndices(i);
end