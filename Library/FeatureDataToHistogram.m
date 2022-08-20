function [histogramData, featureBinCount] = FeatureDataToHistogram(selectFeatures, samplingdata, flickdata, avgdata, stdevdata, bindata)
%parameters:
%////////////histogramData: Stored Array
%////////////selectFeatures: user input Raw data will transform to histogram via features in this array
%////////////data

% ori_x ori_y size tou_xyID orix_stab oriy_stab oriz_stab orix_c2 include_angle
% 1 2 3 4 5 6 7 8 9


%student_id 1
%type 2
%session 3
%number_count 4
%flick_count 5
%session_sample_index 6
%flick_sample_index 7
%time_msec 8
%orix_c1 9
%oriy_c1 10
%oriz_c1 11
%raw_x 12
%raw_y 13
%size 14
%orix_c2 15
%include_angle_c1_c2 16
%orix_stab 17
%oriy_stab 18
%oriz_stab 19

samplingdata = samplingdata(:,7:end);
flickdata = flickdata(:,7:end);
avgdata = avgdata(:,7:end);
stdevdata = stdevdata(:,7:end);

featureBinCount = [];
histogramData = [];
featureDataOutput = [];
for index = 1:numel(selectFeatures)
    
    bin = bindata(selectFeatures(index),:);
    bin_start = bin(3);
    bin_end = bin(4);
    bin_interval = bin(5);
    
    
    tempHistogram = [];
    tempFeatureData = [];
    if(selectFeatures(index) == 1)
        %direction 1
        tempHistogram = RawDataToHistogram(flickdata(:,1),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,1);  
    elseif(selectFeatures(index) == 2)
        %straightness 2
        tempHistogram = RawDataToHistogram(flickdata(:,2),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,2);
    elseif(selectFeatures(index) == 3)
        %startX 3
        tempHistogram = RawDataToHistogram(flickdata(:,3),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,3);
%         tempHistogram = RawDataToHistogram_TouchID(flickdata(:,3),flickdata(:,4),bin_start,bin_end,bin_interval);
    elseif(selectFeatures(index) == 4)
        %startY 4
        tempHistogram = RawDataToHistogram(flickdata(:,4),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,4);
%         tempHistogram = RawDataToHistogram_TouchID(flickdata(:,5),flickdata(:,6),bin_start,bin_end,bin_interval);
    elseif(selectFeatures(index) == 5)
        %endX 5
        tempHistogram = RawDataToHistogram(flickdata(:,5),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,5);
    elseif(selectFeatures(index) == 6)
        %endY 6
        tempHistogram = RawDataToHistogram(flickdata(:,6),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,6);
    elseif(selectFeatures(index) == 7)
        %distance_flick 7
        tempHistogram = RawDataToHistogram(flickdata(:,7),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,7);
    elseif(selectFeatures(index) == 8)
        %horizontal_distance_flick 8
        tempHistogram = RawDataToHistogram(flickdata(:,8),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,8);
    elseif(selectFeatures(index) == 9)
        %vertical_distance_flick 9
        tempHistogram = RawDataToHistogram(flickdata(:,9),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,9);
    elseif(selectFeatures(index) == 10)
        %path 10
        tempHistogram = RawDataToHistogram(flickdata(:,10),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,10);
    elseif(selectFeatures(index) == 11)
        %flickarea 11
        tempHistogram = RawDataToHistogram(flickdata(:,11),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,11);
    elseif(selectFeatures(index) == 12)
        %time 12
        tempHistogram = RawDataToHistogram(flickdata(:,12),bin_start,bin_end,bin_interval);
        tempFeatureData = flickdata(:,12);
        
        
    elseif(selectFeatures(index) == 13)
        %touchID 13
        tempHistogram = RawDataToHistogram(samplingdata(:,1),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,1);
%         tempHistogram = RawDataToHistogram_TouchID(samplingdata(:,1),samplingdata(:,2),bin_start,bin_end,bin_interval);
    elseif(selectFeatures(index) == 14)
        %distance 14
        tempHistogram = RawDataToHistogram(samplingdata(:,2),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,2);
    elseif(selectFeatures(index) == 15)
        %horizonal_distance 15
        tempHistogram = RawDataToHistogram(samplingdata(:,3),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,3);
    elseif(selectFeatures(index) == 16)
        %vertical_distance 16
        tempHistogram = RawDataToHistogram(samplingdata(:,4),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,4);
    elseif(selectFeatures(index) == 17)
        %tengential 17
        tempHistogram = RawDataToHistogram(samplingdata(:,5),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,5);
    elseif(selectFeatures(index) == 18)
        %curvature 18
        tempHistogram = RawDataToHistogram(samplingdata(:,6),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,6);
    elseif(selectFeatures(index) == 19)
        %velocity 19
        tempHistogram = RawDataToHistogram(samplingdata(:,7),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,7);
    elseif(selectFeatures(index) == 20)
        %horizontal_velocity 20
        tempHistogram = RawDataToHistogram(samplingdata(:,8),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,8);
    elseif(selectFeatures(index) == 21)
        %vertical_velocity 21
        tempHistogram = RawDataToHistogram(samplingdata(:,9),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,9);
    elseif(selectFeatures(index) == 22)
        %acceleration 22
        tempHistogram = RawDataToHistogram(samplingdata(:,10),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,10);
    elseif(selectFeatures(index) == 23)
        %horizontal_acceleration 23
        tempHistogram = RawDataToHistogram(samplingdata(:,11),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,11);
    elseif(selectFeatures(index) == 24)
        %vertical_acceleration 24
        tempHistogram = RawDataToHistogram(samplingdata(:,12),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,12);
    elseif(selectFeatures(index) == 25)
        %angular_velocity 25
        tempHistogram = RawDataToHistogram(samplingdata(:,13),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,13);
    elseif(selectFeatures(index) == 26)
        %angular_acceleration 26
        tempHistogram = RawDataToHistogram(samplingdata(:,14),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,14);
    elseif(selectFeatures(index) == 27)
        %size 27
        tempHistogram = RawDataToHistogram(samplingdata(:,15),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,15);
    elseif(selectFeatures(index) == 28)
        %pressure 28
        tempHistogram = RawDataToHistogram(samplingdata(:,16),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,16);
    elseif(selectFeatures(index) == 29)
        %orix_c1 29
        tempHistogram = RawDataToHistogram(samplingdata(:,17),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,17);
    elseif(selectFeatures(index) == 30)
        %oriy_c1 30
        tempHistogram = RawDataToHistogram(samplingdata(:,18),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,18);
    elseif(selectFeatures(index) == 31)
        %ori_xy 31
        tempHistogram = RawDataToHistogram(samplingdata(:,19),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,19);
    elseif(selectFeatures(index) == 32)
        %velocity_x 32
        tempHistogram = RawDataToHistogram(samplingdata(:,20),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,20);
    elseif(selectFeatures(index) == 33)
        %velocity_y 33
        tempHistogram = RawDataToHistogram(samplingdata(:,21),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,21);
    elseif(selectFeatures(index) == 34)
        %velocity_z 34
        tempHistogram = RawDataToHistogram(samplingdata(:,22),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,22);
    elseif(selectFeatures(index) == 35)
        %velocity_xy 35
        tempHistogram = RawDataToHistogram(samplingdata(:,23),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,23);
    elseif(selectFeatures(index) == 36)
        %acceleration_x 36
        tempHistogram = RawDataToHistogram(samplingdata(:,24),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,24);
    elseif(selectFeatures(index) == 37)
        %acceleration_y 37
        tempHistogram = RawDataToHistogram(samplingdata(:,25),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,25);
    elseif(selectFeatures(index) == 38)
        %acceleration_z 38
        tempHistogram = RawDataToHistogram(samplingdata(:,26),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,26);
    elseif(selectFeatures(index) == 39)
        %acceleration_xy 39
        tempHistogram = RawDataToHistogram(samplingdata(:,27),bin_start,bin_end,bin_interval);
        tempFeatureData = samplingdata(:,27);
        
        
    elseif(selectFeatures(index) == 40)
        %distance_avg 40
        tempHistogram = RawDataToHistogram(avgdata(:,1),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,1);
    elseif(selectFeatures(index) == 41)
        %horizonal_distance_avg 41
        tempHistogram = RawDataToHistogram(avgdata(:,2),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,2);
    elseif(selectFeatures(index) == 42)
        %vertical_distance_avg 42
        tempHistogram = RawDataToHistogram(avgdata(:,3),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,3);
    elseif(selectFeatures(index) == 43)
        %tengential_avg 43
        tempHistogram = RawDataToHistogram(avgdata(:,4),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,4);
    elseif(selectFeatures(index) == 44)
        %curvature_avg 44
        tempHistogram = RawDataToHistogram(avgdata(:,5),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,5);
    elseif(selectFeatures(index) == 45)
        %velocity_avg 45
        tempHistogram = RawDataToHistogram(avgdata(:,6),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,6);
    elseif(selectFeatures(index) == 46)
        %horizontal_velocity_avg 46
        tempHistogram = RawDataToHistogram(avgdata(:,7),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,7);
    elseif(selectFeatures(index) == 47)
        %vertical_velocity_avg 47
        tempHistogram = RawDataToHistogram(avgdata(:,8),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,8);
    elseif(selectFeatures(index) == 48)
        %acceleration_avg 48
        tempHistogram = RawDataToHistogram(avgdata(:,9),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,9);
    elseif(selectFeatures(index) == 49)
        %horizontal_acceleration_avg 49
        tempHistogram = RawDataToHistogram(avgdata(:,10),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,10);
    elseif(selectFeatures(index) == 50)
        %vertical_acceleration_avg 50
        tempHistogram = RawDataToHistogram(avgdata(:,11),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,11);
    elseif(selectFeatures(index) == 51)
        %angular_velocity_avg 51
        tempHistogram = RawDataToHistogram(avgdata(:,12),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,12);
    elseif(selectFeatures(index) == 52)
        %angular_acceleration_avg 52
        tempHistogram = RawDataToHistogram(avgdata(:,13),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,13);
    elseif(selectFeatures(index) == 53)
        %size_avg 53
        tempHistogram = RawDataToHistogram(avgdata(:,14),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,14);
    elseif(selectFeatures(index) == 54)
        %pressure_avg 54
        tempHistogram = RawDataToHistogram(avgdata(:,15),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,15);
    elseif(selectFeatures(index) == 55)
        %orix_c1_avg 55
        tempHistogram = RawDataToHistogram(avgdata(:,16),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,16);
    elseif(selectFeatures(index) == 56)
        %oriy_c1_avg 56
        tempHistogram = RawDataToHistogram(avgdata(:,17),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,17);
    elseif(selectFeatures(index) == 57)
        %ori_xy_avg 57
        tempHistogram = RawDataToHistogram(avgdata(:,18),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,18);
    elseif(selectFeatures(index) == 58)
        %velocity_x_avg 58
        tempHistogram = RawDataToHistogram(avgdata(:,19),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,19);
      elseif(selectFeatures(index) == 59)
        %velocity_y_avg 59
        tempHistogram = RawDataToHistogram(avgdata(:,20),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,20);
    elseif(selectFeatures(index) == 60)
        %velocity_z_avg 60
        tempHistogram = RawDataToHistogram(avgdata(:,21),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,21);
    elseif(selectFeatures(index) == 61)
        %velocity_xy_avg 61
        tempHistogram = RawDataToHistogram(avgdata(:,22),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,22);
    elseif(selectFeatures(index) == 62)
        %acceleration_x_avg 62
        tempHistogram = RawDataToHistogram(avgdata(:,23),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,23);
    elseif(selectFeatures(index) == 63)
        %acceleration_y_avg 63
        tempHistogram = RawDataToHistogram(avgdata(:,24),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,24);
    elseif(selectFeatures(index) == 64)
        %acceleration_z_avg 64
        tempHistogram = RawDataToHistogram(avgdata(:,25),bin_start,bin_end,bin_interval);
        tempFeatureData = avgdata(:,25);
    elseif(selectFeatures(index) == 65)
        %acceleration_xy_avg 65
        tempHistogram = RawDataToHistogram(avgdata(:,26),bin_start,bin_end,bin_interval);
   
        
        
    elseif(selectFeatures(index) == 66)
        %distance_stdev 66
        tempHistogram = RawDataToHistogram(stdevdata(:,1),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,1);
    elseif(selectFeatures(index) == 67)
        %horizonal_distance_stdev 67
        tempHistogram = RawDataToHistogram(stdevdata(:,2),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,2);
    elseif(selectFeatures(index) == 68)
        %vertical_distance_stdev 68
        tempHistogram = RawDataToHistogram(stdevdata(:,3),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,3);
    elseif(selectFeatures(index) == 69)
        %tengential_stdev 69
        tempHistogram = RawDataToHistogram(stdevdata(:,4),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,4);
    elseif(selectFeatures(index) == 70)
        %curvature_stdev 70
        tempHistogram = RawDataToHistogram(stdevdata(:,5),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,5);
    elseif(selectFeatures(index) == 71)
        %velocity_stdev 71
        tempHistogram = RawDataToHistogram(stdevdata(:,6),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,6);
    elseif(selectFeatures(index) == 72)
        %horizontal_velocity_stdev 72
        tempHistogram = RawDataToHistogram(stdevdata(:,7),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,7);
    elseif(selectFeatures(index) == 73)
        %vertical_velocity_stdev 73
        tempHistogram = RawDataToHistogram(stdevdata(:,8),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,8);
    elseif(selectFeatures(index) == 74)
        %acceleration_stdev 74
        tempHistogram = RawDataToHistogram(stdevdata(:,9),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,9);
    elseif(selectFeatures(index) == 75)
        %horizontal_acceleration_stdev 75
        tempHistogram = RawDataToHistogram(stdevdata(:,10),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,10);
    elseif(selectFeatures(index) == 76)
        %vertical_acceleration_stdev 76
        tempHistogram = RawDataToHistogram(stdevdata(:,11),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,11);
    elseif(selectFeatures(index) == 77)
        %angular_velocity_stdev 77
        tempHistogram = RawDataToHistogram(stdevdata(:,12),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,12);
    elseif(selectFeatures(index) == 78)
        %angular_acceleration_stdev 78
        tempHistogram = RawDataToHistogram(stdevdata(:,13),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,13);
    elseif(selectFeatures(index) == 79)
        %size_stdev 79
        tempHistogram = RawDataToHistogram(stdevdata(:,14),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,14);
    elseif(selectFeatures(index) == 80)
        %pressure_stdev 80
        tempHistogram = RawDataToHistogram(stdevdata(:,15),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,15);
    elseif(selectFeatures(index) == 81)
        %orix_c1_stdev 81
        tempHistogram = RawDataToHistogram(stdevdata(:,16),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,16);
    elseif(selectFeatures(index) == 82)
        %oriy_c1_stdev 82
        tempHistogram = RawDataToHistogram(stdevdata(:,17),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,17);
    elseif(selectFeatures(index) == 83)
        %ori_xy_stdev 83
        tempHistogram = RawDataToHistogram(stdevdata(:,18),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,18);
    elseif(selectFeatures(index) == 84)
        %velocity_x_stdev 84
        tempHistogram = RawDataToHistogram(stdevdata(:,19),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,19);
    elseif(selectFeatures(index) == 85)
        %velocity_y_stdev 85
        tempHistogram = RawDataToHistogram(stdevdata(:,20),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,20);
    elseif(selectFeatures(index) == 86)
        %velocity_z_stdev 86
        tempHistogram = RawDataToHistogram(stdevdata(:,21),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,21);
    elseif(selectFeatures(index) == 87)
        %velocity_xy_stdev 87
        tempHistogram = RawDataToHistogram(stdevdata(:,22),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,22);
    elseif(selectFeatures(index) == 88)
        %acceleration_x_stdev 88
        tempHistogram = RawDataToHistogram(stdevdata(:,23),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,23);
    elseif(selectFeatures(index) == 89)
        %acceleration_y_stdev 89
        tempHistogram = RawDataToHistogram(stdevdata(:,24),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,24);
    elseif(selectFeatures(index) == 90)
        %acceleration_z_stdev 90
        tempHistogram = RawDataToHistogram(stdevdata(:,25),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,25);
    elseif(selectFeatures(index) == 91)
        %acceleration_xy_stdev 91
        tempHistogram = RawDataToHistogram(stdevdata(:,26),bin_start,bin_end,bin_interval);
        tempFeatureData = stdevdata(:,26);
    else
        error('feature index outside!')
    end
    
    featureBinCount(index) = numel(tempHistogram);
    histogramData(index).histogram = tempHistogram;
    histogramData(index).featureData = tempFeatureData;
    
    
end


end




