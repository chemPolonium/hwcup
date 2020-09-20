close all

load quest2.mat
load quest2result.mat

figure('Position',[100 100 500 300])
hold on
plot(t,totalCg,'LineWidth',1.5)
plot(t,aircraftIdealCg);
title('center of gravity (CG)')
legend('real x','real y','real z','ideal x','ideal y','ideal z')
xlabel('time / second')
ylabel('CG position / m')
exportgraphics(gca,'quest2cg.png')

figure('Position',[650 100 500 300])
hold on
plot(t,aircraftFlow,'LineWidth',1.5)
plot(t,tankFlow)
title('tank flow')
legend('all engine tank','tank 1','tank 2','tank 3','tank 4','tank 5','tank 6')
xlabel('time / second')
ylabel('tank flow / (kg/s)')
exportgraphics(gca,'quest2tankflow.png')

figure('Position',[100 500 500 300])
plot(t,tankQuantity,'LineWidth',1.5)
title('tank quantity')
legend('tank 1','tank 2','tank 3','tank 4','tank 5','tank 6')
xlabel('time / second')
ylabel('tank quantity / (m^3)')
exportgraphics(gca,'quest2tankquantity.png')