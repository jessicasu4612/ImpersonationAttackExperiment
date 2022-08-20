clear;
addpath('.\Library\');
rng(2);

feature_path = ['.\Data\Feature\49Feature\'];

result_path = ['.\Data\Feature\featureDistribution\'];
% create folder if not exist
if not(isfolder(result_path))
    mkdir(result_path)
end

%read list of filename
fid = fopen("Data\List_of_Files.txt");
[bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];
lowerbound = bindata(selectedFeatureAll,3);
upperbound = bindata(selectedFeatureAll,4);
interval = bindata(selectedFeatureAll,5);

while ~feof(fid)
    text_line = fgetl(fid);
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);
    [userFlick] = xlsread([feature_path fileName '_featuredata.xlsx'], 'userFlick');
    [userFeatureData] = xlsread([feature_path fileName '_featuredata.xlsx'], 'featuredata');
    userRecord = [];
    i = 0;

    if not(isfolder([result_path fileName '\']))
        mkdir([result_path fileName '\'])
    end

    for featureIndex = 1:49
        record = [];
        temp = 0;
        featureDistribution = zeros(1,ceil((upperbound(featureIndex,:) - lowerbound(featureIndex,:))/interval(featureIndex,:)) + 2 );
        for dataIndex = 1:size(userFeatureData(:,1))
            if userFeatureData(dataIndex,featureIndex) < lowerbound(featureIndex,:)
                featureDistribution(1,1) = featureDistribution(1,1) + 1;
                if temp ~= [featureIndex userFlick(dataIndex,6) 1]
                    record = [record; featureIndex userFlick(dataIndex,6) 1];
                    if temp(1,1) == featureIndex
                        fprintf("amazing");
                    end
                end
                temp = [featureIndex userFlick(dataIndex,6) 1];
            elseif userFeatureData(dataIndex,featureIndex) > upperbound(featureIndex,:)
                featureDistribution(1,size(featureDistribution(:,2))) = featureDistribution(1,size(featureDistribution(:,2))) + 1;
                if temp ~= [featureIndex userFlick(dataIndex,6) 2]
                    record = [record; featureIndex userFlick(dataIndex,6) 2];
                    if temp(1,1) == featureIndex
                        fprintf("amazing");
                    end
                end
                temp = [featureIndex userFlick(dataIndex,6) 2];
            else
                intervalIndex = 2;
                tempLowerbound = lowerbound(featureIndex,1);
                while~(tempLowerbound>upperbound(featureIndex,1))
                    if userFeatureData(dataIndex,featureIndex) >= tempLowerbound && userFeatureData(dataIndex,featureIndex) < tempLowerbound + interval(featureIndex,1)
                        featureDistribution(1,intervalIndex) = featureDistribution(1,intervalIndex) + 1;
                        i = i + 1;
                        break;
                    end
                    tempLowerbound = tempLowerbound + interval(featureIndex,1);
                    intervalIndex = intervalIndex + 1;
                end
            end
        end
        stringIndex = num2str(featureIndex);
%         if record ~= 0
%             xlswrite([result_path fileName '_outofRangeRecord.xlsx'],record,stringIndex,'A1');
%         end
        userRecord = [userRecord; record];
        %     plot the feature diagram
%         fprintf("Plot user : %s, feature : %d\n",fileName, featureIndex);
%         figure;
%         bar(featureDistribution);
%         title(['Plot user : ' fileName ' Feature : ' stringIndex]);
%         xlabel('data range');
%         ylabel('numbers of data');
%         set(gca, 'YGrid', 'on', 'XGrid', 'off');
%         saveas(gcf,[result_path fileName '\feature_' stringIndex],'png');
%         close;
    end
    xlswrite([result_path fileName '_outofRangeRecord.xlsx'],userRecord,'userRecord','A1');
    ratio = size(userRecord(:,1))./size(userFeatureData(:,1));
    xlswrite([result_path fileName '_outofRangeRecord.xlsx'],ratio,'ratio','A1');
end
