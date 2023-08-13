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

% This function amend the solution, which put the [0, 0] product 
% to the last part of the coded string.
% input : solution - sol (m by n matrix) 
% output: solution - newsol (m by n matrix)

function [ newSol ] = amendSol( sol )
[m, n] = size(sol);
sumZeros = zeros(1, m) + 1;

for i = 1:m
   if ~isempty(find(sol(i, :) == 0, 1))
      sol(i, :) = zeros(1, n);
      sumZeros(i) = 0;
   end
end

%newSol = [sol(sumZeros ~=0, :); sol(sumZeros == 0, :)];
% Sort solutions
sumNum = sum(sol, 2);
[~, Ind] = sort(sumNum, 'descend');
newSol = sol(Ind, :);


end

