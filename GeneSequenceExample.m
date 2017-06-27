%--------------S----T-|
initialProb = [0.4 0.6];
states = ['S' 'T'];
time = 3;
observations = ['A' 'T' 'A' 'C' 'C'];
%---------------|-Pss-Pts--Pst-Ptt-|
transitionProb = [0.7 0.4; 0.3 0.6];
%------------|------S---T---|-----S----T--|-----S---T---|
emssionProb = {'A' 0.4 0.25; 'C' 0.4 0.55; 'T' 0.2 0.2};
%which state are we asking the probabilty of seeing the observation from
whichState = 1; 

[fp, p, ~] = forwardBackwardProb(initialProb,transitionProb, emssionProb,observations,time,whichState, states);
%seq = viterbi(initialProb,transitionProb, emssionProb,observations,states);
[ip, t, e] = BaumWelch(initialProb,transitionProb, emssionProb,observations,states);