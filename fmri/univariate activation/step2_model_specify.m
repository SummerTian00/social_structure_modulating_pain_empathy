root_path=['..',filesep,'behaviour'];%txt
folders=dir([root_path,'\sub*']);
%folders_avg=dir([root_path,'\avg*']);
N=length(folders);
root_path1=['..',filesep,'fMRI_data'];%fmri
folders1=dir([root_path1,'\sub*']);
for sub_num=1:27
    path=root_path;
    path1=[root_path1, '\' folders1(sub_num).name];
    ALL=load(folders(sub_num).name); 
    for run=1:2 %2 runs
        eve_type={'01LNP','02LP','03DNP','04DP','05NR'};
        %% getting onsets
        %% parameters for each run      
        for typ_num=1:5
                if typ_num==1
                    onset=ALL(find(ALL(:,4)==run & ALL(:,6)==1 & ALL(:,14)~=0),8); %con1
                    dur=3;
                  
                elseif typ_num==2
                    onset=ALL(find(ALL(:,4)==run & ALL(:,6)==2 & ALL(:,14)~=0),8); %con2
                    dur=3;
                  
                elseif typ_num==3
                    onset=ALL(find(ALL(:,4)==run & ALL(:,6)==3 & ALL(:,14)~=0),8); %con3
                    dur=3;
                 
                elseif typ_num==4
                    onset=ALL(find(ALL(:,4)==run & ALL(:,6)==4 & ALL(:,14)~=0),8); %con4
                    dur=3;
                
                elseif typ_num==5
                    onset=ALL(find(ALL(:,4)==run & ALL(:,14)==0),8);
                    dur=3;
                end
                
                if isempty(onset)%if no reaction--NAN
                   onset=['NaN'];
                   dur=['NaN'];
                end    
                   
            
            names{typ_num}=eve_type{typ_num};
            onsets{typ_num}=onset;
            durations{typ_num}=dur;
            pmod(typ_num).name{1}='none'
            pmod(typ_num).param{1}=0;
            pmod(typ_num).poly{1}=1;
            
            onset=[];
            dur=[];
        end
        
        run_paths=dir([path1,'\*ge_func*']);
        run1_path=[path1,'\' run_paths(1).name];
        run2_path=[path1,'\' run_paths(2).name];
        
        oup_name=['conditions_run0' num2str(run)];
        
        if run==1
            save([run1_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        elseif run==2
            save([run2_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        end  
    end
end