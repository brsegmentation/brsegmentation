%% Function to remove padding from MIAS images
%
% --------------Mainak Jas, IIT Kharagpur----------------------------------
% J: Image
% M: Image Mask
function [I,M] = remove_padding(J, M)
    if ~isa(J, 'uint8')
        error('cluster_segment:flip_and_pad:typeError', ...
              'To remove padding, image must be of type uint8');
    end

    if size(J, 1) ~= 512 || size(J, 2) ~= 512
        error('cluster_segment:flip_and_pad:valueError', ...
              'Size of image must be 512 x 512');
    end

    I = fliplr(J);
    if(exist('M','var'))
        M=fliplr(M);
    end
        
    th = 5000; % threshold

    sumI = sum(I);
    diffI = sumI(2:end) - sumI(1:end-1);

    padding = find(diffI > th, 1, 'first');
    I(:, 1:end-padding) = I(:, padding+1:end);
    I = fliplr(I);
    
    if(exist('M','var'))
        M(:, 1:end-padding) = M(:, padding+1:end);
        M = fliplr(M);
    end
end
