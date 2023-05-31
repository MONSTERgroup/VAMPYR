% function to compare experimental stress strain data to the simulated
% stress strain data. 
% VMM May 2023

function [deltaSTR] = compSTRSTR(strainEXP, stressEXP, strainSIM, stressSIM)

stressEXP_interp = interp1(strainEXP,stressEXP,strainSIM); 

deltaSTR = stressSIM - stressEXP_interp; 