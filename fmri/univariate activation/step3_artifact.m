%before using this script, run a first-level analysis without movement
%regressor.

%based on the above SPM.mat file, this script will generate
%art_motion_regressor for the real first level analysis.

spm('defaults', 'FMRI');
path=['..',filesep,'fMRI_data'];
folders=dir([path filesep 'sub*']);
for i=1:length(folders)
    
    sub_file=folders(i).name;
    
    sub_path=[path filesep sub_file filesep 'analysis128'];
    run_folder=dir([path filesep sub_file '\*ge_func*']);
    
    image_files=spm_select ('FPList',[path '/' sub_file '/' run_folder(1).name '/'], '^swuf.*\.nii'); % image files
    motion_files=spm_select ('FPList',[path '/' sub_file '/' run_folder(1).name '/'], '^rp.*\.txt');   % motion txt files
    
    image_files=spm_select ('FPList',[path '/' sub_file '/'], '^swuaf.*\.nii'); % image files
    motion_files=spm_select ('FPList',[path '/' sub_file '/'], '^rp.*\.txt');   % motion txt files
    
    mk_cfg_SPM(sub_path,[sub_path filesep 'SPM.mat']); %to generate the cfgfile for each subject
  
    cfgfile=fullfile(sub_path,'art_config.cfg');    %to use the cfgfile for analysis.
    
    art('sess_file',cfgfile); %generate the regression .mat for first level
    set(gcf,'name',['art_batch: art subject #',sub_file]);

end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       