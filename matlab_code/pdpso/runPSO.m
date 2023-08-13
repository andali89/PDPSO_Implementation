% Copyright (c) 2023, An-Da Li. All rights reserved. 
% Please read LICENCE for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com

% This is a Matlab implementation of the PDPSO algorithm, a 
% probability-based discrete particle swarm optimization algorithm, 
% for the product portfolio planning problem. Please refer to the following 
% paper for detail information of  this algorithm:

% Liu, X., & Li, A.-D. (2023). An improved probability-based discrete particle 
% swarm optimization algorithm for solving the product portfolio planning 
% problem. Soft Computing. https://doi.org/10.1007/s00500-023-08530-0 

function [finalsol, iterinfo] = runPSO(evalFunc, probinfo, setup)

maxSwarm= setup.maxSwarm;
maxIter = setup.maxIter;
%mRate = setup.mRate;
wsF = setup.wsF;
wsL = setup.wsL;
% ws = 0.25;
% wp = 0.25;
% wg = 0.5;

maxProdNum = probinfo.maxProdNum;
numLevels = probinfo.numLevels;
numAttri = probinfo.numAttri;
% set empty solution
emptySolution.sol = zeros(maxProdNum, numAttri);
emptySolution.fitness = [];
emptySolution.info = [];
% rankfitness set the worst soltuion as 1, and then 2.3.....
emptySolution.pbestSol = [];
emptySolution.pbestFitness = [];
emptySolution.pbestinfo = [];

% swarm
swarm = repmat(emptySolution, maxSwarm, 1);

% initialization and get finess values
for i = 1 : maxSwarm
    disp(i)
    for j = 1 : numAttri
       swarm(i).sol(:, j) = randi([1 numLevels(j)], maxProdNum, 1); 
    end
    swarm(i).sol = amendSol(swarm(i).sol);    
    [swarm(i).fitness, swarm(i).info] = evalFunc(swarm(i).sol);
    
    swarm(i).pbestSol = swarm(i).sol;
    swarm(i).pbestFitness = swarm(i).fitness;
    swarm(i).pbestinfo = swarm(i).info;
end



[~, ind] = max([swarm.fitness]);
gbest = swarm(ind);

% iterinfo
empty.swarm =[];
empty.gbest = [];
empty.iternum = [];
iterinfo = repmat(empty, maxIter, 1);
iterinfo(1).swarm = swarm;
iterinfo(1).gbest = gbest;
iterinfo(1).iternum = 1;

% begin iterations of PSO
for t = 2 : maxIter
    fprintf('iteration: %d \r\n', t);
    % get the ws, wp and wg values
    ws = wsF + (wsL - wsF) * (t - 1)/ (maxIter - 1);
    wp = (1 - ws) / 3;
    wg = (1 - ws) * 2 /3;
    % update solution (position)    
    for i = 1 : maxSwarm
        swarm(i).sol = solLearning(swarm(i).sol, swarm(i).pbestSol,...
            gbest.sol, ws, wp, wg, numLevels);
    end
    
    % perform mutation
%     for i = 1 : maxSwarm
%         swarm(i).sol = mutation(swarm(i).sol, mRate);
%     end
    
    % get the fitness values of solutions   
    for i = 1 : maxSwarm
       [swarm(i).sol] = amendSol(swarm(i).sol);
        [swarm(i).fitness, swarm(i).info] = evalFunc(swarm(i).sol);
        % update pbests 
        if swarm(i).fitness >= swarm(i).pbestFitness
           swarm(i).pbestSol = swarm(i).sol;
           swarm(i).pbestFitness = swarm(i).fitness;
           swarm(i).pbestinfo = swarm(i).info;
        end
    end
    
    % update gbest
    [mFit, ind] = max([swarm.fitness]);
    if mFit >= gbest.fitness
       gbest = swarm(ind); 
    end
    
    % record the evolutionary information   
    iterinfo(t).swarm = swarm;
    iterinfo(t).gbest = gbest;
    iterinfo(t).iternum = t;
end
    finalsol = iterinfo(maxIter).gbest;
    
    % plot the best function values during the iterations
%     gbests = [iterinfo.gbest];
%     plot((1 : maxIter), [gbests.fitness]);
%     title('Convergence Curve')
%     xlabel('Generation')
%     ylabel('Objective Value')
    
    
end