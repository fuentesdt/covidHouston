%% Gaussian curve fit to local covid-19 data
% Fit a Gaussian curve to local covid case data


%% Local data source 
% use python for webscraping of data to output _datatmp.csv_
%
% python parse.py
%
% * <https://www.click2houston.com/health/2020/04/01/all-the-data-and-charts-that-tell-the-story-of-coronavirus-in-the-houston-area/>
% * <https://e.infogram.com/df363bec-e9b9-4eea-bee6-418fe93ec0ca>
% * <https://github.com/fuentesdt/covidHouston source code>
clear all
close all


datetime(now,'ConvertFrom','datenum')
rawdata = readtable('datatmp.csv');

% work arrays
PeakDay = ones(length(rawdata.Day),1);
Rsquare = NaN(length(rawdata.Day),1);

%% Stability of peak estimate
% plot raw data
handle3=figure(3);
plot(rawdata.Day,rawdata.CasesReported,'ko')
hold

% iteratively add curve fits to raw data starting at day 30
for iii = 30:length(rawdata.Day)
   simplemodel = @(r) r(3)./(r(2)* sqrt(2.*pi))* exp(-.5 * ((rawdata.Day(1:iii) -r(1))/r(2)).^2 );
   fun = @(r) simplemodel(r) - rawdata.CasesReported(1:iii);
   
   x0 = [27,50,800];
   opts1=  optimset('display','off');
   x = lsqnonlin(fun,x0,[],[],opts1);
   
   PredictedValues = simplemodel(x);
   [maxcase,idmax] = max(PredictedValues );
   PeakDay(iii) = idmax; 
   Rsquare(iii) = 1 - sum((rawdata.CasesReported(1:iii) - PredictedValues ).^2)/sum((rawdata.CasesReported(1:iii) - mean(rawdata.CasesReported)).^2);

   plot(rawdata.Day(1:iii),PredictedValues,'b-')
   xline(idmax);
end
legend('Data','Best fit')
xlabel('Day')
ylabel(sprintf('%4.1f * N(%4.1f,%4.1f)',x(3),x(1),x(2)))
title(sprintf('%4.2f < Rsquare < %4.2f ',min(Rsquare),max(Rsquare) ))
xticks(rawdata.Day(1:2:length(rawdata.Day)))
xticklabels(rawdata.Date(1:2:length(rawdata.Date)))
xtickangle(45)
saveas(handle3,'evolution','png')


%% Current Gaussian curve fit to local data
% plot the curve fit with all available data
handle1=figure(1);
plot(rawdata.Day,rawdata.CasesReported,'ko',rawdata.Day,PredictedValues,'b-')
xline(idmax);
legend('Data','Best fit')
xlabel('Day')
ylabel(sprintf('%4.1f * N(%4.1f,%4.1f)',x(3),x(1),x(2)))
title(sprintf('Rsquare = %4.2f ',Rsquare(length(Rsquare)) ))
xticks(rawdata.Day(1:2:length(rawdata.Day)))
xticklabels(rawdata.Date(1:2:length(rawdata.Date)))
xtickangle(45)
saveas(handle1,'simplefit','png')

%% Peak day change with updated data
% plot the sensitivity of the peak day to the available data starting from day 30
handle2=figure(2);
plot(rawdata.Day,PeakDay,'k')
xlabel('Day')
ylabel('Peak Day')
xticks(rawdata.Day(1:2:length(rawdata.Day)))
xticklabels(rawdata.Date(1:2:length(rawdata.Date)))
xtickangle(45)
yticks(rawdata.Day(1:2:length(rawdata.Day)))
yticklabels(rawdata.Date(1:2:length(rawdata.Date)))
ytickangle(45)
grid on
saveas(handle2,'peakday','png')

% write table
writetable(splitvars(table(rawdata,PredictedValues,PeakDay)),'data.csv')


%% WIP - bokeh interactive plot
%
% <html>
% <iframe src="bokeh/flowers.html"
%     sandbox="allow-same-origin allow-scripts"
%     width="100%"
%     height="500"
%     scrolling="no"
%     seamless="seamless"
%     frameborder="0">
% </iframe>
% </html>
