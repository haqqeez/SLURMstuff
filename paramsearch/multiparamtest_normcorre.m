function multiparamtest_normcorre(p, spatial_downsampling, gSiz, gSig, gridness, overlap, boundary, upsampling, maxshift, bin_width, iterations, testfilename, vidname)  

%%%%% This part is just for setting up parallel clusters on DRAC and adding
%%%%% the relevant paths to MATLAB before running the actual script below.
%%%%% Remove or comment out if not running on a cluster

numcores = feature('numcores')

% Create a "local" cluster object
local_cluster = parcluster('local')

% Modify the JobStorageLocation to $SLURM_TMPDIR
local_cluster.JobStorageLocation = getenv('SLURM_TMPDIR')

% Start the parallel pool
parpool(local_cluster,numcores);

analysis_path = pwd; %put in path to folder in question here (or make copy of this file within the folder you want to run and enjoy)

addpath(genpath(['/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/']))
rmpath(genpath(['/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/AlexAnalysis/']));
rmpath(genpath(['/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/CNMF_E-master/']));

oldcd = analysis_path;

cd('/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/CNMF_E-master_Linux/')

%cvx_setup

cd(oldcd)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

msname = strrep(vidname, '.avi', '.mat');

%% Auto-detect operating system
oldcd = pwd;
cd(p)

%% Auto-detect operating system
if ispc
    separator = '\'; % For pc operating systems
else
    separator = '/'; % For unix (mac, linux) operating systems
end

% Generate timestamp to save analysis
script_start = tic;
analysis_time =strcat(date,'_', num2str(hour(now)),'-',num2str(minute(now)),'-',num2str(floor(second(now))));

%% 1 - Create video object and save into matfile
disp('Step 1: Create video object');
ms = msGenerateVideoObjTesting(pwd, '', testfilename);
ms.analysis_time = analysis_time;
ms.ds = spatial_downsampling;
% mkdir(strcat(pwd,separator,analysis_time));
save([ms.dirName separator msname],'ms');

%% 2 - Perform motion correction using NormCorre
disp('Step 2: Motion correction');
disp('Video height is:')
display(ms.height)
disp('Video width is:')
display(ms.width)

if ms.height == ms.width
    short_length = ms.height;
else
    short_length = min(ms.height,ms.width);
end

%%% determine ideal grid size based on size of video frames

grid_size = round((((short_length/ms.ds) + (gridness-1)*overlap) / gridness) - overlap)
mygrid = [grid_size,grid_size]

% run normcorre with selected parameters
ms = msNormCorre_Testing(ms, gSiz, gSig, mygrid, overlap, boundary, upsampling, maxshift, bin_width, iterations, vidname);


% insert CNMFe scripts here if you really want to test those too

% %% 3 - Perform CNMFE
% display('Step 3: CNMFE');
% ms = msRunCNMFE_large_Newsoft(ms);
% msExtractSFPs(ms); % Extract spatial footprints for subsequent re-alignement
% 
% x = [1:length(ms.FiltTraces(:,1))];
% xq = [1:5:length(ms.FiltTraces(:,1))];
% temp1 = interp1(x,ms.FiltTraces,xq);
% ms.FiltTraces = interp1(xq,temp1,x);
% ms.FiltTraces(find(isnan(ms.FiltTraces))) = 0;
% save([ms.dirName separator 'ms.mat'],'ms','-v7.3');
% 
% ms = msdeconvolve(ms);
%

analysis_duration = toc(script_start);
ms.analysis_duration = analysis_duration;
 
save([ms.dirName separator msname],'ms','-v7.3');
disp(['Data analyzed in ' num2str(analysis_duration) 's']);


end
