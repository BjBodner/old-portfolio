function[f] = Plot_CurrentProfit_And_MarketState(TotalUSD,TotalBTC,NormalizedStateOfMarket,TimeVector)

%for n = 1:5
%TimeVector(n) = datetime('now');
%pause(1)
%end

%TotalUSD = 301:0.1:301+ (n-1)*0.1
%TotalBTC = 0.0301:0.0009:0.0301 + (n-1)*0.0009
%NormalizedStateOfMarket = 100:0.01: 100+(n-1)*0.01

n = length(TotalBTC);
TimeSinceBeggining =   seconds(TimeVector - TimeVector(1));
MinutesSinceBegining = TimeSinceBeggining/60;
            


            ax(1) = subplot(2,1,1);
            title(ax(1),['Current USD Amount:  ' num2str(TotalUSD(n)) '  ,   and BTC Amount  ' num2str(TotalBTC(n))])

            yyaxis(ax(1),'left')
            plot(ax(1),MinutesSinceBegining,TotalUSD,'-bs')
            set(ax(1),'ylim', [0.95*min(TotalUSD),1.05*max(TotalUSD)])
            ylabel(ax(1),({'Total USD Amount'}))
            yyaxis(ax(1),'right')
            plot(ax(1),MinutesSinceBegining,TotalBTC,'-ro')
            set(ax(1),'ylim', [0.95*min(TotalBTC),1.05*max(TotalBTC)])
            ylabel(ax(1),({'Total BTC Amount'}))
            xlabel(ax(1),({'Minutes Since Beginning'}))
            
            PercentOfMyProfits = TotalUSD/TotalUSD(1);
            AverageChangeRate = 3600*(PercentOfMyProfits(n) - PercentOfMyProfits(1))/TimeSinceBeggining(n);
            ax(2) = subplot(2,1,2);
            title(ax(2),['Percent Of USD relative to initial Aamount  ' num2str(TotalUSD(n)/TotalUSD(1)) ', at an average rate of change per hour   ' num2str(AverageChangeRate)])

            yyaxis(ax(2),'left')
            plot(ax(2),MinutesSinceBegining,PercentOfMyProfits,'-bs')
            set(ax(2),'ylim', [0.95*min(PercentOfMyProfits),1.05*max(PercentOfMyProfits)])
            ylabel(ax(2),({'Percent Of initial USD'}))
            yyaxis(ax(2),'right')
            plot(ax(2),MinutesSinceBegining,NormalizedStateOfMarket,'-ro')
            set(ax(2),'ylim', [0.95*min(NormalizedStateOfMarket),1.05*max(NormalizedStateOfMarket)])
            ylabel(ax(2),({'Percent Of initial Market'}))
            xlabel(ax(2),({'Minutes Since Beginning'}))
            
            
            f = getframe(gcf);