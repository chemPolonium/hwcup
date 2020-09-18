clear,clc;
load('tankData.mat');
load('quest2.mat');
load('quest1.mat','tankFlow');

% totalCg = flow2cg(tankFlow,tankPosi,tankSize,aircraftMass,oilDensity,tankInitQuantity);
% 
% plot(t,totalCg);

plot(t,tankFlow);
legend('1','2','3','4','5','6');