D=1;C=2;
n=2;
dag = zeros(n,n);

dag(D,C)=1;

ns = [2 1];
dnodes = [1];

bnet = mk_bnet(dag, ns, dnodes); % create bnet with dag and definition of dnodes

bnet.CPD{2} = vonMises_CPD(bnet, 2); %vonMises
bnet.CPD{1} = tabular_CPD(bnet, 1); %tabular

%get data
data = [2 0.5*pi; 1 1.8*pi; 1 1.3*pi; 2 0.2*pi];
ncases = size(data, 1);			% number of data points
cases = cell(n,ncases);		% create an empty table to store the data to be given to the learning algorithm
cases([1:n],:) = num2cell(data(:,:)');	% copy the data

%learn
%learn EM
%engine = jtree_inf_engine(bnet);
%[bnet2, ~, engine] = learn_params_em(engine, cases);

%learn ML
bnet2 = learn_params(bnet, cases);
engine = jtree_inf_engine(bnet2);

evidence = cell(1,n);
evidence{C} = 1.9*pi;

engine = enter_evidence(engine, evidence);

%calculate marginal on a specific node
marg = marginal_nodes(engine, 1);
marg.T

