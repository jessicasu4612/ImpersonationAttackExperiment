%separate Histogram and Feature
%current sample set contain Histogram and Feature because we want to make
%experiment in dynamic feature data, so we need a script to separate them

clear;

userInvolved = [1:102];
numOfFlick = 5;
numOfRound = 5;

sampleset_path = ['.\20200619_OnlineLearning_' num2str(numel(userInvolved)) '_users_5_round_stand_mix'];
sampleset_histogramOnly_path = ['.\20200619_OnlineLearning_' num2str(numel(userInvolved)) '_users_5_round_stand'];
sampleset_featureOnly_path = ['.\20200619_OnlineLearning_' num2str(numel(userInvolved)) '_users_5_round_stand_feature'];

for userCount = 1:numel(userInvolved)
    %trainHistogramArray = cell(1, numOfRound);
    %testHistogramArray = cell(1, numOfRound);
    rng(25);
    for round=1:numOfRound
        for period=1:8
            load ([sampleset_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_train_sampleSet.mat'], 'trainHistogram');
            load ([sampleset_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_test_sampleSet.mat'], 'testHistogram');
            
            %wrong naming at histogram making, the original variable name should be trainHistogramAndFeature
            trainHistogramAndFeature = trainHistogram;
            testHistogramAndFeature = testHistogram;
            
            %array declaration
            trainHistogram = cell(size(trainHistogramAndFeature, 1), 49);
            trainFeature = cell(size(trainHistogramAndFeature, 1), 49);
           
            testHistogram = cell(size(testHistogramAndFeature, 1), 49);
            testFeature = cell(size(testHistogramAndFeature, 1), 49);
            
            for rowCount = 1:size(trainHistogramAndFeature, 1)
                for columnCount = 1:49
                    trainHistogram(rowCount, columnCount) = {trainHistogramAndFeature(rowCount,columnCount).histogram};
                    trainFeature(rowCount, columnCount) = {trainHistogramAndFeature(rowCount,columnCount).featureData};
                end
            end
            
            for rowCount = 1:size(trainHistogramAndFeature, 1)
                for columnCount = 1:49
                    testHistogram(rowCount, columnCount) = {testHistogramAndFeature(rowCount,columnCount).histogram};
                    testFeature(rowCount, columnCount) = {testHistogramAndFeature(rowCount,columnCount).featureData};
                end
            end
            
            save([sampleset_histogramOnly_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_train_sampleSet.mat'], 'trainHistogram', '-v7.3');
            save([sampleset_histogramOnly_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_test_sampleSet.mat'], 'testHistogram', '-v7.3');
            
            save([sampleset_featureOnly_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_train_sampleSet.mat'], 'trainFeature', '-v7.3');
            save([sampleset_featureOnly_path '\user_' num2str(userInvolved(userCount)) '_period_' num2str(period) '_round_' num2str(round) '_test_sampleSet.mat'], 'testFeature', '-v7.3');
            
        end
    end
end

            

    


