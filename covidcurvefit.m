clear all
close all

rawdata = readtable('data.csv');

%Create an anonymous function that takes a value of the exponential decay rate r and returns a vector of differences from the model with that decay rate and the data.

simplemodel = @(r) r(3)./(r(2)* sqrt(2.*pi))* exp(-.5 * ((rawdata.Day -r(1))/r(2)).^2 );
fun = @(r) simplemodel(r) - rawdata.CasesReported;

x0 = [27,50,800];
x = lsqnonlin(fun,x0)


handle2=figure(1);
plot(rawdata.Day,rawdata.CasesReported,'ko',rawdata.Day,simplemodel(x),'b-')
legend('Data','Best fit')
xlabel('t')
ylabel(sprintf('%4.1f * N(%4.1f,%4.1f)',x(3),x(1),x(2)))


xticks(rawdata.Day(1:2:length(rawdata.Day)))
xticklabels(rawdata.Date(1:2:length(rawdata.Date)))
xtickangle(45)
saveas(handle2,'simplefit','png')

