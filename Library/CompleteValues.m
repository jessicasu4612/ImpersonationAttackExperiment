function [ data ] = CompleteValues( data,timeRec )
%COMPLETEVALUES Summary of this function goes here
%   Detailed explanation goes here

%解決 velocity flick data 中，因為orientation更新頻率較慢，而造成速度值為 0 的問題
% resolving velocity flick data, the speed could be zero, 

zeroDataCount = find(data == 0);
notZeroDataCount = find(data ~= 0);

%對所有速度值為 0 的點，進行處理
% for all the zero data
for i = 1:numel(zeroDataCount)
    currentPointCount = zeroDataCount(i);
	% get the previous data before and after the zero data
    prevPointCount = PrevPoint(notZeroDataCount,currentPointCount);
    postPointCount = PostPoint(notZeroDataCount,currentPointCount);
    
    
    if (prevPointCount ~= 0) & (postPointCount ~= 0)
        %如果速度值為 0 的點，前後各有速度值不為 0 的點可以參考，則使用內插法補值
		% If the speed is 0 points, before and after each speed value is not 0 points can be reference
        dataA = data(prevPointCount);
        timeA = timeRec(prevPointCount);
        dataB = data(postPointCount);
        timeB = timeRec(postPointCount);
        currentTime = timeRec(currentPointCount);
        
        data(currentPointCount) = dataA + (dataB - dataA)*(currentTime - timeA)/(timeB - timeA);
		
    elseif (prevPointCount == 0) & (postPointCount ~= 0)
        %如果速度值為 0 的點，只有在該點之後有速度值不為 0 的點可以參考，則使用後面的點的速度補值
		% If the speed is 0 points, and the speed after is not 0, but the previous zero, use the post data as reference
        dataB = data(postPointCount);
        data(currentPointCount) = dataB;
		
    elseif (postPointCount == 0) & (prevPointCount ~= 0)
        %如果速度值為 0 的點，只有在該點之前有速度值不為 0 的點可以參考，則使用前面的點的速度補值
		% If the speed is 0 points, and the speed previous is not 0, but the post zero, use the previous data as reference
        dataA = data(prevPointCount);
        data(currentPointCount) = dataA;
    end
end

end % end function CompleteValues

function [ prevPoint ] = PrevPoint( notZeroDataCount, currentDataCount )

prevPoint = 0;

for i = 1:numel(notZeroDataCount)
    if notZeroDataCount(i) < currentDataCount
        prevPoint = notZeroDataCount(i);
    else
        break;
    end
end

end


function [ postPoint ] = PostPoint( notZeroDataCount, currentDataCount )

postPoint = 0;

for i = numel(notZeroDataCount):-1:1
    if notZeroDataCount(i) > currentDataCount
        postPoint = notZeroDataCount(i);
    else
        break;
    end
end

end

