function P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name)
P.subject=sub_name;  %% set the subject names
P.directory=sub_path;%% set the path where SPM.mat file is stored for each subject
P.VOI= [mask_path filesep ROI_name]; %% this need to be changed for different studies
P.Region=ROI_name(1:end-4);  %% this is the base name of the output directory
P.analysis='psy';%if doing physiophysiological interaction-phys;if psychophysiophysiological-psyphy
P.method='cond';% traditional SPM PPI-'trad';generalized condition-specific PPI-cond(recommend)
P.Estimate=1;% whether or not to estimate the PPI design(0 1 2)
P.contrast=0;%0:Not to adjust for the effect of the null space % if taks F test we can use 'eff_of_interest'
P.extract='mean'; %% you can try 'eig' here.specifies the method of ROI extraction:mean or eig(default eigenvariate)
P.Tasks={'0','01LNP','02LP','03DNP','04DP'};% confirm to specify
P.Weights=[]; % no need for weights for gPPI; this need to be set for SPM PPI-traditional PPI
P.CompContrasts=1;%0-not to estimate any contrasts;1-estimate the design(recommended)
P.Weighted=0;%traditional needs
P.GroupDir=[work_dir filesep 'Group_PPI_' ROI_name(1:end-4)];
P.ConcatR=0;  %%�@can be used to concat sessions to reduce collineaity between task and PPI regressors
P.preservevarcorr=0; %preserves the variance correction estimated from the first level model. This will save time and also means all regions will have the same correction applied

%% This is only set to sub 22 in order to correct errors. For more detials,
% refer to: http://www.nitrc.org/forum/forum.php?thread_id=5152&forum_id=1970
% this will lead to missing of one voxel of RdlPFC (515 voxels to 514) for subject 22, so it is fine
P.equalroi=0;%default:1-roi must be the same size in all subjects, set 0 to lift the restriction
P.FLmask=1;%default:0-restricted using the mask.img from first-level statistics;1- remove the restriction
%other parameters
%VOI2-define the second seed region for physiophysiological interaction
%%
P.Contrasts(1).left={P.Tasks{2}};
P.Contrasts(1).right={'none'};
P.Contrasts(1).STAT='T';% or F
P.Contrasts(1).Weighted=0;
P.Contrasts(1).MinEvents=1;
P.Contrasts(1).name='01LNP';

P.Contrasts(2).left={P.Tasks{3}};
P.Contrasts(2).right={'none'};
P.Contrasts(2).STAT='T';
P.Contrasts(2).Weighted=0;
P.Contrasts(2).MinEvents=1;
P.Contrasts(2).name='02LP';

P.Contrasts(3).left={P.Tasks{4}};
P.Contrasts(3).right={'none'};
P.Contrasts(3).STAT='T';
P.Contrasts(3).Weighted=0;
P.Contrasts(3).MinEvents=1;
P.Contrasts(3).name='03DNP';

P.Contrasts(4).left={P.Tasks{5}};
P.Contrasts(4).right={'none'};
P.Contrasts(4).STAT='T';
P.Contrasts(4).Weighted=0;
P.Contrasts(4).MinEvents=1;
P.Contrasts(4).name='04DP';

P.Contrasts(5).left={'01LNP' '04DP'};
P.Contrasts(5).right={'02LP' '03DNP'};
P.Contrasts(5).STAT='T';% or F
P.Contrasts(5).Weighted=0;
P.Contrasts(5).MinEvents=1;
P.Contrasts(5).name='05NP(L-D)vsP(L-D)';
return;

