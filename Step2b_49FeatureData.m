clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\'];

result_path = ['.\Data\Feature\49Feature\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

%read list of filename
fid = fopen("Data\List_of_Files.txt");

selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];

% [bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
% 
% lowerBound = bindata(selectedFeatureAll,3);
% upperBound = bindata(selectedFeatureAll,4);
% interval = upperBound - lowerBound;

basicDataIndex = 6;
selectedFeatureAll = selectedFeatureAll + basicDataIndex;


while ~feof(fid)
    text_line = fgetl(fid);
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);

    fprintf(['Select 49 feature data of %s per flick\n'], fileName);
    
    [user_touchFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'featuredata');
    [user_oriFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'totalSampleData');
    [user_oriAvgFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'totalAvgData');
    [user_oriStdFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'totalStdData');
    
    index = 1;
    samplingEnd = 0;
    featureData = [];
    while ~samplingEnd
        if index <= size(user_touchFeatureData, 1)
            touchInput = user_touchFeatureData(index:index, :);
            oriAvgInput = user_oriAvgFeatureData(index:index, :);
            oriStdInput = user_oriStdFeatureData(index:index, :);
                
            oriInput = [];
            concatenateData = [];
            for flickOriCount = 1:1
                % get flickID of other data
                flickID_ori = user_touchFeatureData(flickOriCount+index-1,6);
                % oriInput = ori data with the same flick ID as touch data (not only with the same line)
                oriInput_count = user_oriFeatureData(user_oriFeatureData(:,6)==flickID_ori, :);
                oriInput = [oriInput; oriInput_count];
                concatenateData = [concatenateData;touchInput(ones(size(oriInput,1),1),:) oriInput(:,7:33) oriAvgInput(ones(size(oriInput,1),1),7:32) oriStdInput(ones(size(oriInput,1),1),7:32)];
            end
            
            featureData = [featureData;concatenateData];
            %change here if we allow redundant feature data between
            %histogram (1 feature data used in several histogram)
            index = index + 1;
        else
            samplingEnd = 1;
        end   
    end
    
    
    excelName = [result_path fileName '_featuredata.xlsx'];

    xlswrite(excelName,featureData(:,1:6),'userFlick','A1');
%     normFeatureData = [];
%     normFeatureData = featureData(:,selectedFeatureAll);
%     normFeatureData = normFeatureData - transpose(lowerBound(:,ones(size(featureData,1),1)));
%     normFeatureData = normFeatureData ./ transpose(interval(:,ones(size(featureData,1),1)));
    xlswrite(excelName,featureData(:,selectedFeatureAll),'featuredata','A1');

end