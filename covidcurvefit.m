clear all
close all

rawdata = readtable('datatmp.csv');

%Create an anonymous function that takes a value of the exponential decay rate r and returns a vector of differences from the model with that decay rate and the data.

PeakDay = zeros(length(rawdata.Day),1);

for iii = 30:length(rawdata.Day)
   simplemodel = @(r) r(3)./(r(2)* sqrt(2.*pi))* exp(-.5 * ((rawdata.Day(1:iii) -r(1))/r(2)).^2 );
   fun = @(r) simplemodel(r) - rawdata.CasesReported(1:iii);
   
   x0 = [27,50,800];
   x = lsqnonlin(fun,x0)
   
   predictedvalues = simplemodel(x);
   [maxcase,idmax] = max(predictedvalues )
   PeakDay(iii) = idmax; 
end

handle1=figure(1);
plot(rawdata.Day,rawdata.CasesReported,'ko',rawdata.Day,predictedvalues,'b-')
xline(idmax)
legend('Data','Best fit')
xlabel('Day')
ylabel(sprintf('%4.1f * N(%4.1f,%4.1f)',x(3),x(1),x(2)))
xticks(rawdata.Day(1:2:length(rawdata.Day)))
xticklabels(rawdata.Date(1:2:length(rawdata.Date)))
xtickangle(45)
saveas(handle1,'simplefit','png')

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
writetable(splitvars(table(rawdata,predictedvalues,PeakDay)),'data.csv')
