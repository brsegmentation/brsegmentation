%% Check if left breast mammogram in MIAS dataset
% Even numbered images are of left breast
function bool=isLeftMammogram(i)
	bool = mod(i,2)==0;
end