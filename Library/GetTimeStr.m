function [ timeStr ] = GetTimeStr( time )

timeStr = [ datestr(time/60/60/24, 'dd') ' days ' datestr(time/60/60/24, 'HH:MM:SS')];

end

