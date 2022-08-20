% M1 Attack Experiment, using victim data for experiment, standard negative data + attacker data

clear;
rng(2);
addpath('.\Library\');
result_path = '.\Results\M1\feature\';
featureIndex = [1:49];

%to match the index of data required
victimShift = 0;
%index shift, because first user start from 3
indexShift = 2 + victimShift;
modelType = 1;

%negative data setting
negativeData_path = '.\Data\Negative\feature\';

%read list of victim
victim_list = {};
fid = fopen('.\Data\Victim_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    victim_list = [victim_list; text_line];
end
fclose(fid);

%read list of attacker
attacker_list = {};
fid = fopen('.\Data\Attacker_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    attacker_list = [attacker_list; text_line];
end
fclose(fid);

allAvgEER = [];
allFW = [];

%start experiment per attacker
for attackerCount = 1: size(attacker_list, 1)
    attackerName = cell2mat(attacker_list(attackerCount));
    for victimCount = 1: size(victim_list, 1)
        victimName = cell2mat(victim_list(victimCount));
        user_result_path = [result_path attackerName];
        
        %create folder if not exist
        if(~exist([user_result_path],'dir'))
            mkdir([user_result_path]);
        end
        filePath = [user_result_path '\' victimName '.xlsx'];
        
        fprintf('M1 Attack Experiment, Attacker:%s x Victim:%s\n', attackerName, victimName);
        [victimAvgEER, victimFw] = TrainTestFeature(featureIndex, victimName, victimCount, indexShift, victimShift, attackerName, modelType, filePath);
        allAvgEER = [allAvgEER; victimAvgEER];
        allFW = [allFW; victimFw];
    end
end