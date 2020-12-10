clear all
close all
clc

session_list = {'PRE', 'TEST01', 'TEST02', 'TEST03', 'TEST04', 'TEST05', 'TEST06', 'TEST07', 'TEST08', 'POST'};

for s_i = 1:1
% session_name = "PRE";
    session_name = session_list{s_i};
    session_type = "PPT";

    seg_size_list = [15];

    ledalab_dir = "E:/Toolboxes/Ledalab/ledalab-349";
    data_dir = "../../VerBIO_data/" + session_name;
    pid_file = data_dir + "/participant_id.xlsx";
    pid_list = readtable(pid_file);

    current_path = pwd;

    for idx = 1:length(seg_size_list)
        seg_size = seg_size_list(idx);

        output_dir = "../E4_segmentedFeature/"+ session_name + "/" + num2str(seg_size) + "sec";

        if ~isfolder(output_dir)
            mkdir(output_dir);
        end

        for pid=1:height(pid_list)

            %--------------------------------------------------------------------
            %EDA and its metrics
            %--------------------------------------------------------------------
            try
                fid = data_dir + "/E4/" + pid_list.PID{pid} + "/EDA_" + session_type +".xlsx";
                eda_data=readtable(fid);
                [scl_arr, scramp_arr, scrfreq_arr] = EDA_feature(eda_data,seg_size,session_type,pid,ledalab_dir);
                eda_flag = 1;
            catch
                eda_flag = 0;
                scl_arr = [];
                scramp_arr = [];
                scrfreq_arr = [];
            end

            cd(current_path)

            %--------------------------------------------------------------------
            %HR
            %--------------------------------------------------------------------

            try
                fid = data_dir + "/E4/" + pid_list.PID{pid} + "/HR_" + session_type +".xlsx";
                hr_data=readtable(fid);
                meanHR_arr = E4_otherfeature(hr_data,seg_size, 'HR', 1);
                hr_flag = 1;
            catch
                hr_flag = 0;
                meanHR_arr = [];
            end
            
            dt_flag = eda_flag + hr_flag;


            if dt_flag ~= 0
                [M,Tf]= padcat(scl_arr, scramp_arr, scrfreq_arr, meanHR_arr);
                T = array2table(M,'VariableNames',{'SCL','SCR_amp','SCR_freq','HR'});


                output_fid = output_dir + "/" + pid_list.PID{pid} + "_E4_feature_" + session_type + ".xlsx";
%                 writetable(T,output_fid);
            end


        end
    end
end