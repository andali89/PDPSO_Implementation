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

clc;
clear;
addpath('../Problem');
probinfo =  readprobInfo('probinfo.csv');
probinfo.maxProdNum = 5;

% read the data
data = csvread('data.csv',1, 1);

% bind the objective function
evalFunc = @(x) improvedJiao2005(x, data, probinfo);

% PSO settings
setup.maxSwarm = 100;
setup.maxIter = 200;
%setup.mRate = 0.00;
% the weight of ws during the first iteration and last iteration.
setup.wsF = 0.01;
setup.wsL = 0.01;

randseed = 2;
RandStream.setGlobalStream(RandStream('mt19937ar','seed',randseed));
[finalsolution, iterInfo] = runPSO(evalFunc, probinfo, setup);


figure(1)
iterAvg = zeros(1, setup.maxIter);
for i = 1 : setup.maxIter
    fits = [iterInfo(i).swarm.fitness];
    iterAvg(i) = mean(fits(fits ~= 0));
end
  plot((1 : setup.maxIter), iterAvg);
    title('Convergence Curve')
    xlabel('Generation')
    ylabel('Average Objective Value')
    
figure(2)
iterAvg = zeros(1, setup.maxIter);
for i = 1 : setup.maxIter
    fits = [iterInfo(i).swarm.pbestFitness];
    iterAvg(i) = mean(fits(fits ~= 0));
end
  plot((1 : setup.maxIter), iterAvg);
    title('Convergence Curve of Pbsets')
    xlabel('Generation')
    ylabel('Average Objective Value')
    