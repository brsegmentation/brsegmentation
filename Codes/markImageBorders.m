%% Mark image borders given image, segmentation mask and ground truth mask
function Iresult = markImageBorders(im, mask, gt)
    % Define structuring element to thicken edge
    se = strel('disk',3);
    
    % Define R, G and B images
    Iredborder = im; Iblueborder = im; Igreenborder = im;
    
    % Mark red border showing segmented region
    Ir = imdilate(edge(mask,'prewitt'),se); 
    loc = find(Ir==1); 
    Iredborder(loc) = 255; Igreenborder(loc) = 0; Iblueborder(loc) = 0;

    % Mark blue border showing ground truth segmentation
    Ir = imdilate(edge(im2bw(gt),'prewitt'),se); 
    loc = find(Ir==1); 
    Iredborder(loc) = 0; Igreenborder(loc) = 0; Iblueborder(loc) = 255;

    Iresult = cat(3,Iredborder,Igreenborder,Iblueborder);
end