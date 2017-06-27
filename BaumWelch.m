function [initialProbNew, transProbNew, emissionProbNew] = BaumWelch(initialProb, transitionProb, emissionProb, observation, states)
%BaumWelch 
%Restimates parameters of the model
initialProbNew = initialProb;
transProbNew =transitionProb;
emissionProbNew = emissionProb;

%loop
for loop=1:5
%estimate new initial Prob
for i=1:length(states)
[~, initialProbNew(i),~] = forwardBackwardProb(initialProbNew, transProbNew, emissionProbNew, observation, 1, i, states);
end

%normalize ip
%calculate normalization coefficient
c = 1/(sum(initialProbNew));
%apply coefficient to columns
initialProbNew = c*initialProbNew; 

%new transition prob
for j=1:length(observation)-1
    for i=1:length(states)
        [~, gamma(i,j), ~] = forwardBackwardProb(initialProbNew, transProbNew, emissionProbNew, observation, j, i, states);
    end
end
%calculate gammaSum
gammaSum = sum(gamma,2);
%calculate the xiSum    
[~,~,xiSum] = forwardBackwardProb(initialProbNew, transProbNew, emissionProbNew, observation, i, 1, states);
%solve for new transition Probabilities
for j=1:length(transitionProb)
    for i=1:length(transitionProb)
     transProbNew(i,j) = xiSum(i,j)/gammaSum(j);
    end
end
%need to normalize the prob
%calculate normalization coefficient
for i=1:length(transProbNew)
nC(i) = 1/(sum(transProbNew(:,i)));
end

%apply coefficient to columns
for j=1:length(transProbNew)
    for i=1:length(transProbNew)
    transProbNew(i,j) = nC(j)*transProbNew(i,j);
    end
end

%new emission prob
%calculates new gamma for the all time ti
for j=1:length(observation)
    for i=1:length(states)
        [~, gammaNew(i,j),~] = forwardBackwardProb(initialProbNew, transProbNew, emissionProbNew, observation, j, i, states);
    end
end

%sums gamma over t
gammaSum = sum(gammaNew,2);

%calculates the new emissionprob
for i=1:3
    for j=1:length(states)
        index = observation==emissionProb{i,1};
        sumBk(i,j) = sum(gammaNew(j,index))/gammaSum(j);
    end
end

%need to normalize the prob
%calculate normalization coefficient
for i=1:size(sumBk,2)
nCnew(i) = 1/(sum(sumBk(:,i)));
end

%apply coefficient to columns
for i=1:size(sumBk,2)
    for j=1:length(sumBk)
    emissionProbNew{j,i+1} = nCnew(i)*sumBk(j,i);
    end
end
end
%end loop
end

