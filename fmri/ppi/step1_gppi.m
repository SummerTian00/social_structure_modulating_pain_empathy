%% Add the path to the gPPPI toolbox. I'm assuming SPM8 is already in the path.
spmpath=fileparts(which('spm.m')); % find the pathway of spm.m
addpath([spmpath filesep 'toolbox']);
addpath([spmpath filesep 'toolbox' filesep 'PPPI']);
spm('defaults','fmri')

%% %path 
pathx=['..',filesep,'fMRI_data'];
work_dir=[pathx,'\gPPI_ROIs'];  %working directory, where to store .psfiles /need to creat a new folder
returnHere=pathx;
mask_path=['..',filesep,'fMRI_data',filesep,'gPPI_ROIs' ]; %% where VOI/mask is stored 
 
subfiles=dir([pathx,'\sub*']); %% filename of each subject's directory
ROIfiles=dir([mask_path,'\']);%if you have different format,use prefix.or '\roi*.img'
 
 %% %%%%% performing the gPPI for each subject
 
 for x=1:length(subfiles)
     sub_name=subfiles(x).name;
     sub_path=fullfile(returnHere,[subfiles(x).name,'\fMRI_data']);
     
     for ROI_num=1:length(ROIfiles)
         cd(returnHere)
         ROI_name=ROIfiles(ROI_num).name;
         
         P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name);
         
         PPPI(P,[sub_path '\gPPI_' sub_name '_' ROI_name '.mat']);  %% set the parameter for each subject
         clear P;
         cd(pathx);
     end
 end
  
