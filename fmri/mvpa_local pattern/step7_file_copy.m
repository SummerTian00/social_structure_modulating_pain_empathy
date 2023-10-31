clear
path=['..',filesep,'fMRI_data'];
outpath=['..',filesep,'fMRI_data',filesep,'MVPA'];
folders=dir([path,'\sub*']);
for i=1:length(folders)
    sub_file=folders(i).name;
    MVPAfolder=dir([path,'\' sub_file '\' 'MVPA*']);
    for j=1:length(MVPAfolder)
        filepath=[path,'\',folders(i).name, '\' MVPAfolder(j).name]; % contrast files are in "analysis" folder
        
        search_folders=dir([filepath '\*_searchlight']);
        
        for conNum=1:length(search_folders)
            
            outputs=dir([filepath '\' search_folders(conNum).name '\msw*.nii']);
            
            for zz=1:length(outputs)
                
                if i==1
                    mkdir([outpath '\' MVPAfolder(j).name '\'],[search_folders(conNum).name '\' outputs(zz).name(1:end-4)]);
                end
                
                real_input=[filepath '\' search_folders(conNum).name '\' outputs(zz).name(1:end-4) '.nii']; %
                real_output=[outpath '\' MVPAfolder(j).name '\' search_folders(conNum).name '\' outputs(zz).name(1:end-4) '\' [outputs(zz).name(1:end-4) '_' folders(i).name '.nii']];
                copyfile(real_input, real_output);
                
            end
        end
    end
end


