function [model] = Training_pureSVM_Hist_Val(featureSet,trainPosData,trainNegData,testPosData,testNegData,classiferNum,penaltyList,hiddenSizesNum)

%take feature data needed (certain featureSet)
trainPosData = trainPosData(:,featureSet);
trainNegData = trainNegData(:,featureSet);
trainData = [trainPosData;trainNegData];

valPosData = testPosData((size(trainPosData,1)+1):size(testPosData,1),featureSet);
valNegData = testNegData((size(trainNegData,1)+1):size(testNegData,1),featureSet);
valData = [valPosData; valNegData];

trainData_expandedHistogram = [];
for dataCount = 1:size(trainData,1)
	%combined all histogram (expanded histogram)
    trainData_expandedHistogram = [trainData_expandedHistogram;MixHistogram(trainData(dataCount,:))];
end

valData_expandedHistogram = [];
for dataCount = 1:size(valData,1)
	%combined all histogram (expanded histogram)
    valData_expandedHistogram = [valData_expandedHistogram;MixHistogram(valData(dataCount,:))];
end

trainDataAns = [ones(size(trainPosData,1),1);zeros(size(trainNegData,1),1)];

valDataSize = size(testNegData,1) - size(trainNegData,1);
valDataAns = [ones(valDataSize,1);zeros(valDataSize,1)];

[model,probability] = ClassifierToolsTrainingVal(classiferNum,penaltyList,trainData_expandedHistogram,trainDataAns,valData_expandedHistogram,valDataAns,hiddenSizesNum);

end

