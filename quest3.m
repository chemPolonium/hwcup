clear,clc;
load('tankData.mat');
load('quest3.mat');

problem.objective = @(x)norm(getTotalCg(...
    x,...
    0,...
    tankPosi,...
    tankSize,...
    aircraftMass,...
    oilDensity) - mean(aircraftIdealCg));
problem.x0 = tankInitQuantity;
problem.lb = zeros(6,1);
problem.ub = tankMaxQuantity';
problem.Aineq = zeros(1,6) - 1;
problem.bineq = -sum(aircraftFlow);
problem.Aeq = [];
problem.Beq = [];
problem.nonlcon = [];
problem.solver = 'fmincon';
problem.options = optimoptions('fmincon','Display','none');

tankInitQuantity = fmincon(problem)';

iActTank = logical([1 1 0 1 0 0]);
engineTank = logical([0 1 1 1 1 0]);

[tankFlow,tankQuantity] = deal(zeros(size(t,1),6));
actTank = false(size(t,1),6);
tankQuantity(1,:) = tankInitQuantity;
actTank(1,:) = iActTank;

tankQuantityBound = [1 -1 0 0 0 0;0 0 0 0 -1 1];

% actTankStateflow = quest2chart('actTank',iActTank,'tankQuantity',tankInitQuantity);

totalCg = zeros(size(t,1),3);
totalCg(1,:) = getTotalCg(tankQuantity(1,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';

tankSwitchPoint = [2000 3300 4250 5200];

tic

for i = 1:numel(t)-1
    problem.objective = @(x)norm(getTotalCgFromFlow(...
        tankQuantity(i,:),...
        iActTank,...
        x,...
        0,...
        tankPosi,...
        tankSize,...
        aircraftMass,...
        oilDensity)' - aircraftIdealCg(min(i+1,7200),:));
    problem.x0 = zeros(sum(iActTank),1) + 1/6*aircraftFlow(i);
    problem.lb = zeros(sum(iActTank),1) + 0.0001;
    problem.ub = tankMaxFlow(iActTank);
    problem.Aineq = tankQuantityBound(:,iActTank);
    problem.bineq = [tankMaxQuantity(2) - tankQuantity(i,2);tankMaxQuantity(5) - tankQuantity(i,5)];
    actEngineTank = iActTank & engineTank;
    problem.Aeq = double(actEngineTank(iActTank));
    problem.Beq = aircraftFlow(i);
    problem.nonlcon = [];
    problem.solver = 'fmincon';
    problem.options = optimoptions('fmincon','Display','none');
    tankFlow(i,iActTank) = fmincon(problem)';
    tankInitQuantity = tankQuantity(i,:) - tankFlow(i,:)/oilDensity;
    tankInitQuantity([2 5]) = tankInitQuantity([2 5]) + tankFlow(i,[1 6])/oilDensity;
    tankQuantity(i+1,:) = tankInitQuantity;
    if ismember(i,tankSwitchPoint) || any(tankInitQuantity(iActTank) < 0.01)
        iActTank = quest3changeTank(tankQuantity(i+1,:));
    end
    actTank(i+1,:) = iActTank;
    disp(i);
end

toc

for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';
end

quest3plot;