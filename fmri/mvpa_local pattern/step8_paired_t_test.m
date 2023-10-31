clear
spm('defaults', 'FMRI');
path=['..',filesep,'pair_LPvsDP_vs_LNPtoDNP'];
ms_path1=['..',filesep,'pair_LPvsDP_vs_LNPtoDNP',filesep,'decoding_02LPvs04DP_searchlight',filesep,'accuracy_minus_chance' ];
ms_path2=['..',filesep,'pair_LPvsDP_vs_LNPtoDNP',filesep,'decoding_01LNPvs03DNP_searchlight',filesep,'accuracy_minus_chance' ];
 
out_path=[path '\group'];
left_file=spm_select ('FPList',[ms_path1 '\'], '.*mswre.*\.nii');%path1:acc
left_file= cellstr(left_file);
right_file=spm_select ('FPList',[ms_path2 '\'], '.*mswre.*\.nii');%path1:acc
right_file= cellstr(right_file);
    
 %set up SPM design
matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(out_path);
matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
                
for ym=1:length(left_file)
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(ym).scans = {left_file{ym};right_file{ym}};
end
        
%estimate
matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr([out_path '\SPM.mat']);
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%clear matlabbatch;
spm_jobman('serial', matlabbatch);
clear matlabbatch;