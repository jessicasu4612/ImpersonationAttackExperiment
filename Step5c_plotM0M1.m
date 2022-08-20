clear;
rng(2);
addpath('.\Library\');

m0DataPath_feature = '.\Results\M0\feature\';
m1DataPath_feature = '.\Results\M1\feature\';
m0DataPath_hist = '.\Results\M0\histogram\';
m1DataPath_hist = '.\Results\M1\histogram\';

result_path = '.\Results\';

%create folder if not exist
if(~exist([result_path 'Plot_M0M1'],'dir'))
    mkdir([result_path 'Plot_M0M1']);
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

%to match the index of data required
victimShift = 0;
%index shift, because first user start from 3
indexShift = 2 + victimShift;
modelType = 0;

allM0AvgEER = [];
allM1AvgEER = [];
for attackerCount = 1:size(attacker_list, 1)
    attackerName = cell2mat(attacker_list(attackerCount));
    featureM0_totalEER = [];;
    featureM1_totalEER = [];
    histM0_totalEER = [];
    histM0_totalEER = [];
    featureM0_avgEER = [];
    featureM1_avgEER = [];
    histM0_avgEER = [];
    histM1_avgEER = [];

    x = [1:1:10];
    y = [1:1:5];
    fig_path = [result_path 'Plot_M0M1'];

    for victimCount = 1 + victimShift:size(victim_list, 1) + victimShift
        victimName = cell2mat(victim_list(victimCount - victimShift));
        fprintf('Plot for M0 & M1, Attacker:%s vs Victim :%s\n', attackerName, victimName);
        featureM0_EER = xlsread([m0DataPath_feature attackerName '\' victimName '.xlsx'], 'EER');
        featureM1_EER = xlsread([m1DataPath_feature attackerName '\' victimName '.xlsx'], 'EER');
        featureM0_totalEER = [featureM0_totalEER; featureM0_EER];
        featureM1_totalEER = [featureM0_totalEER; featureM1_EER];
        featureM0_avgEER = [featureM0_avgEER; mean(featureM0_EER, 2)];
        featureM1_avgEER = [featureM1_avgEER; mean(featureM1_EER, 2)];

%         histM0_EER = xlsread([m0DataPath_hist attackerName '\' victimName '.xlsx'], 'EER');
%         histM1_EER = xlsread([m1DataPath_hist attackerName '\' victimName '.xlsx'], 'EER');
%         histM0_totalEER = [histM0_totalEER; histM0_EER];
%         histM0_totalEER = [histM0_totalEER; histM1_EER];
%         histM0_avgEER = [histM0_avgEER; mean(histM0_EER, 2)];
%         histM1_avgEER = [histM1_avgEER; mean(histM1_EER, 2)];

        % plot feature M0 & M1 (one attacker vs one victim)
        figure
        plot(y,featureM0_EER(1,:),y,featureM1_EER(1,:))
        title(['EER of feature M0 & M1 Attacker : ' attackerName ' Victim ' victimName])
        xlabel('index of victims')
        ylabel('EER')
        legend({'M0','M1'},'Location','northeast')
        set(gca, 'YGrid', 'on', 'XGrid', 'off')
        if(~exist([fig_path '\feature\' attackerName '\'],'dir'))
            mkdir([fig_path '\feature\' attackerName '\']);
        end
        saveas(gcf,[fig_path '\feature\' attackerName '\' victimName],'png');
        close;

%         % plot histogram M0 & M1 (one attacker vs one victim)
%         figure
%         plot(y,histM0_EER(1,:),y,histM1_EER(1,:))
%         title(['EER of histogram M0 & M1 Attacker : ' attackerName ' Victim ' victimName])
%         xlabel('index of victims')
%         ylabel('EER')
%         legend({'M0','M1'},'Location','northeast')
%         set(gca, 'YGrid', 'on', 'XGrid', 'off')
%         if(~exist([fig_path '\histogram\' attackerName '\'],'dir'))
%             mkdir([fig_path '\histogram\' attackerName '\']);
%         end
%         saveas(gcf,[fig_path '\histogram\' attackerName '\' victimName],'png');
%         close;
% 
%         % plot comparison M0 & M1 (one attacker vs one victim)
%         figure
%         plot(y,featureM0_EER(1,:),y,featureM1_EER(1,:),y,histM0_EER(1,:),y,histM1_EER(1,:))
%         title(['EER of Comparison M0 & M1 Attacker : ' attackerName ' Victim ' victimName])
%         xlabel('index of victims')
%         ylabel('EER')
%         legend({'featureM0','featureM1','histM0','histM1'},'Location','northeast')
%         set(gca, 'YGrid', 'on', 'XGrid', 'off')
%         saveas(gcf,[fig_path '\' attackerName '_' victimName],'png');
%         close;

    end

    % plot feature M0 & M1 (one attacker vs all victim avg EER) 
    figure
    plot(x,featureM0_avgEER,x,featureM1_avgEER)
    title('Feature M0 & M1 : Attacker ', attackerName)
    xlabel('index of victims')
    ylabel('EER')    
    legend({'M0','M1'},'Location','northeast')
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    saveas(gcf,[fig_path '\feature\' attackerName],'png');
%     close;


%     % plot histogram M0 & M1 (one attacker vs all victim avg EER) 
%     figure
%     plot(x,histM0_avgEER,x,histM1_avgEER)
%     title('Histogram M0 & M1 : Attacker ', attackerName)
%     xlabel('index of victims')
%     ylabel('EER')    
%     legend({'M0','M1'},'Location','northeast')
%     set(gca, 'YGrid', 'on', 'XGrid', 'off')
%     saveas(gcf,[fig_path '\histogram\' attackerName],'png');
% %     close;
% 
%     % plot comparison of feature and histogram M0 & M1 (one attacker vs all victim avg EER) 
%     figure
%     plot(x,featureM0_avgEER,x,featureM1_avgEER,x,histM0_avgEER,x,histM1_avgEER)
%     title('Comparison of feature & histogram M0 & M1 : Attacker ', attackerName)
%     xlabel('index of victims')
%     ylabel('EER')    
%     legend({'featureM0','featureM1','histM0','histM1'},'Location','northeast')
%     set(gca, 'YGrid', 'on', 'XGrid', 'off')
%     saveas(gcf,[fig_path '\' attackerName],'png');
%     %     close;
   allM0AvgEER =  [allM0AvgEER; featureM0_avgEER];
   allM1AvgEER =  [allM1AvgEER; featureM1_avgEER];
end
filePath = ['.\Results\'];
xlswrite([filePath 'M0EER.xlsx'], allM0AvgEER, 'M0EER');
xlswrite([filePath 'M1EER.xlsx'], allM1AvgEER, 'M1EER');
