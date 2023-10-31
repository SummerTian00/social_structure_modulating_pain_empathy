clear
root_path=['..',filesep,'fMRI_data'];
folders=dir([root_path,'\sub*']);
TXT_path=['..',filesep,'behaviour'];%txt
TXT_folders=dir([TXT_path,'\sub*']);
for sub_num=1:length(folders)
    path=[root_path, '\' folders(sub_num).name];
    ALL=load(TXT_folders(sub_num).name);
    for run=1:2
        eve_type={'01LNP','02LP','03DNP','04DP','05NR'};        
        %% getting onsets      
        temp_len=0; 
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
            
            if isempty(onset)
                onset=['NaN'];
                dur=['NaN'];
            end
            
            if typ_num<5
                for yyz=1:length(onset)
                eve_name=[eve_type{typ_num} '_' num2str(yyz)];
                trial_onset=onset(yyz);
                
                names{temp_len+yyz}=eve_name;
                onsets{temp_len+yyz}=trial_onset;
                durations{temp_len+yyz}=dur;
                pmod(temp_len+yyz).name{1}='none';%'RT';
                pmod(temp_len+yyz).param{1}=0;%RT;
                pmod(temp_len+yyz).poly{1}=1;
                end
                temp_len=length(onset)+temp_len;    
                
            elseif typ_num==5 %for no response trial
                temp_len=temp_len+1;
                names{temp_len}=eve_type{typ_num};
                onsets{temp_len}=onset;
                durations{temp_len}=dur;
                pmod(temp_len).name{1}='none';
                pmod(temp_len).param{1}=0;
                pmod(temp_len).poly{1}=1;
            end
        end
        
        %save conditions.mat conditions;
        run_paths=dir([path,'\*ge_func*']);
        run1_path=[path,'\' run_paths(1).name];
        run2_path=[path,'\' run_paths(2).name];
        
        oup_name=['conditions_run0' num2str(run) '_MVPA.mat'];
        
        if run==1
            save([run1_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        elseif run==2
            save([run2_path '\' oup_name], 'names', 'onsets', 'durations','pmod');
        end
        clear 'names' 'pmod' 'onsets' 'durations';
    end
end