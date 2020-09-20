close all

load quest2result.mat

figure('Position',[100 100 500 300])
hold on
plot(t,totalCg,'LineWidth',1.5)
plot(t,aircraftIdealCg);
title('CG')
legend('x','y','z','x0','y0','z0')
exportgraphics(gca,'quest2cg.png')

figure('Position',[650 100 500 300])
hold on
plot(t,aircraftFlow,'LineWidth',1.5)
plot(t,tankFlow)
title('tank flow')
legend('all','1','2','3','4','5','6')
exportgraphics(gca,'quest2tankflow.png')

figure('Position',[100 500 500 300])
plot(t,tankQuantity,'LineWidth',1.5)
title('tank quantity')
legend('1','2','3','4','5','6')
exportgraphics(gca,'quest2tankquantity.png')