close all

save quest4result.mat totalCg tankFlow tankQuantity actTank tankInitQuantity

figure('Position',[100 50 500 300])
hold on
plot(t,totalCg,'LineWidth',1.5)
title('CG')
legend('x','y','z')
exportgraphics(gca,'quest4cg.png')

figure('Position',[650 50 500 300])
hold on
plot(t,aircraftFlow,'LineWidth',1.5)
plot(t,tankFlow)
title('tank flow')
legend('all','1','2','3','4','5','6')
exportgraphics(gca,'quest4tankflow.png')

figure('Position',[100 450 500 300])
plot(t,tankQuantity,'LineWidth',1.5)
title('tank quantity')
legend('1','2','3','4','5','6')
exportgraphics(gca,'quest4tankquantity.png')