function [model] = Training_pureSVM(featureSet,trainPosData,trainNegData,classiferNum,penaltyList,hiddenSizesNum)

%take feature data needed (certain featureSet)
trainPosData = trainPosData(:,featureSet);
trainNegData = trainNegData(:,featureSet);
trainData = [trainPosData;trainNegData];

% for dataCount = 1:size(trainData,1)
% 	%combined all histogram (expanded histogram)
%     trainData_expandedHistogram = [trainData_expandedHistogram;MixHistogram(trainData(dataCount,:))];
% end
trainDataAns = [ones(size(trainPosData,1),1);zeros(size(trainNegData,1),1)];

[model,probability] = ClassifierToolsTraining(classiferNum,penaltyList,trainData,trainDataAns,hiddenSizesNum);

end

