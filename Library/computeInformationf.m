function [allFw, avg5eer, worstSingle, worstAvg, bestAvg, bestSingle, allavgeer] = computeInformationf(datadirpath)

dirpath = '.';
%datadirpath = '.\exp_result';

allFiles = dir(datadirpath);
allNames = { allFiles.name };
allFw = [];
for fileIndex = 3:(numel(allNames))
    [str,remain]=strtok(allNames{fileIndex},'.');
%     if isempty(remain)
        temp = [];
        peopleROC = [];
        [str,remain]=strtok(allNames{fileIndex},'_');
        while ~isempty(remain)
            [temp,remain]=strtok(remain,'_');
        end
        if ~isempty(temp)
            rountnum = str2double(temp);
            
            newfilepath = [datadirpath allNames{fileIndex}];
            newallFiles = dir(newfilepath);
            newallNames = { newallFiles.name };
            
            totalEER = [];
            allavgeer=[];
            for dataIndex = 3:(numel(newallNames))
                fprintf('Processing File %d:%d\n', dataIndex, numel(newallNames));
                thedatapaht = [newfilepath '\' newallNames{dataIndex}];
                thedataFAR = xlsread(thedatapaht,'FAR');
                thedataFRR = xlsread(thedatapaht,'FRR');
                thedataFW = xlsread(thedatapaht,'FW');

                proportion = thedataFAR ./ thedataFRR;
                proportion(isnan(proportion)) = 1;
                proportion = atan(proportion);
                proportion = proportion .* 180 ./ pi;
                
                angle = [0:1:89];
                
                total_avg_far = [];
                total_avg_frr = [];
                rocCurve = [];
                avg_far = [];
                avg_frr = [];
                eer = [];
                peopleavgeer=[];
                tempavgeer = [];
                time = size(thedataFAR,1);
                peopleNum = time / rountnum;
                %==================================================
                
                for peopleindex = 1:size(thedataFAR,1)
                    sortarray = [thedataFAR(peopleindex,:);thedataFRR(peopleindex,:);proportion(peopleindex,:)];
                    sortarray = sortrows(sortarray',3)';
                    sortfar = sortarray(1,:);
                    sortfrr = sortarray(2,:);
                    sortangle = sortarray(3,:);
                    
                    people_avg_far = [min(sortfar(1,sortangle(1,:)==angle(1)))];
                    people_avg_frr = [min(sortfrr(1,sortangle(1,:)==angle(1)))];
                    
                    
                    if(length(people_avg_far) == 0 )
                        people_avg_far = [0];
                        people_avg_frr = [1];
                    end
                    
                    for index = 2:size(angle,2)
                        [~,numindex] = min(abs(sortangle(1,:)-angle(index)));
                        
                        
                        if(sortangle(1,numindex) > 45)
                            [minfar,ind] = min(sortfar(1,sortangle(1,:)==sortangle(1,numindex)));
                            ind = ind-1+numindex;
                            minfrr = sortfrr(1,ind);
                        else
                            [minfrr,ind] = min(sortfrr(1,sortangle(1,:)==sortangle(1,numindex)));
                            ind = ind-1+numindex;
                            minfar = sortfar(1,ind);
                        end
                        
                        if(sortangle(1,numindex)==angle(index))
                            people_avg_far = [people_avg_far minfar];
                            people_avg_frr = [people_avg_frr minfrr];
                        else
                            if(sortangle(1,numindex)<angle(index))
                                temp = sortangle(1,sortangle(1,:)>angle(index));
                                [~,tempindex] = min(abs(temp(1,:)-angle(index)));
                                
                                if(temp(1,tempindex) > 45)
                                    [secfar,ind] = min(sortfar(1,sortangle(1,:)==temp(1,tempindex)));
                                    secfrr = sortfrr(1,sortfar(1,:)==secfar & sortangle(1,:)==temp(1,tempindex));
                                    secfrr = secfrr(1,1);
                                elseif(length(temp) == 0)
                                    secfar = 1;
                                    secfrr = 0;
                                else
                                    [secfrr,ind] = min(sortfrr(1,sortangle(1,:)==temp(1,tempindex)));
                                    secfar = sortfar(1,sortfrr(1,:)==secfrr & sortangle(1,:)==temp(1,tempindex));
                                    secfar = secfar(1,1);
                                end
                                
                            else
                                temp = sortangle(1,sortangle(1,:)<angle(index));
                                if(length(temp) == 0 )
                                    secfar = 0;
                                    secfrr = 1;
                                else
                                    [~,tempindex] = min(abs(temp(1,:)-angle(index)));
                                    if(temp(1,tempindex) > 45)
                                        [secfar,ind] = min(sortfar(1,sortangle(1,:)==temp(1,tempindex)));
                                        secfrr = sortfrr(1,sortfar(1,:)==secfar & sortangle(1,:)==temp(1,tempindex));
                                        secfrr = secfrr(1,1);
                                    else
                                        [secfrr,ind] = min(sortfrr(1,sortangle(1,:)==temp(1,tempindex)));
                                        secfar = sortfar(1,sortfrr(1,:)==secfrr & sortangle(1,:)==temp(1,tempindex));
                                        secfar = secfar(1,1);
                                    end
                                end
                            end
                            
                            if(isnan(secfar) && isnan(secfrr))
                                thefar = nan;
                                thefrr = nan;
                            else
                                thefrr = ( ((secfrr-minfrr)*minfar )-((secfar-minfar)*minfrr) ) / ( ((secfrr-minfrr)*tan(angle(index)*pi/180)) - (secfar-minfar));
                                thefar = thefrr * tan(angle(index)*pi/180);
                            end
                            
                            people_avg_far = [people_avg_far thefar];
                            people_avg_frr = [people_avg_frr thefrr];
                        end
                    end
                    if(length(sortfar(1,sortangle(1,:) == 90 )) == 0)
                        people_avg_far = [people_avg_far 1];
                        people_avg_frr = [people_avg_frr 0];
                    else
                        people_avg_far = [people_avg_far min(sortfar(1,sortangle(1,:) == 90 ))];
                        people_avg_frr = [people_avg_frr min(sortfrr(1,sortangle(1,:) == 90 ))];
                    end
                    if (people_avg_far(1,90)==0) && (people_avg_far(1,91)==1)
                         people_avg_far(1:91)=0;
                    end   
                    
                    total_avg_far = [total_avg_far; people_avg_far];
                    total_avg_frr = [total_avg_frr; people_avg_frr];
                    rocCurve = [rocCurve;people_avg_far;people_avg_frr];
                end
                temp_people = [mean(total_avg_far,1,'omitnan');mean(total_avg_frr,1,'omitnan')];
                
                %         ==================================================
                
                for timeIndex = 1:time
                    
                    avgeer = total_avg_far(timeIndex,46);
                    
%                     idfrr = thedataFRR(timeIndex,:);
%                     idfar = thedataFAR(timeIndex,:);
%                     
%                     colCount = 1;
%                     
%                     while idfar(colCount)<idfrr(colCount) & colCount < size(idfrr,2)
%                         colCount = colCount + 1;
%                     end
%                     avgeer = 1;
%                     
%                     if (idfrr(colCount)/idfar(colCount)) == 1
%                         avgeer = idfrr(colCount);
%                     elseif  colCount == 1
%                         avgeer = (idfrr(colCount)+idfar(colCount)) / 2;
%                     elseif  idfrr(colCount)==0 && idfar(colCount)==0
%                         avgeer = 0;
%                     elseif (( idfrr(colCount-1) / idfar(colCount-1) ) > 1) && (( idfrr(colCount) / idfar(colCount) ) < 1)
%                         x1 = idfar(colCount-1);
%                         y1 = idfrr(colCount-1);
%                         x2 = idfar(colCount);
%                         y2 = idfrr(colCount);
%                         
%                         t = ( (x2-x1)*y1 - (y2-y1)*x1 )/( (x2 - x1) - (y2 - y1) );
%                         avgeer = t;
%                         
%                     end
                    
                    eer = [eer;avgeer];
                    tempavgeer = [tempavgeer;avgeer];
                    if size(tempavgeer,1) == peopleNum
                        peopleavgeer = [peopleavgeer;mean(tempavgeer)];
                        tempavgeer = [];
                    elseif numel(tempavgeer) > peopleNum
                        error('over tempavgeer');
                    end
                    
                end
                
                totalEER = [totalEER eer];
                pause(0.001);
                A1 = {'EER'};
                xlswrite(thedatapaht,A1,'EER','A1');
                xlswrite(thedatapaht,eer,'EER','B1');
                xlswrite(thedatapaht,rocCurve,'ROC','A1');
                allavgeer = [allavgeer peopleavgeer];
                peopleROC = [peopleROC;temp_people];
                allFw = [allFw transpose(thedataFW(1:49))];
            end
            % calculate avg eer if EER analysis
            %if (size(allavgeer, 2) == 50)
                bestSingle = 10;
                bestAvg = 10;
                worstSingle = 0;
                worstAvg = 0;

                bestSingleIdx = 0;
                bestAvgIdx = 0;
                worstSingleIdx = 0;
                worstAvgIdx = 0;

                avg5eer = zeros(1,48);
                sum5EER = 0;
                for eernum = 1:size(allavgeer,2)
                    if allavgeer(1,eernum) < bestSingle
                        bestSingle = allavgeer(1,eernum);
                        bestSingleIdx = ceil(eernum/5);
                    end
                    if allavgeer(1,eernum) > worstSingle
                        worstSingle = allavgeer(1,eernum);
                        worstSingleIdx = ceil(eernum/5);
                    end
                    if mod(eernum, 5) == 0
                        avg1eer = sum(allavgeer(1,eernum-4:eernum))/5;
                        avg5eer(1,eernum/5) = avg1eer;
                        if avg1eer < bestAvg
                            bestAvg = avg1eer;
                            bestAvgIdx = ceil(eernum/5);
                        end
                        if avg1eer > worstAvg
                            worstAvg = avg1eer;
                            worstAvgIdx = ceil(eernum/5);
                        end
                    end
                end
            %end
            xlswrite([datadirpath '\totalEER.xlsx'],allavgeer,str,'A1');
            xlswrite([datadirpath '\totalEER.xlsx'],avg5eer,str,'A10');
            xlswrite([datadirpath '\totalEER.xlsx'],[worstSingleIdx worstAvgIdx bestAvgIdx bestSingleIdx],str,'A12');
            xlswrite([datadirpath '\totalEER.xlsx'],[worstSingle worstAvg bestAvg bestSingle],str,'A13');
            xlswrite([datadirpath '\totalEER.xlsx'],allFw,'FW','A1');
            xlswrite([datadirpath '\totalEER.xlsx'],peopleROC,['zROC_' str],'A1');
        end
%     end
end

end