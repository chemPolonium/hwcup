clear,clc;
load('tankData.mat');
load('quest2.mat');

actTank = [2 3 4 5];
% tankPosiGain = -tankPosi;
% tankPosiGain(:,[1 6]) = tankPosiGain(:,[1 6]) - tankPosiGain(:,[2 5]);
% 
% actTankPosiGain = tankPosiGain(actTank);
actTankMaxFlow = tankMaxFlow(actTank);

[tankFlow,tankQuantity] = deal(zeros(size(t,1),6));
tankQuantity(1,:) = tankInitQuantity;

totalCg = zeros(size(t,1),3);
totalCg(1,:) = getTotalCg(tankQuantity(1,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';

for i = 1:numel(t)-1
    problem.objective = @(x)norm(getTotalCgFromFlow(tankQuantity(i,:),actTank,x,0,tankPosi,tankSize,aircraftMass,oilDensity)');
    problem.x0 = ones(size(actTank))/6*aircraftFlow(i);
    problem.lb = zeros(size(actTank))';
    problem.ub = actTankMaxFlow';
    problem.Aineq = [];
    problem.bineq = [];
    problem.Aeq = ones(size(actTank));
    problem.Beq = aircraftFlow(i);
    problem.nonlcon = [];
    problem.solver = 'fmincon';
    problem.options = optimoptions('fmincon','Display','none');
    tankFlow(i,:) = fmincon(problem);
    tankQuantity(i+1,:) = tankQuantity(i,:);
    tankQuantity(i+1,actTank) = tankQuantity(i+1,actTank) - tankFlow(i,:)/oilDensity;
    disp(i);
end

for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';
end