function [featureWeight] = sumFeatureWeight(fw, trainHistogram)
    featureWeight = [];
    index = 1;
    for i = 1:size(trainHistogram, 2)
        trainDataSample = trainHistogram (1,i).histogram;
        binSize = size(trainDataSample, 2);
        
        %sum feature weight in each bin of a feature
        featureWeightFeature = sum(fw(index:index+binSize-1));
        featureWeight = [featureWeight featureWeightFeature];
        
        index = index + binSize;
    end
end

