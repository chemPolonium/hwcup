close all

save quest3result.mat totalCg tankFlow tankQuantity actTank tankInitQuantity

figure('Position',[100 50 500 300])
hold on
plot(t,totalCg,'LineWidth',1.5)
plot(t,aircraftIdealCg);
title('CG')
legend('x','y','z','x0','y0','z0')
exportgraphics(gca,'quest3cg.png')

figure('Position',[650 50 500 300])
hold on
plot(t,aircraftFlow,'LineWidth',1.5)
plot(t,tankFlow)
title('tank flow')
legend('all','1','2','3','4','5','6')
exportgraphics(gca,'quest3tankflow.png')

figure('Position',[100 450 500 300])
plot(t,tankQuantity,'LineWidth',1.5)
title('tank quantity')
legend('1','2','3','4','5','6')
exportgraphics(gca,'quest3tankquantity.png')