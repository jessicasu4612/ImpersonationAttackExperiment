addpath('.\Library\');
dirpath = '.';

%csvDirName = 'rawdata_temp';
%xlsxDirName = 'rawdata_ordered_temp';

csvDirName = 'Data\CSV';
xlsxDirName = 'Data\XLSX';

% �s��rawdata_ordered_temp�A�קK�v�T��z�n���ɮ�
% save rawdata_ordered_temp, to avoid collated file
if(~exist([dirpath '\' xlsxDirName],'dir'));
    mkdir([dirpath '\' xlsxDirName]);
end

%���o
% obtain the needed data
files = GetAllFiles([dirpath '\' csvDirName]);

% check wheter if a file is empty or not
% 0 --> is not empty
% 1 --> is empty
emptyCells = cellfun(@isempty,strfind(files,'csv'));

%save the files if the file is not empty
csvFiles = files(~emptyCells);

% for every file
for fileCount = 1:numel(csvFiles)
	%get the file of certain index
    fileName = csvFiles{fileCount};
    
    %Ū����Ƨ�����csv�ɮסA�N�ɮפ��e���C���O�����ɶ��Ƨǫ�Hxlsx�s��
	% reading csv in the folder, 
    [data, txtdata] = xlsread([dirpath '\' csvDirName '\' fileName]);
    
	%sort the data by the time
	% B = data(IX);
	% B is sorted data
	[B,IX] = sort(data(:,10),'ascend');
	
	% save the sorted data
    sortedData = data(IX,:);
    txtdata = txtdata(IX,:);
	
	% make excel file based on every file input
	% make the same file name as csv
    excelName = [dirpath '\' xlsxDirName '\' fileName(1:end-4) '.xlsx'];
    
	% write the data
	xlswrite(excelName,sortedData,'rawdata','A1');
    xlswrite(excelName,txtdata(:,1:2),'rawdata','B1');
    xlswrite(excelName,txtdata(:,8),'rawdata','I1');
    
end
