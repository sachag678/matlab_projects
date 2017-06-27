function [fprob, prob, xiSum] = forwardBackwardProb(initialProb, transitionProb, emissionProb, observation, time, whichState, states)
%ForwardBackward algorithm
%Calculates the forward prob so the probability of seeing a specfiic
%observation sequence upto a specific time, and the the forward backwards prob which is the probabilty of
%seeing a specific observation at a specfic time from a specific state. It
%also calculates the expected number of transitions from Si to Sj.

%Forwards step
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

%Backwards Step
%initialization
beta = ones(length(states),length(observation));
%iteration
for k=4:-1:1
    for i=1:length(states)
        index = strcmp(emissionProb,observation(k+1));
        beta(i,k) = cell2num(emissionProb(index,i+1))*(transitionProb(i,:)*beta(:,k+1));
    end
end
%sum up the along the columns 
alphaFinal = sum(alpha,1);

%find the forward prob for the specific position
fprob = alphaFinal(time);
%find the probabilty of emitting a observation at a specific time from a
%specific state
%need to fix this equation
%prob = alpha(whichState,time)*beta(whichState,time)/alphaFinal(length(observation));
prob = alpha(whichState,time)*beta(whichState,time)/(alpha(1,time)*beta(1,time)+alpha(2,time)*beta(2,time));

%calculate the expected number of transitions from Si to Sj
for t = 1:length(observation)-1
    for i=1:length(states)
        for j=1:length(states)
            index = strcmp(emissionProb,observation(t+1));
            xi(i,j,t) = alpha(i,t)*transitionProb(i,j)*cell2num(emissionProb(index,j+1))*beta(j,t+1);
        end
    end
end

%sums all the values in every time step
for t = 1:length(observation)-1
    sumPerT(t) = sum(sum(xi(:,:,t)));
end

%calculated the normalized values for xi in each time step
for t = 1:length(observation)-1
    for i=1:length(states)
        for j=1:length(states)
            xi(i,j,t) = xi(i,j,t)/sumPerT(t);
        end
    end
end

%sums over time
xiSum = sum(xi,3);
end

