%% LP vs DP
basedir = ['..',filesep,'fMRI_data'];
gray_matter_mask = which('gray_matter_mask.img');
sub_fold=dir([basedir,'\sub*']);
LP_imgs =[];
DP_imgs=[];
for n=1:length(sub_fold)
    LP_img =filenames(fullfile(basedir, sub_fold(n).name,'\analysis128\con_0002.nii'));
    DP_img = filenames(fullfile(basedir, sub_fold(n).name, '\analysis128\con_0004.nii'));
    LP_imgs=[LP_imgs;LP_img];
    DP_imgs=[DP_imgs;DP_img];
end
data_LPDP = fmri_data([LP_imgs; DP_imgs], gray_matter_mask);
data_LPDP.Y = [ones(numel(LP_imgs),1); -ones(numel(DP_imgs),1)];

% LOSO and save weights
n_folds = [repmat(1:27,1,1) repmat(1:27,1,1)];
n_folds = n_folds(:);
[~, stats_loso_LPDP] = predict(data_LPDP, 'algorithm_name', 'cv_svm', 'nfolds', n_folds, 'error_type', 'mcr');
ROC_loso_LPDP = roc_plot(stats_loso_LPDP.dist_from_hyperplane_xval, data_LPDP.Y == 1, 'twochoice','color','r');
% Threshold:	0.00	Sens:	 85% CI(69%-97%)	Spec:	 85% CI(71%-96%)	PPV:	 85% CI(71%-96%)	Nonparametric AUC:	0.90	Parametric d_a:	1.18	  Accuracy:	 85% +- 6.8% (SE), P = 0.000311

%% read GP AND BP images
basedir = ['..',filesep,'fMRI_data'];
gray_matter_mask = which('gray_matter_mask.img');
sub_fold=dir([basedir,'\sub*']);
LNP_imgs =[];
DNP_imgs=[];
for n=1:length(sub_fold)
    LNP_img =filenames(fullfile(basedir, sub_fold(n).name,'\analysis128\con_0001.nii'));
    DNP_img = filenames(fullfile(basedir, sub_fold(n).name, '\analysis128\con_0003.nii'));
    LNP_imgs=[LNP_imgs;LNP_img];
    DNP_imgs=[DNP_imgs;DNP_img];
end
data_LNPDNP = fmri_data([LNP_imgs; DNP_imgs], gray_matter_mask);
data_LNPDNP.Y = [ones(numel(LNP_imgs),1); -ones(numel(DNP_imgs),1)];

% LOSO and save weights
n_folds = [repmat(1:27,1,1) repmat(1:27,1,1)];
n_folds = n_folds(:);
[~, stats_loso_LNPDNP] = predict(data_LNPDNP, 'algorithm_name', 'cv_svm', 'nfolds', n_folds, 'error_type', 'mcr');
ROC_loso_LNPDNP = roc_plot(stats_loso_LNPDNP.dist_from_hyperplane_xval, data_LNPDNP.Y == 1, 'twochoice','color','r');
% Threshold:	0.00	Sens:	 63% CI(44%-81%)	Spec:	 63% CI(45%-81%)	PPV:	 63% CI(44%-80%)	Nonparametric AUC:	0.75	Parametric d_a:	0.68	  Accuracy:	 63% +- 9.3% (SE), P = 0.247789
