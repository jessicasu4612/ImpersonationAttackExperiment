%{ 
Function to run experiment train and test
Input:
- featureIndex = Feature index to be used
- victimName = Name of the victim for the experiment
- victimCount = Index of the victim that is being experimented
- indexShift = shift of the victim index when victim ID not started from 1
- victimShift = shift of the victim index to start experiment not from the 1st victim in the list
- attackerName = Name of the attacker for experiment
- modelType = either 0 for building M0 alias training with all standard negative data or 1 for building M1 alias training with attacker data
- filePath = where should be the result written to, put empty if no need to write results.

Output:
- allAvgEER = eer of the victim experiment against each attacker in 5 round
- allFw = feature weight of the model
 %}

function [allAvgEER, allFw] = TrainTestFeature(featureIndex, victimName, victimCount, indexShift, victimShift, attackerName, modelType, filePath)
    %read list of attacker
    if (isempty(attackerName))
        attackerName = 'Aswin';
    end

    % Default type is M0
    if (isempty(modelType))
        modelType = 0;
    end

    rng(2);
    numOfRound = 5;
    classifierList = [1];
    
    %negative data setting
    negativeData_path = '.\Data\Negative\feature\';
    sampleset_path = ['.\Data\SampleSet\feature\'];
    
    numOfTrainPosData = 850;
    numOfTrainNegData = 850;
    numOfTestPosData = 850;
    numOfTestNegData = 850;
    m1AttackerDataRatio = 50/100;
    m1TrainNegData = ceil(m1AttackerDataRatio * numOfTrainNegData);
    m1TrainPosData = numOfTrainNegData - m1TrainNegData;

    Average_AR = [];
    Average_FAR = [];
    Average_FRR = [];
    allFw = [];
    allAvgEER = [];

    for roundCount = 1:numOfRound
        %create set of negative data for training
        load([negativeData_path 'round' num2str(roundCount) '_STDnormFeaturedata_normFeatureData.mat'], 'normFeatureData');
%         trainNegData = [];
        testNegData = [];
    
        negDataSize = size(normFeatureData, 1);
        randHistogramIndex = randperm(numOfTrainNegData);
        
        %create standard negative training set
        if modelType == 1
            trainNegData = normFeatureData(randHistogramIndex(1:m1TrainPosData), :);
%             for negDataNum = 1:m1TrainPosData
%                 trainNegData = [trainNegData; normFeatureData(randHistogramIndex(negDataNum),:)];
%             end
        else
            trainNegData = normFeatureData(randHistogramIndex(1:numOfTrainNegData), :);
%             for negDataNum = 1:numOfTrainNegData
%                 trainNegData = [trainNegData; normFeatureData(randHistogramIndex(negDataNum),:)];
%             end
        end

        for classifierIndex = 1:numel(classifierList)
            classifierNum = classifierList(classifierIndex);
            [penaltyList,hiddenSizesNum] = ClassifierSetParameter(classifierNum);
            
            new_index = victimCount + indexShift - victimShift;
            % if doing M1 experiment add attacker data to standard negative train data
            if modelType == 1
                attacker_filename = [sampleset_path num2str(new_index) '-' attackerName '-Attacker-v3_train_sampleSet_round_' num2str(roundCount) '_normFeatureData.mat'];
                %3-Afif-Attacker-v3_test_sampleSet_round_1_normFeatureData
                load(attacker_filename, 'normFeatureData');
                trainNegData = [trainNegData;normFeatureData(1:m1TrainPosData,:)];
            end

            %load train pos data
            load([sampleset_path victimName '-Victim_train_sampleSet_round_' num2str(roundCount) '_normFeatureData.mat'], 'normFeatureData');
            trainPosData = normFeatureData(1:numOfTrainPosData, :);           

            %training
            %fprintf('Round %d, Training for user %s start\n',roundCount, victimName);
            model = Training_pureSVM_Feature (featureIndex, trainPosData(1:numOfTrainNegData,:), trainNegData(1:numOfTrainNegData,:), classifierNum,penaltyList,hiddenSizesNum);
                
            %testing
            %load negative testing data from attacker
            attacker_filename = [sampleset_path num2str(new_index) '-' attackerName '-Attacker-v3_test_sampleSet_round_' num2str(roundCount) '_normFeatureData.mat'];
            load(attacker_filename, 'normFeatureData');
            testNegData = normFeatureData(1:numOfTestNegData, :);
            attacker_filename = [sampleset_path num2str(new_index) '-' attackerName '-Attacker-v3_test_sampleSet_round_' num2str(roundCount) '_userFlick.mat'];
            load(attacker_filename, 'userData');
            testNegUserData = userData(1:numOfTestNegData, :);           
            
            %load test pos data
            load([sampleset_path victimName '-Victim_test_sampleSet_round_' num2str(roundCount) '_normFeatureData.mat'], 'normFeatureData');
            testPosData = normFeatureData(1:numOfTestPosData, :);           
            load([sampleset_path victimName '-Victim_test_sampleSet_round_' num2str(roundCount) '_userFlick.mat'], 'userData');
            testPosUserData = userData(1:numOfTestPosData, :);           
            
            testDataAns = [ones(numOfTestPosData,1);zeros(numOfTestNegData,1)];
        
            %fprintf('\nTesting for Normal Experiment, user: %s\n', victimName);
            probability = Testing_pureSVM_Feature (featureIndex,testPosData(1:numOfTestNegData,:),testNegData(1:numOfTestNegData,:),model,classifierNum);

%             ???testing???flick number
%             if userFlick(n,6) ??????
%                 ???testDataAns???rating
%             end
            userData = [testPosUserData;testNegUserData];
            temp = userData(1,6);
            endPosData = (userData(size(testPosData,1),6) - temp)/10 + 1;
            upper = 1;
            count = 0;
            avg = 0;
            for i = 2:size(testDataAns,1)
                if userData(i,6) ~= temp
                    lower = i-1;
                    totalNum = lower - upper + 1;
                    % rating for timestamps
                    for j = 1:totalNum
                        if testDataAns(upper+j-1,:) == 1
                            count = count + 1;
                        end                   
                        avg = avg + probability(upper+j-1,:);
                    end
                    avg = avg/totalNum;
                    probability(upper,:) = avg;
                    % delete if timestamps belongs to the same flick
                    if count >= 0.5 * totalNum
                        testDataAns (upper,:) = 1;
                        for j = 2:totalNum
                            testDataAns(upper+j-1,:) = NaN;
                            probability(upper+j-1,:) = NaN;
                        end
                    else
                        testDataAns (upper,:) = 0;
                        for j = 2:totalNum
                            testDataAns(upper+j-1,:) = NaN;
                            probability(upper+j-1,:) = NaN;
                        end
                    end
                    %%%%%%%%%%%%%%%%probability?????????

                    temp = userData(i,6);
                    upper = i;
                    count = 0;
                    avg = 0;
                end
            end
            probability = rmmissing(probability);
            testDataAns = rmmissing(testDataAns);

            %calculate FAR, FRR
            thresholdtable = repmat(0:0.01:1,numel(testDataAns),1);
            datatable = repmat(probability(:,1),1,101);
            testingResult = datatable>thresholdtable;

            correctRate = [];
            FAR = [];
            FRR = [];
            for i = 1:size(thresholdtable,2)
                % size?????????
                [ c, fa, Fr ] = MobileCorrectRate_FAR_FRR(testingResult(:,i),testDataAns,endPosData);   %?????FAR?FRR
                correctRate = [correctRate c];
                FAR = [FAR fa];
                FRR = [FRR Fr];
            end
        
            Average_AR = [Average_AR;correctRate];
            Average_FAR = [Average_FAR;FAR];
            Average_FRR = [Average_FRR;FRR];

            fw = (model.model.SVs' * model.model.sv_coef).^2;
            fw = transpose(fw);
            featureWeight = fw;
%             featureWeight = sumFeatureWeight(fw, trainPosData(:,featureIndex));
            allFw = [allFw;featureWeight];
        end
    end
    allAvgEER = computeInformation1f(Average_FAR, Average_FRR);
    allFw = transpose(allFw);
    % write to file
    if (~isempty(filePath))
        xlswrite(filePath, allFw, 'FW');
        xlswrite(filePath, allAvgEER, 'EER');
        xlswrite(filePath, Average_AR, 'ACR');
        xlswrite(filePath, Average_FAR, 'FAR');
        xlswrite(filePath, Average_FRR, 'FRR');
    end
end    