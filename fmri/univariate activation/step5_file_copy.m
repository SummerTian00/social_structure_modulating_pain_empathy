path=['..',filesep,'fMRI_data'];
folders=dir([path,'\sub*']);
analysis_name={'analysis_128'};

contrast_name={'01LNP','02LP','03DNP','04DP','05LvsD',...
        '06NPvsP','07LNPvsBNP','08LPvsDP','09LNPvsLP',...
        '10DNPvsDP','11NP(L-D)vsP(L-D)','12P(L-D)vsNP(L-D)'};
       
if ~exist([path, '\group'],'dir')
    mkdir(path,'group')
end
outpath=[path,'\univariate\' analysis_name{1} ]; % the aim folder.

for i=1:27
    filepath=[path,'\',folders(i).name,'\' analysis_name{1}]; % contrast files are in "analysis" folder
    
    confiles=dir([filepath,'\*con*.nii']); % find all the contrast files
    
    for conNum=1:length(confiles)
        
        if ~exist([outpath '\' confiles(conNum).name(1:end-4) '_' contrast_name{conNum}],'dir')  %only making the output folders once
            mkdir([outpath '\'],[confiles(conNum).name(1:end-4) '_' contrast_name{conNum}]); %making some output folders in the aim folder
        end
        real_input=[filepath '\' confiles(conNum).name(1:end-4) '.nii']; %
        real_output=[outpath '\' [confiles(conNum).name(1:end-4) '_' contrast_name{conNum}] '\' [folders(i).name '_' confiles(conNum).name(1:end-4) '.nii']];
        
        copyfile(real_input, real_output);
    end
end
