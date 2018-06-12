Validation = 1;  LR= 2; Gamma=3; Epsilon=4;
n = 4;
dag = zeros(n,n);
dag(LR, Validation)=1;
dag(Gamma, Validation)=1;
dag(Epsilon, Validation)=1;

s = RandStream('mcg16807','Seed',0);
RandStream.setGlobalStream(s);

% ns = ones(1, n); %cts nodes have size of 1
% dnodes = E; %define discrete nodes
% cnodes = mysetdiff(1:n, dnodes);%number of continuous nodes
% ns(dnodes) = 2; %node size of the discrete variables
ns = [1 1 1 1];
dnodes = [];

bnet = mk_bnet(dag, ns, dnodes); % create bnet with dag and definition of dnodes

%setup
bnet.CPD{1} = gaussian_CPD(bnet, 1); %gaussian
bnet.CPD{2} = gaussian_CPD(bnet, 2); %gaussian
bnet.CPD{3} = gaussian_CPD(bnet, 3); %gaussian
bnet.CPD{4} = gaussian_CPD(bnet, 4); %gaussian

data = [];
traces = 'simulations.csv';
for i = 1:size(traces,1)
  tmp = load(traces(i,:));
  data = [data ; tmp];
end
ncases = size(data, 1);			% number of data points
cases = cell(n,ncases);		% create an empty table to store the data to be given to the learning algorithm
cases(:,:) = num2cell(data(:,:)');	% copy the data

bnet2 = learn_params(bnet, cases);
engine = jtree_inf_engine(bnet2);

evidence = cell(1,n);
evidence{Validation} = 0.0;

engine = enter_evidence(engine, evidence);

marg = marginal_nodes(engine, Gamma);
marg

marg = marginal_nodes(engine, Epsilon);
marg

marg = marginal_nodes(engine, LR);
marg