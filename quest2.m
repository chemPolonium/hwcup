clear,clc;
load('tankData.mat');
load('quest2.mat');

iActTank = logical([0 1 1 0 0 0]);
engineTank = logical([0 1 1 1 1 0]);
% tankPosiGain = -tankPosi;
% tankPosiGain(:,[1 6]) = tankPosiGain(:,[1 6]) - tankPosiGain(:,[2 5]);
% 
% actTankPosiGain = tankPosiGain(actTank);
% actTankMaxFlow = tankMaxFlow(actTank);

[tankFlow,tankQuantity] = deal(zeros(size(t,1),6));
actTank = false(size(t,1),6);
tankQuantity(1,:) = tankInitQuantity;
actTank(1,:) = iActTank;

actTankStateflow = quest2chart('actTank',iActTank,'tankQuantity',tankInitQuantity);

totalCg = zeros(size(t,1),3);
totalCg(1,:) = getTotalCg(tankQuantity(1,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';

for i = 1:numel(t)-1
    problem.objective = @(x)norm(getTotalCgFromFlow(...
        tankQuantity(i,:),...
        iActTank,...
        x,...
        0,...
        tankPosi,...
        tankSize,...
        aircraftMass,...
        oilDensity)');
    problem.x0 = ones(sum(iActTank),1)/6*aircraftFlow(i);
    problem.lb = zeros(sum(iActTank),1);
    problem.ub = tankMaxFlow(iActTank);
    problem.Aineq = [];
    problem.bineq = [];
    actEngineTank = iActTank & engineTank;
    problem.Aeq = double(actEngineTank(iActTank));
    problem.Beq = aircraftFlow(i);
    problem.nonlcon = [];
    problem.solver = 'fmincon';
    problem.options = optimoptions('fmincon','Display','none');
    tankFlow(i,iActTank) = fmincon(problem)';
    tankQuantity(i+1,:) = tankQuantity(i,:);
    tankQuantity(i+1,:) = tankQuantity(i+1,:) - tankFlow(i,:)/oilDensity;
%     step(actTankStateflow,'tankQuantity',tankQuantity(i+1,:));
%     iActTank = actTankStateflow.actTank;
    if rem(i,61) == 0
        iActTank = changeTank(tankQuantity(i+1,:),tankInitQuantity);
    end
    actTank(i+1,:) = iActTank;
    disp(i);
end

for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';
end