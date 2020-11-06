analysis_path = pwd; %put in path to folder in question here (or make copy of this file within the folder you want to run and enjoy)

addpath(genpath(['/lustre03/project/6049321/m3group/Wilson/']))
rmpath(genpath(['/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/AlexAnalysis/']));
rmpath(genpath(['/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/CNMF_E-master/']));

oldcd = analysis_path;

cd('/lustre03/project/6049321/m3group/Wilson/Brandon-Williams-Analysis-Package/Imported Analysis Scripts/CNMF_E-master_Linux/')

cvx_setup

cd(oldcd)

msRun2020_newSoft(analysis_path)

