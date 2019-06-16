%% Generate output results directories
if(~exist('../Results','dir'))
    mkdir('../Results');
end
if(~exist('../Results/MIAS','dir'))
    mkdir('../Results/MIAS');
end

% Demons
if(~exist('../Results/MIAS/DemonsSegmentation','dir'))
    mkdir('../Results/MIAS/DemonsSegmentation');
end
if(~exist('../Results/MIAS/DemonsMasks','dir'))
    mkdir('../Results/MIAS/DemonsMasks');
end
if(~exist('../Results/MIAS/DemonsAtlas','dir'))
    mkdir('../Results/MIAS/DemonsAtlas');
end

% Plots
if(~exist('../Results/MIAS/Plots','dir'))
    mkdir('../Results/MIAS/Plots');
end