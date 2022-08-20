clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\49Feature\'];

result_path = ['.\Data\Feature\normalized49Feature\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

%read list of filename
fid = fopen("Data\List_of_Files.txt");

selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];
[bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
% bindata = bindata(selectedFeatureAll,:);
lowerBound = bindata(selectedFeatureAll,3);
upperBound = bindata(selectedFeatureAll,4);
interval = upperBound - lowerBound;

basicDataIndex = 6;
selectedFeatureAll = selectedFeatureAll + basicDataIndex;

% fprintf('Find the upperbound, lowerbound and interval\n');
% uppperbound = [];
% lowerbound = [];
% while ~feof(fid)
%     text_line = fgetl(fid);
%     pivot3 = strfind(text_line,'.xlsx');
%     fileName = text_line(1:pivot3-1);
%     
%     [userFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'featuredata');
%     
%     tempUppperbound = [];
%     tempLowerbound = [];
%     for featureIndex = 1:49
%         tempMax = userFeatureData(1,featureIndex);
%         tempMin = userFeatureData(1,featureIndex);
%         for dataIndex = 1:size(userFeatureData(:,1))
%             if userFeatureData(dataIndex,featureIndex) < tempMin
%                 tempMin = userFeatureData(dataIndex,featureIndex);
%             end
%             if userFeatureData(dataIndex,featureIndex) > tempMax
%                 tempMax = userFeatureData(dataIndex,featureIndex);
%             end
%         end
%         tempUppperbound = [tempUppperbound,tempMax];
%         tempLowerbound = [tempLowerbound,tempMin];
%     end
% 
%     uppperbound = [uppperbound;tempUppperbound];
%     lowerbound = [lowerbound;tempLowerbound];
% end
% 
% uppperbound = max(uppperbound);
% lowerbound = min(lowerbound);
% interval = [];
% interval = uppperbound - lowerbound;

% (data - min) / interval

fprintf('Normalize 49 feature data\n');
fid = fopen("Data\List_of_Files.txt");
while ~feof(fid)
    text_line = fgetl(fid);
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);
    fprintf(['Normalize file : %s \n'], fileName);

    [userFlick] = xlsread([feature_path fileName '_featuredata.xlsx'], 'userFlick');
    [userFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'featuredata');
    

    userFeatureData = (userFeatureData - repmat(transpose(lowerBound),size(userFeatureData,1),1) ) ./ repmat(transpose(interval),size(userFeatureData,1),1);
    userFeatureData(userFeatureData<0)=0;
    userFeatureData(userFeatureData>1)=1;
    meanMatrix = mean(userFeatureData,'omitnan');
    for i = 1:size(userFeatureData(:,1),1)
        for j = 1:size(userFeatureData(1,:),2)
            if isnan(userFeatureData(i,j))
                userFeatureData(i,j) = meanMatrix(1,j);
            end
        end
    end
    excelName = [result_path fileName '_normFeaturedata.xlsx'];
    xlswrite(excelName,userFlick,'userFlick','A1');
    xlswrite(excelName,userFeatureData,'normFeaturedata','A1');
end

% xlswrite(['.\Data\Feature\newInterval.xlsx'],upperBound,'upperbound','A1');
% xlswrite(['.\Data\Feature\newInterval.xlsx'],lowerBound,'lowerbound','A1');
% xlswrite(['.\Data\Feature\newInterval.xlsx'],interval,'interval','A1');
