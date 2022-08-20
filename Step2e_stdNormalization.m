clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Negative\feature\'];

result_path = ['.\Data\Negative\feature\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];

[bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
lowerBound = bindata(selectedFeatureAll,3);
upperBound = bindata(selectedFeatureAll,4);
interval = upperBound - lowerBound;
basicDataIndex = 6;
selectedFeatureAll = selectedFeatureAll + basicDataIndex;

load([feature_path 'totalFlickData.mat'], 'totalFlickData');
load([feature_path 'totalSampleData.mat'], 'totalSampleData');
load([feature_path 'totalAvgData.mat'], 'totalAvgData');
load([feature_path 'totalStdData.mat'], 'totalStdData');

index = 1;
round = 1;
samplingEnd = 0;
featureData = [];
randIndex = randperm(size(totalFlickData, 1));
while ~samplingEnd
    if index <= size(totalFlickData, 1)
        touchInput = totalFlickData(randIndex(1,index):randIndex(1,index), :);
        oriAvgInput = totalAvgData(randIndex(1,index):randIndex(1,index), :);
        oriStdInput = totalStdData(randIndex(1,index):randIndex(1,index), :);
            
        oriInput = [];
        concatenateData = [];
        for flickOriCount = 1:1
            % get flickID of other data
            flickID_ori = totalFlickData(flickOriCount+randIndex(1,index)-1,6);
            % oriInput = ori data with the same flick ID as touch data (not only with the same line)
            oriInput_count = totalSampleData(totalSampleData(:,6)==flickID_ori, :);
            oriInput = [oriInput; oriInput_count];
            concatenateData = [concatenateData;touchInput(ones(size(oriInput,1),1),:) oriInput(:,7:33) oriAvgInput(ones(size(oriInput,1),1),7:32) oriStdInput(ones(size(oriInput,1),1),7:32)];
        end
        
        featureData = [featureData;concatenateData];
        %change here if we allow redundant feature data between
        %histogram (1 feature data used in several histogram)
        if size(featureData(:,1),1)/1600 >= 1
            stringIndex = num2str(round);
            excelName = [result_path 'round' stringIndex '_STDnormFeaturedata.xlsx'];
            userFlick = featureData(:,1:6);
%             xlswrite(excelName,userFlick,'userFlick','A1');
            normFeatureData = featureData(:,selectedFeatureAll);
            normFeatureData = (normFeatureData - repmat(transpose(lowerBound),size(normFeatureData,1),1) ) ./ repmat(transpose(interval),size(normFeatureData,1),1);
            normFeatureData(normFeatureData<0)=0;
            normFeatureData(normFeatureData>1)=1;
%             xlswrite(excelName,normFeatureData,'normFeaturedata','A1');
            meanMatrix = mean(normFeatureData,'omitnan');
            for i = 1:size(normFeatureData(:,1),1)
                for j = 1:size(normFeatureData(1,:),2)
                    if isnan(normFeatureData(i,j))
                        normFeatureData(i,j) = meanMatrix(1,j);
                    end
                end
            end
%             normFeatureData(isnan(normFeatureData))=0;
            excelName = [result_path 'round' stringIndex '_STDnormFeaturedata'];
            save([excelName '_userFlick.mat'], 'userFlick', '-v7.3');
            save([excelName '_normFeatureData.mat'], 'normFeatureData', '-v7.3');
            featureData = [];
            round = round + 1;
        end
        if round == 6
            samplingEnd = 1;
        end
        index = index + 1;
    end   
end

