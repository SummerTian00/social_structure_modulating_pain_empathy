%%  This script is used to copy files; From each subject's folder to a  group folder.
path=['..',filesep,'fMRI_data'];
outpath=['..',filesep,'fMRI_data',filesep,'gPPI']; 
folders=dir([path,'\sub*']);
outputs=dir([outpath,'\Group_PPI_*']);
for i=1:length(folders)
    path2=[path '\' folders(i).name '\test'];
    
    for j=1:length(outputs)
        
        outp2={'01LNP','02LP','03DNP','04DP','05GPvsBP','06NP(G-B)vsP(G-B)'};%dir([outpath '/' outputs(j).name  '/1*']);
        
        for k=1:length(outp2)
            real_input=[path2 '\' outputs(j).name(7:end)  '\con_PPI_' outp2{k} '_' folders(i).name '.img'];
            
            if i==1
                mkdir([outpath '\' outputs(j).name '\' outp2{k}]);
            end
            
            real_output=[outpath '\' outputs(j).name '\' outp2{k} '\con_PPI_' outp2{k} '_' folders(i).name '.nii'];
            copyfile(real_input,real_output);
        end
    end
end