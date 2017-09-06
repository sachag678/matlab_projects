function [ prob ] = VonMisDistribution( input,mu,k )
%Calculates the probabilty of input given mu and k using the 
%von mis distribution

prob = exp(k*cos(x-mu))/(2*pi*besseli(0,k));

end

