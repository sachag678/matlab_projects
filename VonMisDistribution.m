function [ prob ] = VonMisDistribution( input,mu,k )
%Calculates the probabilty of input given mu and k using the 
%von mis distribution
denom = (2*pi*besseli(0,k));
prob = exp(k*cos(input-mu))/denom;

end

