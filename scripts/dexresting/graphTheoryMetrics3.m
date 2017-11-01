% clustering coefficient -> clustering_coef_bu.m
% characteristic pathlength ->
% modularity 
% participation coefficient
% mutual information 
clc; clear; close all

%load matrices 
% load dwpliaveraged
% load talcoords
fdir   =  [pwd '/'];          %'/local/Dropbox/Tasks/dexrest/';(genpath(pwd));
currentDir = fdir;
addpath(genpath(currentDir));
fnames = {'dwplibysubject' 'orthpowbysubject' 'powbysubject'};
cond   = {'oppl' 'clpl' 'opde' 'clde'};
freqs  = {'delta' 'theta' 'alpha' 'beta1' 'beta2' 'gamma'};
thrpr  = 0.1:0.025:0.5;
lthrpr = length(thrpr);

%% 
for i = 1:3 % data type
    df1     = load(char(strcat(fdi, fnames(i), '.mat')));
    
    for j = 1:4 % conditions
        for k = 1:6 % Frequencies
            
            df1.(cond{j}).(freqs{k}) = reshape(df1.(cond{j}).(freqs{k}), [18 18 28]);
            df2 = abs(df1.(cond{j}).(freqs{k}));
            
            matricesCC = zeros(18, 28);
            matricesEFF = zeros(28,1);
            matricesMOD = zeros(18, 28);
            matricesCPL = zeros(28,1);
            matricesCommunity = zeros(18, 28);
            matricesPCoeff = zeros(18, 28);
            
            for sx = 1:28 % subjects
                for pr = thrpr % thresholds
                    threshM(:,:,sx) = threshold_proportional(df2(:,:,sx),pr);
    
                    %binarize all matrices
                    binthreshM(:,:,sx) = weight_conversion(threshM(:,:,sx),'normalize');
                    %calculate clustering coefficient (_bu stands for binary undirected)
                    matricesCC(:,sx) = clustering_coef_bu(binthreshM(:,:,sx))/lthrpr + matricesCC(:,sx);
                    %calculate efficiency bins
                    matricesEFF(sx) = efficiency_bin(binthreshM(:,:,sx))/lthrpr + matricesEFF(sx);
                    %calculate modularity index
                    matricesMOD(:,sx) = modularity_und(binthreshM(:,:,sx))/lthrpr + matricesMOD(:,sx);
                    %calculate distance matrix
                    distMatrix(:,:,sx) = distance_bin(binthreshM(:,:,sx));
                    %calculate characteristic pathlength
                    matricesCPL(sx) = charpath(distMatrix(:,:,sx))/lthrpr + matricesCPL(sx);
                    %calculate participant coefficient
                    % first requires community structure
                    mc = community_louvain(binthreshM(:,:,sx));
                    matricesPCoeff(:,sx) = participation_coef(binthreshM(:,:,sx),mc)/lthrpr + matricesPCoeff(:,sx);
                    matricesCommunity(:,sx) = mc/lthrpr + matricesCommunity(:,sx);
                end
            end
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).CC  = matricesCC;
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).EFF = matricesEFF;
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).MOD = matricesMOD;
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).CPL = matricesCPL;
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).Com = matricesCommunity;
            dfgraph.(fnames{i}).(cond{j}).(freqs{k}).PC  = matricesPCoeff;
        end
    end
end

save([currentDir 'graphanal.mat'], 'dfgraph')






%% present some descriptive statistics
% didn't use...
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
