function checkCppBidsDependencies(cfg)
    % checkCppBidsDependencies()
    %

    pth = fileparts(mfilename('fullpath'));

    checkSubmodule(fullfile(pth, 'lib', 'JSONio'));
    checkSubmodule(fullfile(pth, 'lib', 'bids-matlab'));

    addpath(fullfile(pth, 'lib', 'utils'));
    addpath(fullfile(pth, 'subfun'));

    printCreditsCppBids(cfg);

end

function checkSubmodule(pth)
    % If external dir is empty throw an exception
    % and ask user to update submodules.
    if numel(dir(pth)) <= 2 % Means that the external is empty
        error(['Git submodules are not cloned!', ...
              'Try this in your terminal:', ...
              ' git submodule update --recursive ']);
    else
        addpath(pth);
    end
end
