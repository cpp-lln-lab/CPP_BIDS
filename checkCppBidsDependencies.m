function checkCppBidsDependencies

    pth = fileparts(mfilename('fullpath'));
    addpath(fullfile(pth, 'lib', 'JSONio'));
    addpath(fullfile(pth, 'lib', 'bids-matlab'));
    addpath(fullfile(pth, 'lib', 'utils'));
    addpath(fullfile(pth, 'subfun'));
    
    printCredits()

end
