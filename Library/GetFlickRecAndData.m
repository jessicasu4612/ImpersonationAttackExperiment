
function [ flickRec, flickData, sampleData, avgData, stdData ] = GetFlickRecAndData( samplingRec, samplingData )
%GETFLICKRECANDDATA Summary of this function goes here
%   Detailed explanation goes here

%���o flick record
% get the flick record
id = samplingRec(1,1);
type_count = samplingRec(1,2);
session_count = samplingRec(1,3);
number_count = samplingRec(1,4);
flick_count = samplingRec(1,7);
% sessionSI = NaN;
% numberSI = NaN;
flickSI = NaN;
sampleNum = size(samplingData,1);
% flickRec = [id type_count session_count number_count flick_count sessionSI numberSI flickSI sampleNum];
flickRec = [id type_count session_count number_count flick_count flickSI sampleNum];

%���o raw data
%get the raw data
timeRec = samplingRec(:,8);
ori_x = samplingData(:,1);
ori_y = samplingData(:,2);
ori_z = samplingData(:,3);
raw_x =  samplingData(:,4);
raw_y = samplingData(:,5);
touchSize = samplingData(:,6);
touchPressure = samplingData(:,7);

%�վ� raw data
% processing raw data

% API 4
% ori_x �վ㥿�t �q 0~-180 �� 0~+180
% change value of ori_x from 0 up to -180 to 0 up to +180
ori_x = -ori_x;
% ori_�B �վ㥿�t
% positive and negative adjusment for ori_y
ori_y = -ori_y;
% �Y ori_z ��V -180 | +180 �����ɽu�A�h�վ� ori_z �� 180 �H�W��range (ex. 180 -180 -179 -178 -> 180 180 181 182)
% if ori_z more than -180 or +180, change ori_z value more than 180 range (ex. 180 -180 -179 -178 -> 180 180 181 182)
if (( sum(ori_z > 90 & ori_z <= 180) > 0 ) & ( sum(ori_z >= -180 & ori_z < 90) > 0 ))
    ori_z(ori_z >= -180 & ori_z < 0) = bsxfun(@plus, ori_z(ori_z >= -180 & ori_z < 0), 360);
end

% �p��XYID startXID startYID endXID endYID
% Calculate XYID startXID startYID endXID endYID
% Flick Data

xyID = (round( round(raw_x./ 80)).* 24) + round((raw_y./80));
startXID = round((raw_x(1)./80));
startYID = round((raw_y(1)./80));
endXID = round((raw_x(end)./80));
endYID = round((raw_y(end)./80));

%�u��1�� sampling �I���ɭԡA�i�H��o���S�x
% if there is just 1 data of the sampling, can be rejected as qualified sample
% calculate the projected_area by multiply radian of ori_x and ori_y
projected_area = bsxfun(@times,cos(degtorad(ori_x)),cos(degtorad(ori_y)));
% for every data, calculate ori_xy
for flickRowCount = 1:numel(ori_x)
    if ori_y(flickRowCount) < 0
        ori_xy(flickRowCount) = (-1)*sqrt( ori_x(flickRowCount)^2 + ori_y(flickRowCount)^2 );
    else
        ori_xy(flickRowCount) = sqrt( ori_x(flickRowCount)^2 + ori_y(flickRowCount)^2 );
    end
end


%��2�� sampling �I���ɭԡA�i�H��o���S�x
% if sampling data more than 2, we can qualified it
if size(samplingData,1) >= 2
	% for every data, calculate distance, velocity, and tangetial
    for flickRowCount = 1:size(samplingData,1)-1
        dist(flickRowCount) = sqrt(( raw_x(flickRowCount+1) - raw_x(flickRowCount) )^2 + ( raw_y(flickRowCount+1) - raw_y(flickRowCount) )^2);
        horizonal_dist(flickRowCount) = ( raw_x(flickRowCount+1) - raw_x(flickRowCount) );
        vertical_dist(flickRowCount) = ( raw_y(flickRowCount+1) - raw_y(flickRowCount) );
        velocity(flickRowCount) = sqrt(( raw_x(flickRowCount+1) - raw_x(flickRowCount) )^2 + ( raw_y(flickRowCount+1) - raw_y(flickRowCount) )^2)/( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        horizonal_velocity(flickRowCount) = ( raw_x(flickRowCount+1) - raw_x(flickRowCount) )/( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        vertical_velocity(flickRowCount) = ( raw_y(flickRowCount+1) - raw_y(flickRowCount) )/( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        velocity_x(flickRowCount) = ( ori_x(flickRowCount+1) - ori_x(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        velocity_y(flickRowCount) = ( ori_y(flickRowCount+1) - ori_y(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        velocity_z(flickRowCount) = ( ori_z(flickRowCount+1) - ori_z(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        velocity_xy(flickRowCount) = ( ori_xy(flickRowCount+1) - ori_xy(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        tengential(flickRowCount) = atand(( raw_y(flickRowCount+1) - raw_y(flickRowCount) )/( raw_x(flickRowCount+1) - raw_x(flickRowCount) ));
    end %end for
    
    %�� flick data ���A���˪��I touch_x touch_y ���S���� (�Ҧp flick ������)
    %�|�ɭP��X�Ӫ� tengential �� NaN�A�h�ݭn�簣 tengential �� NaN ������
	% value NaN will be result if the sampling point x and y, didnt move
	% so, we need to analyze it
    tengential = tengential(~isnan(tengential));
    
	%���ɭ� flick �ӵu�A�ɭP�Ҧ����I touch_x touch_y ���S����
    %�h�N tengential �ন NaN
	% if flick to small --> touch_x and touch_y are not moving
	% set number of tangetial as NaN
    if numel(tengential) == 0
        tengential = NaN;
    end
       
    %���Ҧ���velocity�ɭ�
	% calculate all velocity values
    velocity_x = CompleteValues( velocity_x,timeRec(1:end-1) );
    velocity_y = CompleteValues( velocity_y,timeRec(1:end-1) );
    velocity_z = CompleteValues( velocity_z,timeRec(1:end-1) );
    velocity_xy = CompleteValues( velocity_xy,timeRec(1:end-1) );
   
else
	% set the values as NaN
    dist = NaN;
    horizonal_dist = NaN;
    vertical_dist = NaN;
    velocity = NaN;
    horizonal_velocity = NaN;
    vertical_velocity = NaN;
    velocity_x = NaN;
    velocity_y = NaN;
    velocity_z = NaN;
    velocity_xy = NaN;
    tengential = NaN;
end %end if

twodatafeature = [dist;horizonal_dist;vertical_dist;velocity;horizonal_velocity;vertical_velocity;velocity_x;velocity_y;velocity_z;velocity_xy]';
twodatafeature = [twodatafeature [tengential nan(1,size(twodatafeature,1) - size(tengential,2))]'];
twodatafeature = [twodatafeature;nan(sampleNum-size(twodatafeature,1),size(twodatafeature,2))];

%��3�� sampling �I���ɭԡA�i�H��o���S�x
% if the sampling data more than 3 data
if size(samplingData,1) >= 3
    for flickRowCount = 1:numel(samplingData(:,1))-2
        acceleration(flickRowCount) = ( velocity(flickRowCount+1) - velocity(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        horizontal_acceleration(flickRowCount) = ( horizonal_velocity(flickRowCount+1) - horizonal_velocity(flickRowCount) )/ ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        vertical_acceleration(flickRowCount) = ( vertical_velocity(flickRowCount+1) - vertical_velocity(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        acceleration_x(flickRowCount) = ( velocity_x(flickRowCount+1) - velocity_x(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        acceleration_y(flickRowCount) = ( velocity_y(flickRowCount+1) - velocity_y(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        acceleration_z(flickRowCount) = ( velocity_z(flickRowCount+1) - velocity_z(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
        acceleration_xy(flickRowCount) = ( velocity_xy(flickRowCount+1) - velocity_xy(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
    end
else
    acceleration = NaN;
    horizontal_acceleration = NaN;
    vertical_acceleration = NaN;
    acceleration_x = NaN;
    acceleration_y = NaN;
    acceleration_z = NaN;
    acceleration_xy = NaN;
    curvature = NaN;
    angular_velocity = NaN;
end

%�p�⨤�t��
% Calculated angular velocity
if numel(tengential) >= 2
    for flickRowCount = 1:numel(tengential)-1
        curvature(flickRowCount) = ( tengential(flickRowCount+1) - tengential(flickRowCount) ) / sqrt(( raw_x(flickRowCount+1) - raw_x(flickRowCount) )^2 + ( raw_y(flickRowCount+1) - raw_y(flickRowCount) )^2);
        if isinf(curvature(flickRowCount))
            curvature(flickRowCount) = NaN;
        end
        angular_velocity(flickRowCount) = ( tengential(flickRowCount+1) - tengential(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );
    end
else
    curvature = NaN;
    angular_velocity = NaN;
end

angleVelocity = [curvature;angular_velocity]';

%�p�⨤�[�t��
% Calculated angular acceleration
if numel(angular_velocity) >= 3
    for flickRowCount = 1:numel(angular_velocity)-1
        angular_acceleration(flickRowCount) = ( angular_velocity(flickRowCount+1) - angular_velocity(flickRowCount) ) / ( timeRec(flickRowCount+1) - timeRec(flickRowCount) );     
    end
else
    angular_acceleration = NaN;
end

threedatafeature = [acceleration;horizontal_acceleration;vertical_acceleration;acceleration_x;acceleration_y;acceleration_z;acceleration_xy]';
threedatafeature = [threedatafeature;nan(sampleNum-size(threedatafeature,1),size(threedatafeature,2))];
threedatafeature = [threedatafeature [angleVelocity;nan(sampleNum - size(angleVelocity,1),size(angleVelocity,2))]];
threedatafeature = [threedatafeature [angular_acceleration nan(1,sampleNum - size(angular_acceleration,2))]'];

%ori_x?raw_x?
%Calculate Flick Area
flickarea = CalculateFlickArea(ori_x, ori_y, touchSize);

% get start and end position of raw_x and raw_y
start_position_x = raw_x(1);
start_position_y = raw_y(1);
end_position_x = raw_x(end);
end_position_y = raw_y(end);

% calculate flick data features
horizontal_distance_flick = end_position_x - start_position_x;
vertical_distance_flick = end_position_y - start_position_y;
distance_flick = sqrt(horizontal_distance_flick^2 + vertical_distance_flick^2);
direction = atand(vertical_distance_flick/horizontal_distance_flick);
path = sum(dist);
time = timeRec(end) - timeRec(1);
straightness = path/distance_flick;

flickData = [direction straightness startXID startYID endXID endYID distance_flick horizontal_distance_flick vertical_distance_flick path flickarea time];
sampleData = [xyID twodatafeature(:,[1 2 3 11]) threedatafeature(:,8) twodatafeature(:,[4 5 6]) threedatafeature(:,[1 2 3]) threedatafeature(:,[9 10])];
sampleData = [sampleData touchSize touchPressure ori_x ori_y ori_xy' twodatafeature(:,[7 8 9 10]) threedatafeature(:,[4 5 6 7])];
avgData = [mean(sampleData(:,2:end),1, 'omitnan')];
stdData = [std(sampleData(:,2:end),0,1, 'omitnan')];
end

