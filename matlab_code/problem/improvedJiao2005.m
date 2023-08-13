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

% this function is the larger the better
% This objective function is a improved objective function for product 
% portfolio planning revised based on the Jiao (2005) published in 
% IISE Transactions.  Please refer to the  Liu and Li (2023) for details 
% of this objective function.
function [objvalue, info] = improvedJiao2005(solution, data, probinfo)

lowfunc = 0;
objvalue = 0;
% the given LSL value
LSL = probinfo.LSL;
% the beta value for calculating C
beta = probinfo.beta;
% the maximum number of allowed products
maxProdNum = probinfo.maxProdNum;
% mu for calculating Pij
muP = probinfo.muP;
% number of attributes
numAttri = probinfo.numAttri;
% number of attribute levels for each part
numLevels = probinfo.numLevels;
% possible prices of products
prices = probinfo.prices;
% the number of segements
numSeg = probinfo.numSeg;
% the segment size
segSizes = probinfo.segSizes;

% competitive products
numComp = probinfo.numComp;
compProd = probinfo.compProd;
attriIndex = probinfo.attriInd; % attriInd denotes the attribute like color etc.
                                % where different people have different preferences


if nargout == 2
    info.U = zeros(numSeg, maxProdNum);
    info.P = zeros(numSeg, maxProdNum);
    info.C = zeros(maxProdNum, 1);    
end

count = 0;
dataseg = cell(numAttri, 1);
for i = 1 : numAttri
    s = count + 1;
    count = count + numLevels(i);
    dataseg{i} = data(s : count, :);
end
% index for each column
indTime = numSeg + 1;
indVarT = numSeg + 2;
indUw = numSeg + 3;
indCw = numSeg + 4;

% check the products with zero attribute levels
sumZero = sum(solution, 2);
if sum(sumZero) == 0
   objvalue = lowfunc;
   return; 
end
% check if exists repeated products
for i = 2: maxProdNum
    if sumZero(i) ~= 0
        for j = 1 : i - 1
           % the last attribute corresponds to the price, thus is not  
           % considered.
           if isequal(solution(i, 1 : end - 1), solution(j, 1 : end - 1))
              % repeted, do not match the constriant shown in Eq. (1c) 
              objvalue = lowfunc;
              return;
           end
        end
    end
end

% utility caculation
U = zeros(numSeg, maxProdNum);
% the utility of the price of products 
UPrice = zeros(numSeg, maxProdNum);

for j = 1 : maxProdNum
    if isempty(find(solution(j, :) == 0, 1))
        for i = 1 : numSeg
            for k = 1 : numAttri
              % product j, the k th attribute, for segment i
              tempData = dataseg{k}(solution(j, k), :);
              u_temp = tempData(i) * tempData(indUw); 
              U(i, j) = U(i, j) + u_temp;  
              if k == numAttri
                  UPrice(i, j) = u_temp;
              end
            end           
        end
    else
        % The solution is infeasible if any attribute in a product is set
        % as 0
        if sumZero(j) ~= 0
            objvalue = lowfunc;
            return;

        end
    end
end

% calculate utility of competitive products
UComp = zeros(numSeg, numComp);
for j = 1 : numComp
    for i = 1 : numSeg
        for k = 1 : numAttri
            % product j, the k th attribute, for segment i
            tempData = dataseg{k}(compProd(j, k), :);
            u_temp = tempData(i) * tempData(indUw);
            UComp(i, j) = UComp(i, j) + u_temp;
        end
    end    
end
% calculate Pij
expU = exp(muP * U);
expUComp = exp(muP * UComp);
expU(:, sumZero' == 0) = 0;
P = expU ./ (repmat(sum(expU, 2), 1, maxProdNum) + ...
    repmat(sum(expUComp, 2), 1, maxProdNum));


% cost calculation
C = zeros(maxProdNum, 1);

for j = 1 : maxProdNum
    if sumZero(j) == 0
        continue;
    end
    mu = 0;
    sigma2 = 0;
    for k = 1 : numAttri
        % product j, the k th attribute
        if solution(j, k) ~= 0
        tempData = dataseg{k}(solution(j, k), :);
        mu_temp = tempData(indTime) * tempData(indCw);
        mu = mu + mu_temp;
        sigma2 = sigma2 + (tempData(indVarT) * tempData(indCw))^2;         
        end
    end 
    C(j) = beta * exp(3 * sigma2^0.5 /(mu - LSL));
end


for i = 1 : numSeg
    for j = 1 : maxProdNum
        if sumZero(j) ~= 0
            objvalue = objvalue + U(i, j) * P(i,j) * segSizes(i) *...
                prices(solution(j, end))/ C(j);
        end
    end
end

if nargout == 2
    info.U = U;
    info.P = P;
    info.C = C;    
end




sol = solution;

if attriIndex ~= 0
    sol(:, attriIndex) = [];   
end
numAttr2 = size(sol, 2);
if numAttr2 == 1
    return;
end
sol = sortrows(sol,numAttr2, 'descend');
for i = 2 : maxProdNum
    for j = 1 : i - 1
    if all(sol(j, 1: numAttr2 -1) <= sol(i, 1: numAttr2 -1))
        objvalue = objvalue / 10000;
        return;
    elseif sol(j, numAttr2) == sol(i,numAttr2) && ...
            all(sol(i, 1: numAttr2 -1) <= sol(j, 1: numAttr2 -1))
        objvalue = objvalue / 10000;
        return;
    end
    end
end
end

