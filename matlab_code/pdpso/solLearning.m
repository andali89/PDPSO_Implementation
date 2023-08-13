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



function newSol = solLearning(sol, pbestSol, gbestSol, ws, wp, wg, numLevels) 
% This function defines the learning scheme of the PSO algorithm. A
% particle position learns from the pbest and gbest in a probability-based
% strategy.
% input : solution- Sol (m by n matrix) 
%         pbest solution - pbestSol (m by n matrix)
%         gbest solution - gbestSol (m by n matrix)
%         weights - ws, sp, and wg (scalar values)
% output: solution - newSol

[~, n] = size(sol);
newSol = sol;
%numSol = sum(sum(sol, 2) ~= 0);
numP = sum(sum(pbestSol, 2) ~= 0);
numG = sum(sum(gbestSol, 2) ~= 0);
mNum = min([numP, numG]);

% the product k is selected for learning
if mNum > 0  %&& mNum <= numSol
    k = randi(mNum);    
    spg = ws + wp + wg;    
    nws = ws / spg;
    nwp = wp / spg;
    nwg = wg / spg;
    rnum = rand(1, n);    
    % learning from gbest and pbest
    gbestInd = (rnum <= (nws + nwp + nwg));
    newSol(k, gbestInd) = gbestSol(k, gbestInd);
    pbestInd = (rnum <= nws + nwp);
    newSol(k, pbestInd) = pbestSol(k, pbestInd);
    variInd = (rnum <= nws);
    for i = 1 : n
        if variInd(i)         
            newSol(k, i) = randi(numLevels(i) + 1);
            if newSol(k, i) > numLevels(i)
                newSol(k, i) = 0;
            end
        end
    end
else
    disp('else');
end

end

