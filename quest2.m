clear,clc;
load('tankData.mat');
load('quest2.mat');

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

tankSwitchPoint = [2500 3500 4500 5200];

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
        oilDensity)' - aircraftIdealCg(min(i+300,7200),:));
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
    iTankQuantity = tankQuantity(i,:) - tankFlow(i,:)/oilDensity;
    iTankQuantity([2 5]) = iTankQuantity([2 5]) + tankFlow(i,[1 6])/oilDensity;
    tankQuantity(i+1,:) = iTankQuantity;
    if ismember(i,tankSwitchPoint) || any(iTankQuantity(iActTank) < 0.01)
        iActTank = quest2changeTank(tankQuantity(i+1,:),tankInitQuantity);
    end
    actTank(i+1,:) = iActTank;
    disp(i);
end

toc

for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),0,tankPosi,tankSize,aircraftMass,oilDensity)';
end

totalCgError = vecnorm(totalCg - aircraftIdealCg,2,2);

maxTotalCgError = max(totalCgError);

save quest2result.mat totalCg tankFlow tankQuantity actTank totalCgError maxTotalCgError

quest2plot