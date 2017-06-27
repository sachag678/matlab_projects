function [sequence] = viterbi(initialProb, transitionProb, emissionProb, observation, states)
%Viterbi algorithm
%Calculates the most probable sequence of states given a sequence of
%observations

%initialization step
gamma = zeros(length(states),length(observation));
%psi = zeros(length(observation),1);
psi = zeros(length(states),length(observation));
index = strcmp(emissionProb,observation(1));

for i=1:length(states)
    gamma(i,1) = initialProb(i)*cell2num(emissionProb(index,i+1));
end

%iteration step
for j =2:length(observation)
    for i=1:length(states)
        index = strcmp(emissionProb,observation(j));
        gamma(i,j) = cell2num(emissionProb(index,i+1))*max(transitionProb(i,1)*gamma(1,j-1),transitionProb(i,2)*gamma(2,j-1));
        psi(i,j) = argmax([transitionProb(i,1)*gamma(1,j-1) transitionProb(i,2)*gamma(2,j-1)]); % not sure if this is 2D
    end
    %psi(j) = argmax(gamma(:,j));
end

%termination
%sum up the along the columns 
gammaFinal = max(gamma,[],1); % this is not required?
%define psifinal
psiFinal = zeros(length(observation),1);
psiFinal(5) = argmax(gamma(:,5));
%bactrack to find the sequence
for k=4:-1:1  
    psiFinal(k)= psi(psiFinal(k+1),k+1);  
end

sequence = states(psiFinal);
end