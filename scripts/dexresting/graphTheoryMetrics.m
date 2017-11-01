% clustering coefficient -> clustering_coef_bu.m
% characteristic pathlength ->
% modularity 
% participation coefficient
% mutual information
% clc; clear; close all

%load matrices 
% load dwpliaveraged
% load talcoords

% 
% matrices = {clde.delta...
% clde.theta...
% clde.alpha...
% clde.beta1...
% clde.beta2...
% clde.gamma...
% clpl.delta...
% clpl.theta...
% clpl.alpha...
% clpl.beta1...
% clpl.beta2...
% clpl.gamma...
% opde.delta...
% opde.theta...
% opde.alpha...
% opde.beta1...
% opde.beta2...
% opde.gamma...
% oppl.delta...
% oppl.theta...
% oppl.alpha...
% oppl.beta1...
% oppl.beta2...
% oppl.gamma};

matrices = {clplR_alpha};



% %threshold all matrices at 50%
% for i = 1:length(matrices)
%     threshM{i} = threshold_proportional(matrices{i},0.5);
% end;
% 
%binarize all matrices
for i = 1:length(matrices)
    binthreshM{i} = weight_conversion(threshM{i},'binarize');
end;

%calculate clustering coefficient (_bu stands for binary undirected)
for i = 1:length(binthreshM)
    matricesCC{i} = clustering_coef_bu(binthreshM{i});
end;

%calculate efficiency bins
for i = 1:length(binthreshM)
    matricesEFF{i} = efficiency_bin(binthreshM{i});
end;

%calculate modularity index
for i = 1:length(binthreshM)
    matricesMOD{i} = modularity_und(binthreshM{i});
end;

%calculate distance matrix
for i = 1:length(binthreshM)
    distMatrix{i} = distance_bin(binthreshM{i});
end;

%calculate characteristic pathlength
for i = 1:length(binthreshM)
    matricesCPL{i} = charpath(distMatrix{i});
end;

%calculate participant coefficient
% first requires community structure
for i = 1:length(binthreshM)
    matricesCommunity{i} = community_louvain(binthreshM{i});
end;

for i = 1:length(binthreshM)
    matricesPCoeff{i} = participation_coef(binthreshM{i},matricesCommunity{i});
end;

%% present some descriptive statistics

delta.open.placebo.clusteringcoefficient = mean(matricesCC{19}(:));
delta.open.placebo.modularity = mean(matricesMOD{19}(:));
delta.open.placebo.characteristicpathlength = mean(matricesCPL{19}(:));
delta.open.placebo.participationcoefficient = mean(matricesPCoeff{19}(:));

delta.open.dex.clusteringcoefficient = mean(matricesCC{13}(:));
delta.open.dex.modularity = mean(matricesMOD{13}(:));
delta.open.dex.characteristicpathlength = mean(matricesCPL{13}(:));
delta.open.dex.participationcoefficient = mean(matricesPCoeff{13}(:));

theta.open.placebo.clusteringcoefficient = mean(matricesCC{20}(:));
theta.open.placebo.modularity = mean(matricesMOD{20}(:));
theta.open.placebo.characteristicpathlength = mean(matricesCPL{20}(:));
theta.open.placebo.participationcoefficient = mean(matricesPCoeff{20}(:));

theta.open.dex.clusteringcoefficient = mean(matricesCC{15}(:));
theta.open.dex.modularity = mean(matricesMOD{15}(:));
theta.open.dex.characteristicpathlength = mean(matricesCPL{15}(:));
theta.open.dex.participationcoefficient = mean(matricesPCoeff{15}(:));
