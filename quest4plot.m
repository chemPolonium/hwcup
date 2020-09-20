close all

load quest4.mat
load quest4result.mat

figure('Position',[100 100 500 300])
hold on
plot(t,totalCg,'LineWidth',1.5)
title('center of gravity (CG)')
legend('x','y','z')
xlabel('time / second');
ylabel('CG position / m');
exportgraphics(gca,'quest4cg.png')

figure('Position',[650 100 500 300])
hold on
plot(t,aircraftFlow,'LineWidth',1.5)
plot(t,tankFlow)
title('tank flow')
legend('all engine tank','tank 1','tank 2','tank 3','tank 4','tank 5','tank 6')
xlabel('time / second');
ylabel('tank flow / (kg/s)');
exportgraphics(gca,'quest4tankflow.png')

figure('Position',[100 500 500 300])
plot(t,tankQuantity,'LineWidth',1.5)
legend('tank 1','tank 2','tank 3','tank 4','tank 5','tank 6')
xlabel('time / second')
ylabel('tank quantity / (m^3)')
exportgraphics(gca,'quest4tankquantity.png')