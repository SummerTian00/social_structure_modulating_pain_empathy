%% initialize SPM and the batch mode
clear
spm('defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch;

path=['..',filesep,'MVPA'];
folders=dir([path,filesep,'pair*']);
Tvalue=3.435; % to form clusters

for xm=1:length(folders)
    spm('defaults', 'FMRI');

     left_path={'decoding_02LPvs04DP_searchlight'};
     right_path={'decoding_01LNPvs03DNP_searchlight'};
     test_name={'SnPM_02LPvs04DP_VS_01LNPvs03DNP'};
    
    meas={'accuracy','dprime'};
    measpath={'mswres_accuracy_minus_chance','mswres_dprime'};
    
    for xxx=1:length(test_name)
        for mn=1:length(meas)
            mkdir([path,filesep,folders(xm).name,filesep,test_name{xxx} '_' meas{mn}]);
            
            left_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,left_path{xxx},filesep,measpath{mn},filesep], '^mswres.*\.nii$');
            left_img=cellstr(left_img);
            
            right_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,right_path{xxx},filesep,measpath{mn},filesep], '^mswres.*\.nii$');
            right_img=cellstr(right_img);
            
            matlabbatch{1}.spm.tools.snpm.des.PairT.DesignName = 'MultiSub: Paired T test; 2 conditions, 1 scan per condition';
            matlabbatch{1}.spm.tools.snpm.des.PairT.DesignFile = 'snpm_bch_ui_PairT';
            matlabbatch{1}.spm.tools.snpm.des.PairT.dir = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx} '_' meas{mn},filesep]);
            
            for ym=1:length(left_img)
                matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(ym).scans = {left_img{ym};right_img{ym}};
                matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(ym).scindex = [1 2];
            end
            
            matlabbatch{1}.spm.tools.snpm.des.PairT.nPerm = 5000;
            matlabbatch{1}.spm.tools.snpm.des.PairT.vFWHM = [0 0 0];
            matlabbatch{1}.spm.tools.snpm.des.PairT.bVolm = 1;
            matlabbatch{1}.spm.tools.snpm.des.PairT.ST.ST_U = Tvalue;
            matlabbatch{1}.spm.tools.snpm.des.PairT.masking.tm.tm_none = 1;
            matlabbatch{1}.spm.tools.snpm.des.PairT.masking.im = 1;
            matlabbatch{1}.spm.tools.snpm.des.PairT.masking.em = {''};
            matlabbatch{1}.spm.tools.snpm.des.PairT.globalc.g_omit = 1;
            matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.gmsca.gmsca_no = 1;
            matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.glonorm = 1;
            
             %% compupte
            matlabbatch{2}.spm.tools.snpm.cp.snpmcfg = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx} '_' meas{mn},filesep,'SnPMcfg.mat']);
            
             %% inference
            matlabbatch{3}.spm.tools.snpm.inference.SnPMmat(1) = cfg_dep('Compute: SnPM.mat results file', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','SnPM'));
            matlabbatch{3}.spm.tools.snpm.inference.Thr.Clus.ClusSize.CFth = NaN;
            matlabbatch{3}.spm.tools.snpm.inference.Thr.Clus.ClusSize.ClusSig.FWEthC = 0.05;
            matlabbatch{3}.spm.tools.snpm.inference.Tsign = 1;
            matlabbatch{3}.spm.tools.snpm.inference.WriteFiltImg.WF_no = 0;
            matlabbatch{3}.spm.tools.snpm.inference.Report = 'MIPtable';

            %% clear
            spm_jobman('serial', matlabbatch);
            clear matlabbatch;
        end
    end
end