%makeUserSampleSet
%for impersonation attack experiment
%input: victims_norm_feature.xlsx file, list_of_file.txt
%output: aswin_mimic_train, aswin_mimic_test, etc
clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\normalized49Feature\'];

sampleset_path = ['.\Data\SampleSet\feature\'];
% create folder if not exist
if not(isfolder(sampleset_path))
    mkdir(sampleset_path)
end

%read list of filename
fid = fopen("Data\List_of_Files.txt");

samplesetData = [];
while ~feof(fid)
    text_line = fgetl(fid);
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);

    fprintf(['Processing feature data of %s to sample Set\n'], fileName);
    [userFlick] = xlsread([feature_path fileName '_normFeaturedata.xlsx'], 'userFlick');
    [userFeatureData] = xlsread([feature_path fileName '_normFeaturedata.xlsx'], 'normFeaturedata');
    
    trainingRound1 = [];
    trainingRound2 = [];
    trainingRound3 = [];
    trainingRound4 = [];
    trainingRound5 = [];

    testingRound1 = [];
    testingRound2 = [];
    testingRound3 = [];
    testingRound4 = [];
    testingRound5 = [];

    for index = 1:size(userFlick(:,1),1)
        if mod(userFlick(index,6), 10) == 1
            trainingRound1 = [trainingRound1; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 2
            trainingRound2 = [trainingRound2; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 3
            trainingRound3 = [trainingRound3; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 4
            trainingRound4 = [trainingRound4; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 5
            trainingRound5 = [trainingRound5; userFlick(index,:) userFeatureData(index,:)];

        elseif mod(userFlick(index,6), 10) == 6
            testingRound1 = [testingRound1; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 7
            testingRound2 = [testingRound2; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 8
            testingRound3 = [testingRound3; userFlick(index,:) userFeatureData(index,:)];
        elseif mod(userFlick(index,6), 10) == 9
            testingRound4 = [testingRound4; userFlick(index,:) userFeatureData(index,:)];
        else
            testingRound5 = [testingRound5; userFlick(index,:) userFeatureData(index,:)];
        end
    end
    samplesetSize = round((size(trainingRound1(:,1),1) + size(trainingRound2(:,1),1) + size(trainingRound3(:,1),1) + size(trainingRound4(:,1),1) + size(trainingRound5(:,1),1) + size(testingRound1(:,1),1) + size(testingRound2(:,1),1) + size(testingRound3(:,1),1) + size(testingRound4(:,1),1) + size(testingRound5(:,1),1) ) /10);
    samplesetData = [samplesetData; samplesetSize];
    sizeEnd =  size(testingRound5(1,:),2);
%     excelName = [sampleset_path fileName '_train_sampleSet_round_1.xlsx'];
%     xlswrite(excelName,trainingRound1(:,1:6),'userData','A1');
%     xlswrite(excelName,trainingRound1(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_train_sampleSet_round_1'];
    userData = trainingRound1(:,1:6);
    normFeatureData = trainingRound1(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');
%     excelName = [sampleset_path fileName '_train_sampleSet_round_2.xlsx'];
%     xlswrite(excelName,trainingRound2(:,1:6),'userData','A1');
%     xlswrite(excelName,trainingRound2(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_train_sampleSet_round_2'];
    userData = trainingRound2(:,1:6);
    normFeatureData = trainingRound2(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');
%     excelName = [sampleset_path fileName '_train_sampleSet_round_3.xlsx'];
%     xlswrite(excelName,trainingRound3(:,1:6),'userData','A1');
%     xlswrite(excelName,trainingRound3(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_train_sampleSet_round_3'];
    userData = trainingRound3(:,1:6);
    normFeatureData = trainingRound3(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');
%     excelName = [sampleset_path fileName '_train_sampleSet_round_4.xlsx'];
%     xlswrite(excelName,trainingRound4(:,1:6),'userData','A1');
%     xlswrite(excelName,trainingRound4(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_train_sampleSet_round_4'];
    userData = trainingRound4(:,1:6);
    normFeatureData = trainingRound4(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');
%     excelName = [sampleset_path fileName '_train_sampleSet_round_5.xlsx'];
%     xlswrite(excelName,trainingRound5(:,1:6),'userData','A1');
%     xlswrite(excelName,trainingRound5(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_train_sampleSet_round_5'];
    userData = trainingRound5(:,1:6);
    normFeatureData = trainingRound5(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

%     excelName = [sampleset_path fileName '_test_sampleSet_round_1.xlsx'];
%     xlswrite(excelName,testingRound1(:,1:6),'userData','A1');
%     xlswrite(excelName,testingRound1(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_test_sampleSet_round_1'];
    userData = testingRound1(:,1:6);
    normFeatureData = testingRound1(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

%     excelName = [sampleset_path fileName '_test_sampleSet_round_2.xlsx'];
%     xlswrite(excelName,testingRound2(:,1:6),'userData','A1');
%     xlswrite(excelName,testingRound2(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_test_sampleSet_round_2'];
    userData = testingRound2(:,1:6);
    normFeatureData = testingRound2(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

%     excelName = [sampleset_path fileName '_test_sampleSet_round_3.xlsx'];
%     xlswrite(excelName,testingRound3(:,1:6),'userData','A1');
%     xlswrite(excelName,testingRound3(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_test_sampleSet_round_3'];
    userData = testingRound3(:,1:6);
    normFeatureData = testingRound3(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

%     excelName = [sampleset_path fileName '_test_sampleSet_round_4.xlsx'];
%     xlswrite(excelName,testingRound4(:,1:6),'userData','A1');
%     xlswrite(excelName,testingRound4(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_test_sampleSet_round_4'];
    userData = testingRound4(:,1:6);
    normFeatureData = testingRound4(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

%     excelName = [sampleset_path fileName '_test_sampleSet_round_5.xlsx'];
%     xlswrite(excelName,testingRound5(:,1:6),'userData','A1');
%     xlswrite(excelName,testingRound5(:,7:sizeEnd),'normFeaturedata','A1');
    excelName = [sampleset_path fileName '_test_sampleSet_round_5'];
    userData = testingRound5(:,1:6);
    normFeatureData = testingRound5(:,7:sizeEnd);
    save([excelName '_userFlick.mat'], 'userData', '-v7.3');
    save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');

end 
excelName = [sampleset_path 'SizeofSampleSet.xlsx'];
xlswrite(excelName,samplesetData,'SizeofSampleSet','A1');
xlswrite(excelName,mean(samplesetData),'AVG_SizeofSampleSet','A1');
xlswrite(excelName,min(samplesetData),'min_SizeofSampleSet','A1');
