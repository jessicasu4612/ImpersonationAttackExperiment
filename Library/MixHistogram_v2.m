function [ histogram ] = MixHistogram( data )
%MIXHISTOGRAM Summary of this function goes here
%v2, remove cell encapsulation for creating expanded Histogram
%edited for new structure on the source (without struct)
histogram = [];
for i = 1:numel(data)
    histogram = [histogram cell2mat(data(i))];
end

end

