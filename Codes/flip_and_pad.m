%% Function to flip images and remove padding
% J: image
% idx: Image index
% M: Image mask
function [I,M] = flip_and_pad(J,idx,M)
    if (mod(idx,2)==0)
        J = fliplr(J);
        if(exist('M','var'))
            M=fliplr(M);
        end
    end
    
    if(exist('M','var'))
        [I,M] = remove_padding(J,M);
    else
        I = remove_padding(J);
        M = 0;  % Dummy value, not used
    end
end