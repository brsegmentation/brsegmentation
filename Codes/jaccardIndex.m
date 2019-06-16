%% Compute Jaccard coefficient of two images

function [jaccardIdx,jaccardDist] = jaccardIndex(img_Orig,img_Seg)
    % Check for logical image
    if ~islogical(img_Orig)
        error('Image must be in logical format');
    end
    if ~islogical(img_Seg)
        error('Image must be in logical format');
    end

    % Find the intersection of the two images
    inter_image = img_Orig & img_Seg;

    % Find the union of the two images
    union_image = img_Orig | img_Seg;

    jaccardIdx = sum(inter_image(:))/sum(union_image(:));
    jaccardDist = 1 - jaccardIdx;
end
