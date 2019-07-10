%% Fucntion to download mini-MIAS dataset
function DownloadDataset(dataset)
    % Download original images
    if strcmpi(dataset, 'MIAS_IMAGES')
        if ~exist('../data/MIAS/images', 'dir')
            fprintf('\nDownloading and untaring MIAS dataset (106 MB). This may take a while ... ');
            untar('http://peipa.essex.ac.uk/pix/mias/all-mias.tar.gz', ...
                  '../data/MIAS/images');
            fprintf('[Done]');
        end
    end
end