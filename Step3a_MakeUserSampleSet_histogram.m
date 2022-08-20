%makeUserSampleSet
%for impersonation attack experiment
%input: histogram .mat file, list_of_file.txt
%output: aswin_mimic_train, aswin_mimic_test, etc
clear;
addpath('.\Library\');
rng(2);

numOfTrainData = 60;
numOfTestData = 70;
numOfRound = 5;
%parameter setting

histogram_path = ['.\Data\Histogram\'];

sampleset_path = ['.\Data\SampleSet\histogram\'];
% create folder if not exist
if not(isfolder(sampleset_path))
    mkdir(sampleset_path)
end

%read list of filename
fid = fopen("Data\List_of_Files.txt");

while ~feof(fid)
    text_line = fgetl(fid);
    
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);

    fprintf(['Processing histogram of %s to sample Set\n'], fileName);
    
    load ([histogram_path fileName '_Histogram.mat'], 'histogramPerPeriod');
    histogramCount = size(histogramPerPeriod, 1);
    
    for round=1:numOfRound
        trainHistogram = [];
        testHistogram = [];
        randHistogramIndex = randperm(histogramCount);
            
            
        for histogramNum = 1:numOfTrainData
            trainHistogram = [trainHistogram; histogramPerPeriod(randHistogramIndex(histogramNum),:)];
        end
                
        save([sampleset_path fileName '_train_sampleSet_round_' num2str(round) '.mat'], 'trainHistogram', '-v7.3');
                
        for histogramNum = numOfTrainData + 1 : numOfTrainData + numOfTestData
            testHistogram = [testHistogram; histogramPerPeriod(randHistogramIndex(histogramNum),:)];
        end
                
        save([sampleset_path fileName '_test_sampleSet_round_' num2str(round) '.mat'], 'testHistogram', '-v7.3');
    end
end