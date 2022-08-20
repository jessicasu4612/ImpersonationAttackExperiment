function [] = ClearExcelProcess()

[~, computer] = system('hostname');
[~, user] = system('whoami');
[~, alltask] = system(['tasklist /S ', computer, ' /U ', user]);
excelPID = regexp(alltask, 'EXCEL.EXE\s*(\d+)\s', 'tokens');
if numel(excelPID) > 0
    fprintf(['wait for excel running, current time: ' datestr(now, 'mmmm dd, yyyy HH:MM:SS PM') '\n']);
    pauseTime = floor(rand()*40)+40;
    fprintf('waiting time: %d\n', pauseTime);
    pause(pauseTime);
    fprintf('waiting time is up\n');
%     for i = 1 : length(excelPID)
%         killPID = cell2mat(excelPID{i});
%         fprintf(['kill process PID: ' killPID '\n']);
%         system(['taskkill /f /pid ', killPID]);
%     end
end

end