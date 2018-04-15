function cranker_setup()
% set up the cranker distribution.
% this function is to be called any time C-Raner is stalled on a new
% machine to ensure that the paths are set properly.

% add paths to Matlab serching path
currPath = fileparts(mfilename('fullpath')); % current path
subpaths = {'','interface','lib_m'};
for ii=1:length(subpaths)
    path_str = subpaths{ii};
    addpath([currPath filesep path_str]);
end
savepath; % save the current path

% compile the C-Ranker mex files
flag_fullRecompile = 0; 
    % whether compile all the c files  regardless the existing mex files
curr_folder = pwd; % current folder of the user

cd([currPath filesep 'lib']);
cfiles = dir('*.c');
cfiles = {cfiles.name};
has_mex = 1;
if ~flag_fullRecompile
    for k=1:length(cfiles)
       fileName = cfiles{k};
       if exist(fileName(1:end-2),'file') ~= 3
           has_mex = 0;
           break;
       end
    end
end

str_split = '------------------------------------------------';
flag_success = 1;
if flag_fullRecompile || ~has_mex
    disp('Attempting to produce the C-Ranker mex files...');
    disp(str_split);    
    for k=1:length(cfiles)
        fileName = cfiles{k};
        try
            cmd_str = sprintf('%s ','mex',fileName);
            fprintf(1,'%s\n',cmd_str);
            mex(fileName);
        catch
            flag_success = 0;
        end
    end
    if flag_success
        disp(str_split);
    else
        disp('Error: One or more C-Ranker''s required Mex files could not be produced.');
        disp('This is usually because your Mex system has not been properly set up.');
        disp('Please consult the Matlab documentation for details on how to do this.');
    end
end
cd(curr_folder);
if flag_success
    fprintf('Succeed to set up C-Ranker.\n');
end
end