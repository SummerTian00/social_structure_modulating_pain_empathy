spm('defaults', 'FMRI');
path=['..',filesep,'fMRI_data'];
folders=dir([path,'\sub*']);
for i=1:length(folders)
    sub_file=folders(i).name;
    
    % anat file choose brain
    anat_folder=dir([path, '\', sub_file, '\t1_mprage*']);
    anat_file=spm_select ('FPList',[path '\' sub_file '\' anat_folder(1).name '\'], '^B.*\.nii');
    anat_file=cellstr(anat_file);
    
    %%  transform matrix
    def_file=spm_select ('FPList',[path '\' sub_file '\' anat_folder(1).name '\'], '^y_s.*\.nii');
    def_file=cellstr(def_file);
    
    %% mask image
    MVPAfolder=dir([path,'\' sub_file '\' 'MVPA*']);
    for j=1:length(MVPAfolder)
        
        mask_image=spm_select ('FPList',[path '\' sub_file '\' MVPAfolder(j).name '\'], '^mask.*\.nii');
        mask_image=cellstr(mask_image);
        
        
        %1. coregister to T1 image
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = anat_file;
        matlabbatch{1}.spm.spatial.coreg.estimate.source = mask_image;
        matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        
        %2. normalize the image
        matlabbatch{2}.spm.spatial.normalise.write.subj.def(1) = def_file;
        matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) =  mask_image; % I can do this, because the above step did not generate new images
        matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
            90 90 108];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
        matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;
        matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'w';
        
        %% do the job
        spm_jobman('serial', matlabbatch);
        clear matlabbatch;
    end
    
end
