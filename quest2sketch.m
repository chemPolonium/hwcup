
actTank = [2 3 5];
actTankPosi = tankPosi(actTank);
actTankMaxFlow = tankMaxFlow(actTank);

x = fmincon(@(x)norm(actTankPosi*x),ones(3,1)/3,[],[],ones(1,3),1,zeros(3,1),actTankMaxFlow');