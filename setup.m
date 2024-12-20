function base_folder = setup()
    % Add current directory and sample_data, layers and exmamples to path
    base_folder = fileparts(mfilename('fullpath'));
    addpath(base_folder);
    addpath(fullfile(base_folder, "network_layers"))
    addpath(fullfile(base_folder, "Functions"))
end