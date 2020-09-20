clear,clc;
load('tankData.mat');
load('quest4.mat');

% problem.objective = @(x)norm(getTotalCg(...
%     x,...
%     0,...
%     tankPosi,...
%     tankSize,...
%     aircraftMass,...
%     oilDensity));
% problem.x0 = tankInitQuantity;
% problem.lb = zeros(6,1);
% problem.ub = tankMaxQuantity';
% problem.Aineq = zeros(1,6) - 1;
% problem.bineq = -sum(aircraftFlow)/oilDensity;
% problem.Aeq = [];
% problem.Beq = [];
% problem.nonlcon = [];
% problem.solver = 'fmincon';
% problem.options = optimoptions('fmincon','Display','none');
% 
% [tankInitQuantity,fval] = fmincon(problem);

iActTank = logical([0 0 0 1 1 1]);

engineTank = logical([0 1 1 1 1 0]);

[tankFlow,tankQuantity] = deal(zeros(size(t,1),6));
actTank = false(size(t,1),6);
tankQuantity(1,:) = tankInitQuantity;
actTank(1,:) = iActTank;

tankQuantityBound = [1 -1 0 0 0 0;0 0 0 0 -1 1];

% actTankStateflow = quest2chart('actTank',iActTank,'tankQuantity',tankInitQuantity);

totalCg = zeros(size(t,1),3);
totalCg(1,:) = getTotalCg(tankQuantity(1,:),aircraftPitch(1),tankPosi,tankSize,aircraftMass,oilDensity)';

tankSwitchPoint = [2340 3000 4423 5000];

tic

for i = 1:numel(t)-1
    problem.objective = @(x)norm(getTotalCgFromFlow(...
        tankQuantity(i,:),...
        iActTank,...
        x,...
        aircraftPitch(i+1),...
        tankPosi,...
        tankSize,...
        aircraftMass,...
        oilDensity)');
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
    problem.options = optimoptions('fmincon','Display','none','Algorithm','sqp');
    tankFlow(i,iActTank) = fmincon(problem)';
    iTankQuantity = tankQuantity(i,:) - tankFlow(i,:)/oilDensity;
    iTankQuantity([2 5]) = iTankQuantity([2 5]) + tankFlow(i,[1 6])/oilDensity;
    tankQuantity(i+1,:) = iTankQuantity;
    if ismember(i,tankSwitchPoint) || any(iTankQuantity(iActTank) < 0.01)
        iActTank = quest4changeTank(tankQuantity(i+1,:));
    end
    actTank(i+1,:) = iActTank;
    disp(i);
end

toc

for i = 1:numel(t)
    totalCg(i,:) = getTotalCg(tankQuantity(i,:),aircraftPitch(i),tankPosi,tankSize,aircraftMass,oilDensity)';
end

totalCgError = vecnorm(totalCg,2,2);

maxTotalCgError = max(totalCgError);

save quest4result.mat totalCg tankFlow tankQuantity actTank totalCgError maxTotalCgError

quest4plot