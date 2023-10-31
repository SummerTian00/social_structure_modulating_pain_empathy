spm('defaults', 'FMRI');
path=['..',filesep,'fMRI_data'];%改路径
folders=dir([path,'\sub*']);%开头
for i=1:length(folders)
    INPUTS=spm_select ('FPList',[path '\' folders(i).name '\'], '^20xx.*\.IMA');%20xx needs to change depends on your data
    INPUTS= cellstr(INPUTS);
    
    matlabbatch{1}.spm.util.import.dicom.data =INPUTS;
    matlabbatch{1}.spm.util.import.dicom.root = 'series';
    matlabbatch{1}.spm.util.import.dicom.outdir =cellstr([path '\' folders(i).name '\']);
    matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
    matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
    matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;
    
    %clear matlabbatch;
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
    
    %zip the DICOM files
    all_files=[path '\' folders(i).name '\*.IMA'];
    countfile=length(dir(all_files));
    savefile=[path '\'  folders(i).name '\DICOM_file_volume_' num2str(countfile) '.zip'];
    zip(savefile, all_files);
    delete(all_files);
end