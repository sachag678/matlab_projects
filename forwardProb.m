function fprob = forwardProb(initialProb, transitionProb, emissionProb, observation, time, states)
%Forward Summary of this function goes here
%Detailed explanation goes here
%forwards step
%initialization step
alpha = zeros(length(states),length(observation));
index = strcmp(emissionProb,observation(1));
for i=1:length(states)
alpha(i,1) = initialProb(i)*cell2num(emissionProb(index,i+1));
end
%iteration step
for j =2:length(observation)
    for i=1:length(states)
        index = strcmp(emissionProb,observation(j));
        alpha(i,j) = cell2num(emissionProb(index,i+1))*(transitionProb(i,:)*alpha(:,j-1));
    end
end

%sum up the along the columns 
alphaFinal = sum(alpha,1);

%find the forward prob for the specific position
fprob = alphaFinal(time);
end

