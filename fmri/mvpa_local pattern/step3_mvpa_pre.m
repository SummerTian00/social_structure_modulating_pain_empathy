toolpath='D:\matlab\matlab2020b\toolbox\spm12\toolbox\decoding';
addpath(genpath(toolpath));
spm('defaults', 'FMRI');

path=['..',filesep,'fMRI_data',filesep,'mvpa'];
subfolders=dir([path,'\sub*']);
for xx=1:length(subfolders)
    
    subfold=dir([path,'\' subfolders(xx).name '\MVPA_analysis*']);
    
    for mm=1:length(subfold)
        
        %% 1. setup paths
        subpath=[path,'\' subfolders(xx).name '\' subfold(mm).name];
        ROIfile=fullfile(subpath,'mask.nii');
        
        %% 2.extract SPM.mat
        load([subpath,'\SPM.mat']);
        for i=1:length(SPM.Vbeta)
            betafile{i,1}=SPM.Vbeta(i).fname;
            betafile{i,2}=SPM.Vbeta(i).descrip;
        end
          
        %% 3.3. run the outcome stage
        LNP_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'01LNP'});
        LNP_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'01LNP'});
        DNP_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'03DNP'});
        DNP_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'03DNP'});
        outfolder=fullfile(subpath,'decoding_01LNPvs03DNP_searchlight');
        MVPA_analysis(LNP_run1_images,LNP_run2_images,DNP_run1_images,DNP_run2_images,'01LNP','03DNP',outfolder,ROIfile)
        
         %% 3.4. run the outcome stage
        LP_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'02LP'});
        LP_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'02LP'});
        BP_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'04DP'});
        BP_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'04DP'});
        outfolder=fullfile(subpath,'decoding_02LPvs04DP_searchlight');
        MVPA_analysis(LP_run1_images,LP_run2_images,BP_run1_images,BP_run2_images,'02LP','04DP',outfolder,ROIfile)
    end
    clear betafile
end