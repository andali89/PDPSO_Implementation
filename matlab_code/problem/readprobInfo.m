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

function [probinfo] = readprobInfo(infopath)
%READPROBINFO Summary of this function goes here
%   Detailed explanation goes here
info = csvread(infopath,0, 1);
% the given LSL value
probinfo.LSL = info(1, 1);
probinfo.USL = 4500;
% the beta value for calculating C
probinfo.beta = info(2, 1);
% the maximum number of allowed products
probinfo.maxProdNum = info(3, 1);
% mu for calculating Pij
probinfo.muP = info(4, 1);
% number of attributes
probinfo.numAttri = info(5, 1);
% number of attribute levels for each part
probinfo.numLevels = info(6, 1 : probinfo.numAttri)';
% possible prices of the products
probinfo.prices = info(7, 1 : probinfo.numLevels(end))';
% the number of segements
probinfo.numSeg = info(8, 1);
% the segment size
probinfo.segSizes =  info(9, 1 : probinfo.numSeg)';
% the number of competitive products
probinfo.numComp = info(10, 1);
% the detail of competitive products
probinfo.compProd = info(11 : 10 + probinfo.numComp,1 : probinfo.numAttri);
% the detail of attributeIndex like color etc.
probinfo.attriInd = info(11 + probinfo.numComp, 1:probinfo.numAttri);
probinfo.attriInd(probinfo.attriInd==0)= [];
if isempty(probinfo.attriInd)
    probinfo.attriInd = 0;
end
end

