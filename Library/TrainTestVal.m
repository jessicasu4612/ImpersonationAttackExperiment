function EER = TrainTest(FeatureIndex, userName, userCount, index_shift, victim_shift)
    %read list of attacker
    attacker_list = {'Aswin'};
    %fid = fopen('Attacker_List.txt');
    %while ~feof(fid)
    %    text_line = fgetl(fid);
    %    attacker_list = [attacker_list; text_line];
    %end
    %fclose(fid);
    rng(2);
    numOfRound = 5;
    classifierList = [1];
    
    %negative data setting
    negativeData_path = '.\NegativeData\';
    numOfTrainNegData = 60;
    numOfTestNegData = 60;
    sampleset_path = ['.\SampleSetWithValid\'];

    Average_AR = [];
    Average_FAR = [];
    Average_FRR = [];
    for roundCount = 1:numOfRound

        %create set of negative data for training
        load([negativeData_path 'round_' num2str(roundCount) '_test_neg_sampleSet.mat'], 'testNegHistogram');
        trainNegData = [];
        testNegData = [];
    
        negDataSize = size(testNegHistogram, 1);
        randHistogramIndex = randperm(negDataSize);
        
        %create negative training set
        %for negDataNum = 1:numOfTrainNegData/2
        for negDataNum = 1:numOfTrainNegData
            trainNegData = [trainNegData; testNegHistogram(randHistogramIndex(negDataNum),:)];
        end
    
        %create negative testing data
        %attacking experiment, negative testing data is from attacker
        %for negDataNum = numOfTrainNegData+1:numOfTrainNegData+numOfTestNegData
        %    testNegData = [testNegData; testNegHistogram(randHistogramIndex(negDataNum),:)];
        %end
    
        for classifierIndex = 1:numel(classifierList)
            classifierNum = classifierList(classifierIndex);
            [penaltyList,hiddenSizesNum] = ClassifierSetParameter(classifierNum);

            for attackerCount = 1:size(attacker_list, 1)
                fws = [];
                attackerName = cell2mat(attacker_list(attackerCount));

                %load train pos data
                load([sampleset_path userName '-Victim_train_sampleSet_round_' num2str(roundCount) '.mat'], 'trainHistogram');
                trainPosData = trainHistogram;           

                %load test pos data
                load([sampleset_path userName '-Victim_test_sampleSet_round_' num2str(roundCount) '.mat'], 'testHistogram');
                testPosData = testHistogram;
                
                new_index = userCount + index_shift - victim_shift;
                
                %load negative testing data from attacker
                
                attacker_filename = [sampleset_path num2str(new_index) '-' attackerName '-Attacker-v3_test_sampleSet_round_' num2str(roundCount)];
                load(attacker_filename, 'testHistogram');
                testNegData = testHistogram;

                %training
                %fprintf('Round %d, Training for user %s start\n',roundCount, userName);
                model = Training_pureSVM_Hist_Val(FeatureIndex, trainPosData(1:numOfTrainNegData,:), trainNegData(1:numOfTrainNegData,:), testPosData, testNegData, classifierNum,penaltyList,hiddenSizesNum);
                    
                %testing

                testDataAns = [ones(numOfTestNegData,1);zeros(numOfTestNegData,1)];
            
                %fprintf('\nTesting for Normal Experiment, user: %s\n', userName);
                probability = Testing_pureSVM_Hist (FeatureIndex,testPosData(1:numOfTestNegData,:),testNegData(1:numOfTestNegData,:),model,classifierNum);
            
                %calculate FAR, FRR
                thresholdtable = repmat(0:0.01:1,numel(testDataAns),1);
                datatable = repmat(probability(:,1),1,101);
                testingResult = datatable>thresholdtable;

                correctRate = [];
                FAR = [];
                FRR = [];
                for i = 1:size(thresholdtable,2)
                    [ c, fa, Fr ] = MobileCorrectRate_FAR_FRR(testingResult(:,i),testDataAns,size(testPosData, 1));   %?????FAR?FRR
                    correctRate = [correctRate c];
                    FAR = [FAR fa];
                    FRR = [FRR Fr];
                end
            
                Average_AR = [Average_AR;correctRate];
                Average_FAR = [Average_FAR;FAR];
                Average_FRR = [Average_FRR;FRR];

                fw = abs(model.model.SVs' * model.model.sv_coef);
                fw = transpose(fw);
                fws = [fws; fw];
        
%                 featureWeight = sumFeatureWeight(fw, trainHistogram);
%                 [featureWeight_sort, important_bins_rank] = sort(featureWeight, 'descend');
            end
        end
    end
    EER = computeInformation1f(Average_FAR, Average_FRR, []);
end    