%% Compute edge coordiantes
function xy = getEdgeCoordinates(mask)
    % Downsize mask to reduce no of points
    mask = imresize(mask,0.5);
    
    maskEdge = edge(mask,'prewitt');
    [x, y]=find(maskEdge==1);
    xy=[x y];
end