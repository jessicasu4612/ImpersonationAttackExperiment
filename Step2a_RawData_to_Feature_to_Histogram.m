clear;
addpath('.\Library\');
type = '';
idName = '';
totalSessionNum = 10;

xlsx_path = '.\Data\XLSX\';
featureData_path = '.\Data\Feature\';
histogram_path = '.\Data\Histogram\';

% create folder if not exist
if not(isfolder(featureData_path))
    mkdir(featureData_path)
end

if not(isfolder(histogram_path))
    mkdir(histogram_path)
end

%read list of victim
victim_list = {};
fid = fopen('.\Data\Victim_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    victim_list = [victim_list; text_line];
end
fclose(fid);

%read list of attacker
attacker_list = {};
fid = fopen('.\Data\Attacker_List.txt');
while ~feof(fid)
    text_line = fgetl(fid);
    attacker_list = [attacker_list; text_line];
end
fclose(fid);

fileID = fopen('.\Data\List_of_Files.txt','w');
%generate filename from Victim List and Attacker List
for victimCount = 1:size(victim_list,1)
    text_victim = cell2mat(victim_list(victimCount));
    pivot1 = strfind(text_victim, '-');
    victim_ID = text_victim(1:pivot1-1);
    fileName_victim = [text_victim '-Victim.xlsx\n'];
    fprintf(fileID,fileName_victim);
    for attackerCount = 1:size(attacker_list,1)
        text_attacker = cell2mat(attacker_list(attackerCount));
        fileName_attacker = [victim_ID '-' text_attacker '-Attacker-v3.xlsx\n'];
        fprintf(fileID,fileName_attacker);
    end
end

fclose(fileID);

fid = fopen('.\Data\List_of_Files.txt');
typeCount = 1;
while ~feof(fid)
    text_line = fgetl(fid);
    fprintf(['Processing file %s to feature data\n'], text_line);
    
    pivot3 = strfind(text_line,'.xlsx');
    fileName = text_line(1:pivot3-1);
    
    currentSI = 1;
    totalFlickData = [];
    totalSampleData = [];
    totalAvgData = [];
    totalStdData = [];
    
    [data, txtdata] = xlsread([xlsx_path text_line],'rawdata');
    data = data(strcmp('UpDown',txtdata(:,2))==1,:); %API4
    data = data(strcmp('click',txtdata(:,8))~=1,:); %API4
    dataRowNum = size(data,1);
    id = data(1,1);  
    
    %record: idCount type session numtask specificNumclick flick time
    userRec = data(:,[1 2 4 5 6 7 8 10]); %API4
    % userRec = data(:,[1 3 4 5 6 7 8 10]); %API2
        
    %data: pitch row azimuth touch_x touch _y size pressure
    userData = data(:,[12 13 14 15 16 17 18]); 
    
    userRec(:,1) = repmat(id,dataRowNum,1);
        
    tempUserRec = [];
	
    %for all session number
    for sessionCount = 1:totalSessionNum
        % get all data that have the same session number with current session number
        userSessionRec = userRec(userRec(:,3)==sessionCount,:);
            
        % get the start time from first data, column 8 
        startTime = userSessionRec(1,8);
        % fill the type (previous value is NaN) with typeCount
        userSessionRec(:,2) = repmat(typeCount,1,size(userSessionRec,1));
        % change time from ms to s
        % get the duration from start time
        userSessionRec(:,8) = bsxfun(@minus,userSessionRec(:,8),startTime)./1000;
        % combine all data
        tempUserRec = [tempUserRec; userSessionRec];
    end
        
	% get all combined data
	userRec = tempUserRec;
        
    %initialize
    %rawdata ���� session, numtask, flick_count �̧ǱƦC
		
	% handle every flick data
	% initialize
	% raw data every session, numtask, flickCount, arrange sequentially
        
    samplingRec = [];
    samplingData = [];
        
	% for every session
    for sessionCount = 1:totalSessionNum
        tempFlickCount = 1;
        tempNumCount = 1;
			
        %get user data for certain session
        userSessionData = userData(userRec(:,3)==sessionCount,:);
        userSessionRec = userRec(userRec(:,3)==sessionCount,:);
			
        % for all sample (the size is the same with the row each file)
        for rowCount = 1:size(userSessionData,1)	%sampleCount
            samplingRec = [samplingRec; userSessionRec(rowCount,:)];
            samplingData = [samplingData; userSessionData(rowCount,:)];
                
            % calculate flick data if there is change, to the next data, or the end of data 
            if (rowCount == size(userSessionData,1) || (userSessionRec(rowCount+1,7) ~= tempFlickCount) || (userSessionRec(rowCount+1,4) ~= tempNumCount))
                if rowCount ~= size(userSessionData,1)
                    % update numCount and flickCount
                    tempNumCount = userSessionRec(rowCount+1,4);
                    tempFlickCount = userSessionRec(rowCount+1,7);
                end
                
                % convert raw data to feature data
                [flickRec, flickData, sampleData, avgData, stdData] = GetFlickRecAndData(samplingRec, samplingData);
                if flickData(:,1) ~=0 & ~isnan(flickData(:,1))
                    % save flick data, refresh the samplingData and samplingRec
                    theRec = [flickRec(1:5) currentSI];
                    totalFlickData = [totalFlickData;theRec flickData];
                            
                    % combine data
                    sampleData = sampleData(~isnan(sampleData(:,2)) & sampleData(:,2)~=0,:);
                    totalSampleData = [totalSampleData;theRec(ones(size(sampleData,1),1),:) sampleData];
                            
                    totalAvgData = [totalAvgData;theRec avgData];
                    totalStdData = [totalStdData;theRec stdData];
                            
                    currentSI = currentSI + 1;
                    samplingData = [];
                    samplingRec = [];
                end % end if
			end % end if
        end % end for rowCount
    end % end for sessionCount
    
    %save to feature data
    excelName = [featureData_path fileName '_featuredata.xlsx'];
    xlswrite(excelName,totalFlickData,'featuredata','A1');
    xlswrite(excelName,totalSampleData,'totalSampleData','A1');
    xlswrite(excelName,totalAvgData,'totalAvgData','A1');
    xlswrite(excelName,totalStdData,'totalStdData','A1');
    
    %next step: histogram
    %to make simple: Put everything in one file
    
    selectedFeatureAll = [3:10 12 13 17:19 22 27 28 29:39 55:65 81:91];
    numOfFlick = 5;
    [bindata,bintextdata] = xlsread([".\Data\binsize.xlsx"],'binsize');
    
    user_touchFeatureData = totalFlickData;
    user_oriFeatureData = totalSampleData;
    user_oriAvgFeatureData = totalAvgData;
    user_oriStdFeatureData = totalStdData;
    
    index = 1;
    samplingEnd = 0;
    histogramPerPeriod = [];
    while ~samplingEnd
        if index + numOfFlick <= size(user_touchFeatureData, 1)
            touchInput = user_touchFeatureData(index:index+numOfFlick - 1, :);
            oriAvgInput = user_oriAvgFeatureData(index:index+numOfFlick - 1, :);
            oriStdInput = user_oriStdFeatureData(index:index+numOfFlick - 1, :);
                
            % fix for ori data (wrong histogram making)
                
            oriInput = [];
            for flickOriCount = 1:5
                % get flickID of other data
                flickID_ori = user_touchFeatureData(flickOriCount+index-1,6);
                
                % oriInput = ori data with the same flick ID as touch data (not only with the same line)
                oriInput_count = user_oriFeatureData(user_oriFeatureData(:,6)==flickID_ori, :);
                oriInput = [oriInput; oriInput_count];
            end
            
            %change here if we allow redundant feature data between
            %histogram (1 feature data used in several histogram)
            index = index + numOfFlick;
                
            %need new name for newRawDataToHistogramMix
            %[histogramOutput, featureBinNum] = RawDataToHistogramMix(selectedFeatureAll, oriInput, touchInput, oriAvgInput, oriStdInput,bindata);
            [histogramAndFeatureData, featureBinNum] = FeatureDataToHistogram(selectedFeatureAll, oriInput, touchInput, oriAvgInput, oriStdInput,bindata);
            histogramPerPeriod = [histogramPerPeriod; histogramAndFeatureData];
    
        else
            samplingEnd = 1;
        end
        
    end
    
    fprintf('Histogram making for user %s finished\n',fileName);
    save([histogram_path fileName '_Histogram.mat'], 'histogramPerPeriod', '-v7.3');
end