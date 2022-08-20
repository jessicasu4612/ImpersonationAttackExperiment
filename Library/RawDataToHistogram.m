function [HistogramData] = RawDataToHistogram(Data,bin_start,bin_end,bin_interval)

total = numel(Data(:,1)); %row num
temp = [];

onexout = [bin_start:bin_interval:bin_end-bin_interval];
data = Data;
%  data = data(data(:,1)>=bin_start & data(:,1)<=bin_end);
temp=hist(data,onexout);
%temp = histtemp;
uptemp = temp(2:end)./2;
downtemp = temp(1:(end-1))./2;
temp(1:(end-1)) = temp(1:(end-1)) + uptemp;
temp(2:end) = temp(2:end) + downtemp;
% tempx = tempx./sum(tempx);

% while(bin_start < bin_end)
%     temp = [temp (numel(find(Data(:,1)>bin_start & Data(:,1)<= (bin_start + bin_interval) ))/total)];
%     bin_start = bin_start + bin_interval;
% end

% shiftleftscore = [temp(2:end)./2 0];
% shiftrightscore = [0 temp(1:end-1)./2];
% temp = temp + shiftleftscore + shiftrightscore;
temp = temp./sum(temp);

if numel(temp(isnan(temp))) ~= 0
   temp(isnan(temp)) = 0; 
end

HistogramData = temp;
end

