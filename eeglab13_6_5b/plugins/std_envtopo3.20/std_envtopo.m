% std_envtopo() - Creates an envtopo() plot for STUDY component clusters. Each cluster ERP
%                 is normalized by the number of ICs per group. When generating multiple 
%                 plots for each combination of conditions, cluster line colors
%                 are shared across plots.
% 
% statPvaf - subfunction for bootstrap statistics for p-values and confidence interval.
%            stat_surrogate_pvals and stat_surrogate_ci are used.
%
% Usage:
%           >> std_envtopo(STUDY, ALLEEG, 'key1', 'val1', ...);
%
%           When using with GUI, choose time range (in ms) to plot, time range
%           (in ms) to rank cluster contributions, and specify cluster(s) of interest
%           or number of largest contributing cluster(s) to plot. envtopo() plots can 
%           be generated for a single variable combination (using "STUDY variable
%           combination"), a subtraction between two variable combinations (using
%           "Subtraciton"), or an interaction between four variable combinations 
%           (using "Interaction"). statPvaf is accessed by entering
%           [alpha numIterations] into "pvaf statistics" field in GUI. 
%
% Inputs:
%
%   STUDY   an EEGLAB STUDY structure containing EEG structures
%
%   ALLEEG  the ALLEEG data structure; can also be an EEG dataset structure.
%
% Optional inputs:
%
%  'baseline' [integer ms integer ms] - a new baseline (beginning and ending, respectively)
%             to remove from the grand and cluster ERPs.
%
%  'clustnums' [integer array] vector of cluster numbers to plot.  Else if
%              int < 0, the number of largest contributing clusters to plot
%              {default|[] -> 7}
%          
%  'downsampled' ['on'|'off'] Topography downsampled from 67x67 to 33x33
%                Always 'on' for statPvaf calculations. {Default 'on'} 
%
%  'drawvertline' [integer ms] vector of times at which to plot drawvertlineical dashed lines
%                   {default|[] -> none}
%
%  'fillclust' [integer] fill the numbered cluster envelope with red. {default|[]|0 -> no fill}
%
%  'fillclustcolor' [float float float] where inputs are 0<=value<=1. to create a color
%                    to fill the summed selected clusters. {dafault [1 0 0]}
%
%  'fillenvsum' ['selective'|'all'|'off'] fill or not the envelope of the
%               summed selected cluster. 'select' fills only limitcontribtime
%               time range. 'all' fills all timerange. 'off' does not fill.
%               See also 'fillenvsumcolor' so choose a filling color. {default: 'selective'}
%
%  'fillenvsumcolor' [float float float] where inputs are 0<=value<=1. To create a color
%                      to fill the summed selected clusters. {dafault [0.875 0.875 0.875]}
%
%  'forcePositiveTopo' ['on'|'off'] flip scalp topo polarities to negative if
%                      abs(min(envelope)) > abs(max(envelope)). {default:'off'}
%
%  'limitamp' [float uV float uV]. Specify minimum and maximum amplitude limit respectively
%              {default: use data uV limits}
%
%  'limitcontribtime' [integer ms integer ms]  time range in which to rank cluster contributions
%                      (boundaries = thin dotted lines) {default|[]|[0 0] -> plotting limits}
%  
%  'lpf' [float Hz] low-pass filter the ERP data using the given upper pass-band edge
%                   frequency.  Filtering by pop_eegfiltnew(). {default: no lfp}
%  
%  'normalization'   ['normIC'|'normSubj'|'off'] Normalize projection by number of ICs, number of
%                    subjects, or no normalization, respectively. {Default 'normIC'} 
%
%  'onlyclus' ['on'|'off'] dataset components to include in the grand ERP.
%             'on' will include only the components that were part of the
%              clustering. For example, if components were rejected from
%              clustering because of high dipole model residual variance,
%              don't include their data in the grand ERP.
%             'off' will include all components in the datasets except
%              those in the subtructed ('subclus') clusters {default 'on'}.
%
%  'sortedVariance' ['pvaf'(default)|'maxp'|'ppaf'|'rltp'|'area']
%            'pvaf', sort components by percent variance accounted for (eeg_pvaf())
%            pvaf(comp) = 100-100*mean(var(data - back_proj))/mean(var(data));
%            'maxp', maximum power
%            maxp(comp) = max(sum(cluster(:,selectedtimewindow)^2));
%            'ppaf', sort components by percent power accounted for (ppaf) 
%            ppaf(comp) = 100-100*Mean((data - back_proj).^2)/Mean(data.^2);
%            'rltp', sort components by relative power 
%            rltp(comp) = 100*Mean(back_proj.^2)/Mean(data.^2);
%            'area', sort components by enveloped area ratio (experimental)
%            area(comp) = 100*(area of envelope by a selected cluster)/(area of outermost envelope)
%
%  'sortedVariancenorm' ['on'|'off'] normalizes sortedVariance so that the sum of sortedVariance is 100%. {Default 'off'} 
%
%  'subclus' [integer array] vector of cluster numbers to omit when computing
%            the ERP envelope of the data (e.g., artifact clusters).
%            By default, these clusters are excluded from the grandERP envelope.
%            See the option 'onlyclus'.
%
%  'timerange' [integer ms integer ms] data epoch start and end input
%              latencies respectively. {default: epoch length}
%
%  'topotype' ['inst'|'ave'] If 'inst', show the instantaneous map at the specific timepoint
%             specified by the line. If 'ave', show that of the mean which is the same as the
%             stored topomap. {default:'inst'}
%
% See also: eegplugin_std_envtopo, pop_std_envtopo, std_envtopo, envtopo, stat_surrogate_pvals, stat_surrogate_ci
% 			Lee, Clement, et al. "Non-parametric group-level statistics for source-resolved ERP analysis." Engineering 
%				in Medicine and Biology Society (EMBC), 2015 37th Annual International Conference of the IEEE. IEEE, 2015.

% Author: Makoto Miyakoshi, 2011- JSPS;INC,SCCN,UCSD.
%         Former version of this function was developed by Hilit Serby, Arnold Delorme, and Scott Makeig.
% History:
% 04/06/2016 ver 3.00 by Clement.statPvaf released. std_envtopo updated with GUIDE based GUI. Option 'normalization' and 'downsampled' added; 'diff' removed (obsolete because of GUI). Help updated.
% 01/19/2016 ver 2.42 by Makoto. Changed 1:size(setinds{1,1},2) to 1:size(STUDY.group,2) Thanks Alvin Li!
% 01/08/2016 ver 2.41 by Makoto. Removed 'Store the precomputed results' removed.
% 11/25/2015 ver 2.40 by Makoto. Session bug fixed.
% 02/09/2015 ver 2.39 by Makoto. Subtraction figure bug fixed.
% 01/30/2015 ver 2.38 by Makoto. Figure overlap problem fixed.
% 12/26/2014 ver 2.37 by Makoto. Bug fixed (when no group, plotting failed). Axis labels renewed. Low-pass filter order shortened to be a half.
% 08/04/2014 ver 2.36 by Makoto. Reports the number of subjects and ICs for each group.
% 07/08/2014 ver 2.35 by Makoto. Outlier cluster detection updated (now with try...catch...)
% 03/21/2014 ver 2.34 by Makoto. Help updated.
% 02/13/2014 ver 2.33 by Makoto. Debug on fillclust. Added fillclustcolor. Fine-tuned plot layout and design.
% 02/06/2014 ver 2.32 by Makoto. Commneted out the STUDY update at the end of the main function.
% 02/06/2014 ver 2.31 by Makoto. Bug fix in the eegplugin_std_evntopo.
% 02/04/2014 ver 2.30 by Makoto. Pvaf calculation now uses mean(var(ERP... for compatibility with envtopo().
% 02/03/2014 ver 2.20 by Makoto. Session supported (can't be used with group)
% 11/14/2013 ver 2.14 by Makoto. Bug if no group fixed (line 340). Use of lpf option forces to recompute data.
% 10/11/2013 ver 2.13 by Makoto. pvaf: xx colon removed.
% 10/08/2013 ver 2.12 by Makoto. Option 'amplimit' changed. Option 'lpf' help added.
% 10/08/2013 ver 2.11 by Makoto. Normalization computation debugged and refined. Plot titles for the case of combined conditions in the STUDY design fixed. %2.1f uniformly. Brushed up plot details.
% 10/04/2013 ver 2.10 by Makoto. Interaction (i.e. difference of difference) supported. Simplified difference plot title.
% 10/02/2013 ver 2.00 by Makoto. 6x faster after the 2nd run (31 vs 5 sec, 2200ICs). Stores precompute measure for maximum efficiency. Optimized the loop to generate topoerpconv_stack. Handles no-entry clusters correctly. Cleaned up warnings by auto code analyzer.
% 08/15/2013 ver 1.00 by Makoto. Version renumbered for official release.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 08/15/2013 ver 6.4 by Makoto. forcePositiveTopo added.
% 05/20/2013 ver 6.3 by Makoto. Bug STUDY.design(1,STUDY.currentdesign) fixed.
% 05/10/2013 ver 6.2 by Makoto. lpf supported. waitbar added. bsxfun used.
% 01/30/2013 ver 6.1 by Makoto. group_topo_now related bug fixed.
% 01/28/2013 ver 6.0 by Makoto. Combined groups supported. group_topo_now simplified.
% 10/10/2012 ver 5.3 by Makoto. 'sortedVariance' 'sortedVariancenorm' 'fillenvsumcolor' 'fillenvsum' added.
% 04/29/2012 ver 5.2 by Makoto. Bug fixed. STUDY.design(STUDY.currentdesign)
% 04/24/2012 ver 5.1 by Makoto. Revived 'amplimit' 'fillclust' options, and drawvertlineical doted lines for limitcontribtime range. Default changed into 'pvaf' from 'rv'. 
% 02/28/2012 ver 5.0 by Makoto. Values are now normalized by the number of subjects participating to the cluster. Group difference is better addressed when performing subtraction across groups. A group ratio is output too.
% 02/24/2012 ver 4.5 by Makoto. New color schema to improve color readability & shared line colors across multiple plots
% 02/22/2012 ver 4.4 by Makoto. Now plot title can accept numbers
% 01/24/2012 ver 4.3 by Makoto. Output added for the function.
% 01/17/2012 ver 4.2 by Makoto. Improved diff option; now mutually exclusive with normal plot. Diff title improved too. 
% 01/06/2012 ver 4.1 by Makoto. Time range options fixed. STUDY.design selection fixed. Wrong labels fixed. (Thanks to Agatha Lenartowicz!) 'sortedVariance' and 'topotype' implemented in the main function. Help edited.
% 12/30/2011 ver 4.0 by Makoto. Main function 100% redesigned. Full support for Study design.
% 12/26/2011 ver 3.2 by Makoto. Formats corrected.
% 12/25/2011 ver 3.1 by Makoto. Bug fixed about choosing wrong clusters under certain conditions. 
% 10/12/2011 ver 3.0 by Makoto. Completed the alpha version. 
% 10/11/2011 ver 2.2 by Makoto. Time range, group with no entry fixed
% 10/10/2011 ver 2.1 by Makoto. Two types of scalp topos can be presented.
% 10/08/2011 ver 2.0 by Makoto. Multiple groups supported (but one group one time using option). Result topos are now retrieved from the stored ones in STUDY 
% 08/01/2011 ver 1.0 by Makoto. Updated the original script to read data from STUDY. 180x faster than the original (3971 vs 22 sec, 700ICs).

% Copyright (C) 2016, Clement Lee, Makoto Miyakoshi, Hilit Serby, Arnold Delorme, Scott Makeig
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1.07  USA

function STUDY = std_envtopo(STUDY, ALLEEG, varargin)

% if there is < 2 arguments, show help
if nargin < 2
    help std_envtopo;
    return
end

% if arguments are in odd number, wrong input
if mod(nargin,2) % if not an even number of arguments
    error('std_envtopo: Input argument list must be pairs of: ''keyx'', ''valx'' ');
end

% run finputcheck
arglist = finputcheck(varargin, ...
             {'clusterIdxToUse'   'integer'  -length(STUDY.cluster):length(STUDY.cluster)  [];...
              'conditions'        'integer'  1:length(STUDY.design(STUDY.currentdesign).variable(1,1).value) 1:length(STUDY.design(STUDY.currentdesign).variable(1,1).value);...
              'clust_exclude'     'integer'  1:length(STUDY.cluster)  [];...
              'onlyclus'          'string'   {'on', 'off'}  'on';...
              'statPvaf'          'real'     []  [];...
              'statPvafTail'      'integer'  []  [];...
              'baseline'          'real'     []  [];...
              'designVector'      'real'     []  [];...
              'timerange'         'real'     []  ALLEEG(1,1).times([1 end]);...
              'limitamp'          'real'     []  [];...
              'limitcontribtime'  'real'     []  [];...
              'drawvertline'      'real'     []  [];...
              'sortedVariance'           'string'   {'maxp', 'pvaf', 'ppaf', 'rltp', 'area'}  'pvaf';...
              'sortedVariancenorm'       'string'   {'on', 'off'}  'off';...
              'fillenvsum'        'string'   {'selective','all','off'}  'selective';...
              'topotype'          'string'   {'inst', 'ave'}  'inst';...
              'fillenvsumcolor'   'real'     []  [0.875  0.875  0.875];...
              'fillclust'         'integer'  []  [];...
              'fillclustcolor'    'real'     []  [1 0 0];...
              'lpf'               'real'     []  [];...
              'forcePositiveTopo' 'string'   {'on', 'off'}  'off';...
              'normalization'     'string'   {'normIC','normSubj','off'}  'normIC';...
              'downsampled'       'string'   {'on', 'off'}  'on';...
              });
          
if ischar(arglist)
    error(arglist);
end
clear varargin

% Calculate timepoints to plot and compute pvaf frames
arglist.totalPlotRange = find(STUDY.cluster(1,2).erptimes >= arglist.timerange(1) & STUDY.cluster(1,2).erptimes <= arglist.timerange(2));
arglist.pvafFrames = find(STUDY.cluster(1,2).erptimes >= arglist.limitcontribtime(1) & STUDY.cluster(1,2).erptimes <= arglist.limitcontribtime(2));

% if length(arglist.pvafFrames) ~= 

[~,arglist.relativeFramesWithinPlotRange] = intersect(arglist.totalPlotRange, arglist.pvafFrames);

% baseline period to timepoints (from sample)
if  ~isempty(arglist.baseline)
    arglist.baselinelimits = find(STUDY.cluster(1,2).erptimes >= arglist.baseline(1) & STUDY.cluster(1,2).erptimes <= arglist.baseline(2));
end

% Outlier cluster & all clusters included
try strcmp(STUDY.cluster(2).name(1:7), 'outlier')
    disp('Outlier cluster detected: Cls 3 and after will be used.')
    arglist.clust_all = 3:length(STUDY.cluster);% exclude parent (1) and outliers (2)
catch
    disp('No outlier cluster: Cls 2 and after will be used.')
    arglist.clust_all = 2:length(STUDY.cluster);% exclude parent (1) only
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Determine clusters to plot    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if arglist.clusterIdxToUse > 0;
    arglist.clust_selected = arglist.clusterIdxToUse;
    arglist.clust_topentries = [];
elseif arglist.clusterIdxToUse < 0
    arglist.clust_selected = [];
    arglist.clust_topentries = abs(arglist.clusterIdxToUse);
end
if strcmp(arglist.onlyclus, 'on')
    arglist.clust_grandERP = setdiff(arglist.clust_all, arglist.clust_exclude);
else
    arglist.clust_grandERP = arglist.clust_all;
end
arglist.clustlabels = {STUDY.cluster.name};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Separate topos into groups   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ((length(STUDY.group)>1 || length(STUDY.session)>1) && ~isfield(STUDY.cluster, 'topoall_group'))||...
        (isfield(STUDY.cluster, 'topoall_group') && isempty(STUDY.cluster(3).topoall_group))
    [STUDY, ALLEEG] = separateToposIntoGroups(STUDY, ALLEEG);
    assignin('base', 'STUDY', STUDY);
else
    disp('No need to separate topos into groups.')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Starting a big loop   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if isempty(STUDY.envtopoParams{1,12})||~isempty(arglist.lpf)
% if ~isfield(STUDY, 'projection')
    if ~isempty(arglist.lpf)
        disp('Low-pass filter option detected: data will be recomputed.')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%   Convolve scalp topo with ERP   %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numLoop = length(arglist.clust_grandERP)*...
        length(STUDY.design(1,STUDY.currentdesign).variable(1,1).value)*...
        length(STUDY.design(1,STUDY.currentdesign).variable(1,2).value);
    
    convTopoErp = cell(1,length(arglist.clust_all));
    if strcmp(arglist.downsampled,'on')
        originalConvTopoErpAllClusters = zeros(377, ALLEEG(1,1).pnts, length(arglist.clust_all), length(STUDY.design(1,STUDY.currentdesign).variable(1,1).value), length(STUDY.design(1,STUDY.currentdesign).variable(1,2).value));
    elseif strcmp(arglist.downsampled,'off')
        originalConvTopoErpAllClusters = zeros(3409, ALLEEG(1,1).pnts, length(arglist.clust_all), length(STUDY.design(1,STUDY.currentdesign).variable(1,1).value), length(STUDY.design(1,STUDY.currentdesign).variable(1,2).value));
    end
    
    counter = 0;
    waitbarHandle = waitbar(counter, 'Preparing the data. Please wait.');
    for cls = 1:length(arglist.clust_all) % For all clusters for grandERP
        for columnwise = 1:size(STUDY.cluster(1,arglist.clust_all(cls)).erpdata, 1) % For the first variable
            for rowwise = 1:size(STUDY.cluster(1,arglist.clust_all(cls)).erpdata, 2) % For the second variable
                
                counter = counter+1;
                waitbar(counter/numLoop, waitbarHandle)
                
                if ~isempty(STUDY.cluster(1,arglist.clust_all(cls)).erpdata{columnwise, rowwise}) % Detect no group entry
                    erp  = double(STUDY.cluster(1,arglist.clust_all(cls)).erpdata{columnwise, rowwise}');
                    
                    % low-pass filter the data if requested
                    if ~isempty(arglist.lpf)
                        erp = myeegfilt(erp, ALLEEG(1,1).srate,0,arglist.lpf);
                    end
                    
                    if  length(STUDY.group)>1 || length(STUDY.session)>1
                        topo  = STUDY.cluster(1,arglist.clust_all(cls)).topoall_group{1, rowwise};
                    else
                        topo  = STUDY.cluster(1,arglist.clust_all(cls)).topoall;
                    end
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %%% convolve topo x erp %%%
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if strcmp(arglist.downsampled,'on')
                        tmpTopo0 = reshape(cell2mat(topo), [67 67 length(topo)]);
                        tmpTopo1 = tmpTopo0(1:3:67,1:3:67,:);
                        tmpTopo2 = tmpTopo1(~isnan(tmpTopo1));
                        tmpTopo3 = reshape(tmpTopo2, [length(tmpTopo2)/length(topo) length(topo)]);
                        convTopoErp{1, cls}{columnwise,rowwise} = tmpTopo3*erp;  %min abs = zero
                        convTopoErpAllClusters(:,:,cls, columnwise, rowwise) = convTopoErp{1, cls}{columnwise,rowwise};
                        
                    elseif strcmp(arglist.downsampled,'off')
                        tmpTopo1 = reshape(cell2mat(topo), [67 67 length(topo)]);
                        tmpTopo2 = tmpTopo1(~isnan(tmpTopo1));
                        tmpTopo3 = reshape(tmpTopo2, [length(tmpTopo2)/length(topo) length(topo)]);
                        convTopoErp{1, cls}{columnwise,rowwise} = tmpTopo3*erp;  %min abs = zero
                        convTopoErpAllClusters(:,:,cls, columnwise, rowwise) = convTopoErp{1, cls}{columnwise,rowwise};
                        
                    end
                    
                else
                    disp([char(10) ' CAUTION: No IC entry in Cluster ' num2str(arglist.clust_all(1,1)+cls-1) ' Group ' num2str(rowwise)])
                    convTopoErp{1, cls}{columnwise,rowwise} = zeros(size(convTopoErpAllClusters,1), ALLEEG(1,1).pnts); % Dummy data
                end
                
                % topoerpconv_stack has 5 dimensions that are:
                % 1. topo*erp == 3409 or downsampled 377
                % 2. time points (which should be equal to ALLEEG(1,1).pnts
                % 3. cluster number
                % 4. variable 1 (usually within-subject  condition)
                % 5. variable 2 (usually between-subject condition)
            end
        end
    end
    
    close(waitbarHandle)
    clear cls columnwise erp rowwise topo topoerpconv tmp* counter numLoop waitbarHandle
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Normalization (choice of by subj or by IC (default))%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setinds = {STUDY.cluster(arglist.clust_all).setinds};
nsubject_group = zeros(length(arglist.clust_all), size(setinds{1,1}, 2));
for n = 1:length(arglist.clust_all)
    for column = 1:size(setinds{1,1}, 2)
        nIC_group(n,column)      = length(setinds{1,n}{1,column});
        nsubject_group(n,column) = length(unique(setinds{1,n}{1,column}));
    end
end

if strcmp(arglist.normalization, 'normSubj')
    normalizationFactors(1,1,1:size(nsubject_group,1),1,1:size(nsubject_group,2)) = nsubject_group;
elseif strcmp(arglist.normalization,'normIC')
    normalizationFactors(1,1,1:size(nsubject_group,1),1,1:size(nsubject_group,2)) = nIC_group;
elseif strcmp(arglist.normalization, 'off')
    normalizationFactors(1,1,1:size(nsubject_group,1),1,1:size(nsubject_group,2)) = ones(size(nIC_group));
end

convTopoErpAllClusters = bsxfun(@rdivide, convTopoErpAllClusters, normalizationFactors);
arglist.normalize_cluster = nsubject_group;

% This should work faster, but in reality it is 50-100x slower; why?
% invNsubjectGroup = (nsubject_group).^-1;
% normalizationFactors(1,1,1:size(invNsubjectGroup,1),1,1:size(invNsubjectGroup,2)) = invNsubjectGroup;
% convTopoErpAllClusters = bsxfun(@times, convTopoErpAllClusters, normalizationFactors);
% arglist.normalize_cluster = nsubject_group;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Report number of unique subjects for each cluster %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for n = 1:size(arglist.normalize_cluster,1) % for the number of clusters
    str = sprintf('In %s, ', arglist.clustlabels{1,arglist.clust_all(n)});
    if length(STUDY.group)>1 % if multiple groups
        for m = 1:size(STUDY.group, 2)
            str = [str sprintf('%d %s ', arglist.normalize_cluster(n,m), num2str(STUDY.group{1,m}))]; %#ok<*AGROW>
            str = [str sprintf('(%d ICs) ', nIC_group(n,m))]; %#ok<*AGROW>
        end
        disp(str)
    elseif length(STUDY.session)>1 % if multiple sessions
        for m = 1:size(STUDY.session, 2)
            str = [str sprintf('%d %s ', arglist.normalize_cluster(n,m), num2str(STUDY.session(1,m)))]; %#ok<*AGROW>
            str = [str sprintf('(%d ICs) ', nIC_group(n,m))]; %#ok<*AGROW>
        end
        disp(str)
    else
        str = [str sprintf('%d %s ', arglist.normalize_cluster(n,1)) 'unique subjects'];
        str = [str sprintf('(%d ICs) ', nIC_group(n,1))]; %#ok<*AGROW>            
        disp(str)
    end
end
clear column n row setinds nsubject* str tmp* whos* m userInput dataSizeIn* nIC_group

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Select cluseters to use %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,intersectIdx]       = intersect(arglist.clust_all, arglist.clust_grandERP);
convTopoErpAllClusters = convTopoErpAllClusters(:,:,intersectIdx,:,:);
arglist.clustlabels    = {STUDY.cluster(1,arglist.clust_grandERP).name}; % leave only the selected clusters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Apply new baseline (if specified) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if isfield(arglist, 'baselinelimits')
    baselineValues = mean(convTopoErpAllClusters(:, arglist.baselinelimits,:,:,:), 2);
    convTopoErpAllClusters = bsxfun(@minus, convTopoErpAllClusters, baselineValues);
    fprintf('\nNew baseline applied.\n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate outermost envelope for each conditions %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
outermostEnv = sum(convTopoErpAllClusters, 3);
originalConvTopoErpAllClusters = convTopoErpAllClusters;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Select clusters (if specified) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if arglist.clusterIdxToUse > 0;
    [~,idx] = intersect(arglist.clust_grandERP, arglist.clusterIdxToUse);
    convTopoErpAllClusters = convTopoErpAllClusters(:,:,idx,:,:);
    tmp = {arglist.clustlabels(1, idx)};
    arglist.clustlabels = tmp{1,1}; clear tmp idx
end

%%%%%%%%%%%%%%%%%%%%
%%% Plot envtopo %%%
%%%%%%%%%%%%%%%%%%%%
colorlog = zeros(1,2);

% Case single condition
if length(arglist.designVector) ==2
    tmpCond  = STUDY.design(STUDY.currentdesign).variable(1,1).value{1, arglist.designVector(1,1)}; 
    tmpGroup = STUDY.design(STUDY.currentdesign).variable(1,2).value{1, arglist.designVector(1,2)}; 
    if iscell(tmpCond);  tmpCond  = cell2mat(tmpCond);  end
    if iscell(tmpGroup); tmpGroup = cell2mat(tmpGroup); end
    arglist.title = [num2str(STUDY.design(STUDY.currentdesign).variable(1,1).label) ' ' num2str(tmpCond) ' ' num2str(STUDY.design(STUDY.currentdesign).variable(1,2).label) ' ' num2str(tmpGroup)];
    
    figure
    set(gcf,'Color', [0.93 0.96 1], 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', 'std_envtopo()') % EEGLAB color
    colorlog = envtopo_plot(STUDY, ALLEEG, squeeze(outermostEnv(:, arglist.totalPlotRange, 1, arglist.designVector(1,1), arglist.designVector(1,2))), squeeze(convTopoErpAllClusters(:,arglist.totalPlotRange,:,arglist.designVector(1,1),arglist.designVector(1,2))), colorlog, arglist);
    
% Case subtractions
elseif length(arglist.designVector) >=4
    tmpCond1  = STUDY.design(STUDY.currentdesign).variable(1,1).value{1, arglist.designVector(1,1)}; if iscell(tmpCond1);  tmpCond1  = num2str(cell2mat(tmpCond1)); end;  if isnumeric(tmpCond1); tmpCond1 = num2str(tmpCond1); end
    tmpCond2  = STUDY.design(STUDY.currentdesign).variable(1,1).value{1, arglist.designVector(1,3)}; if iscell(tmpCond2);  tmpCond2  = num2str(cell2mat(tmpCond2)); end;  if isnumeric(tmpCond2); tmpCond2 = num2str(tmpCond2); end
    tmpGroup1 = STUDY.design(STUDY.currentdesign).variable(1,2).value{1, arglist.designVector(1,2)}; if iscell(tmpGroup1); tmpGroup1 = num2str(cell2mat(tmpGroup1)); end; if isnumeric(tmpGroup1); tmpGroup1 = num2str(tmpGroup1); end
    tmpGroup2 = STUDY.design(STUDY.currentdesign).variable(1,2).value{1, arglist.designVector(1,4)}; if iscell(tmpGroup2); tmpGroup2 = num2str(cell2mat(tmpGroup2)); end; if isnumeric(tmpGroup2); tmpGroup2 = num2str(tmpGroup2); end
    if length(arglist.designVector) == 8 % if interaction (i.e. difference of difference)
        tmpCond3  = STUDY.design(STUDY.currentdesign).variable(1,1).value{1, arglist.designVector(1,5)}; if iscell(tmpCond1);  tmpCond3  = num2str(cell2mat(tmpCond3)); end; if isnumeric(tmpCond3); tmpCond3 = num2str(tmpCond3); end
        tmpCond4  = STUDY.design(STUDY.currentdesign).variable(1,1).value{1, arglist.designVector(1,7)}; if iscell(tmpCond2);  tmpCond4  = num2str(cell2mat(tmpCond4));  end; if isnumeric(tmpCond4); tmpCond4 = num2str(tmpCond4); end
        tmpGroup3 = STUDY.design(STUDY.currentdesign).variable(1,2).value{1, arglist.designVector(1,6)}; if iscell(tmpGroup1); tmpGroup3 = num2str(cell2mat(tmpGroup3)); end; if isnumeric(tmpGroup3); tmpGroup3 = num2str(tmpGroup3); end
        tmpGroup4 = STUDY.design(STUDY.currentdesign).variable(1,2).value{1, arglist.designVector(1,8)}; if iscell(tmpGroup2); tmpGroup4 = num2str(cell2mat(tmpGroup4)); end; if isnumeric(tmpGroup4); tmpGroup4 = num2str(tmpGroup4); end
    end
    
    if     isempty(STUDY.design(STUDY.currentdesign).variable(1,1).label)
        if length(arglist.designVector) == 4; arglist.title = [tmpGroup1 ' - ' tmpGroup2]; else arglist.title = ['(' tmpGroup1 ' - ' tmpGroup2 ') - (' tmpGroup3 ' - ' tmpGroup4 ')']; end
    elseif isempty(STUDY.design(STUDY.currentdesign).variable(1,2).label)
        if length(arglist.designVector) == 4; arglist.title = [tmpCond1  ' - ' tmpCond2];  else arglist.title = ['(' tmpCond1  ' - ' tmpCond2  ') - (' tmpCond3  ' - ' tmpCond4  ')']; end
    else
        if length(arglist.designVector) == 4; arglist.title = [tmpGroup1 ' ' tmpCond1  ' - ' tmpGroup2 ' ' tmpCond2];  else arglist.title = ['(' tmpGroup1 ' ' tmpCond1  ' - ' tmpGroup2 ' ' tmpCond2  ') - (' tmpGroup3 ' ' tmpCond3  ' - ' tmpGroup4 ' ' tmpCond4  ')']; end
    end
    
    if     length(arglist.designVector) == 4;
        outermostEnv = outermostEnv(:,:,:,arglist.designVector(1,1),arglist.designVector(1,2)) - outermostEnv(:,:,:,arglist.designVector(1,3),arglist.designVector(1,4));
        diffEnv      = convTopoErpAllClusters(:,:,:,arglist.designVector(1,1),arglist.designVector(1,2))-convTopoErpAllClusters(:,:,:,arglist.designVector(1,3),arglist.designVector(1,4));
    elseif length(arglist.designVector) == 8;
        outermostEnv = outermostEnv(:,:,:,arglist.designVector(1,1),arglist.designVector(1,2)) - outermostEnv(:,:,:,arglist.designVector(1,3),arglist.designVector(1,4)) - (outermostEnv(:,:,:,arglist.designVector(1,5),arglist.designVector(1,6)) - outermostEnv(:,:,:,arglist.designVector(1,7),arglist.designVector(1,8)));
        diffEnv      = convTopoErpAllClusters(:,:,:,arglist.designVector(1,1),arglist.designVector(1,2)) - convTopoErpAllClusters(:,:,:,arglist.designVector(1,3),arglist.designVector(1,4)) - (convTopoErpAllClusters(:,:,:,arglist.designVector(1,5),arglist.designVector(1,6)) - convTopoErpAllClusters(:,:,:,arglist.designVector(1,7),arglist.designVector(1,8)));
    end
    
    figure
    set(gcf,'Color', [0.93 0.96 1], 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', 'std_envtopo()') % EEGLAB color
    %    [~, sortedVariance, clusterIdx] = envtopo_plot(STUDY, ALLEEG, squeeze(outermostEnv(:,arglist.totalPlotRange,:,:,:)), squeeze(diffEnv(:,arglist.totalPlotRange,:,:,:)), colorlog, arglist);
    [~, ~, clusterIdx] = envtopo_plot(STUDY, ALLEEG, squeeze(outermostEnv(:,arglist.totalPlotRange,:,:,:)), squeeze(diffEnv(:,arglist.totalPlotRange,:,:,:)), colorlog, arglist);
    
    %%%%%%%%%%%%%%%%%%%%%
    %%% Run statPvaf  %%%
    %%%%%%%%%%%%%%%%%%%%%
    if ~isempty(arglist.statPvaf)
        fprintf('Running statPvaf\n')
        
        % Obtain indices for Clusters
        if arglist.clusterIdxToUse > 0
            if strcmp(STUDY.cluster(2).name,'outlier 2')
                clusterIdx = arglist.clusterIdxToUse - 2; % adjust for parentcluster 1 and outlier 2
            else
                clusterIdx = arglist.clusterIdxToUse - 1; % adjust for parentcluster 1
            end
        end
        
        % Perform statistics
        statPvaf(STUDY, clusterIdx, arglist, originalConvTopoErpAllClusters, normalizationFactors);
    end
end



% this function came with the original std_envtopo. I customized it only minimally. -Makoto
function [colorlog, sortedVariance, clusterIdx] = envtopo_plot(STUDY, ~, grandERP, projERP, colorlog, varargin)

% data format conversion for compatibility
arglist = varargin{1,1};
clear varargin

for n = 1:size(projERP, 3);
    tmp{1,n} = projERP(:,:,n);
end
projERP = tmp;
clear n tmp

MAXTOPOS = 20;      % max topoplots to plot
drawvertlineWEIGHT = 2.0;  % lineweight of specified drawvertlineical lines
limitcontribtimeWEIGHT = 2.0; % lineweight of limonctrib drawvertlineical lines

myfig =gcf; % remember the current figure (for Matlab 7.0.0 bug)

% add options (default values)
arglist.envmode     = 'avg';
arglist.voffsets    = [];
arglist.colorfile   = '';
arglist.colors      = '';
arglist.xlabel      = 'on';
arglist.ylabel      = 'on';
arglist.topoarg     = 0;

% empty cluster crashes the code, so 
for n = 2:length(STUDY.cluster)
    if ~isempty(STUDY.cluster(1,n).topoall)
        if strcmp(arglist.downsampled,'on')
            arglist.gridind = find(~isnan(STUDY.cluster(1,n).topoall{1,1}(1:3:67,1:3:67)));
        elseif strcmp(arglist.downsampled,'off')
            arglist.gridind = find(~isnan(STUDY.cluster(1,n).topoall{1,1}));
        end
        break
    end
end
clear n


frames = length(arglist.totalPlotRange);

if ~isempty(arglist.colors)
    arglist.colorfile = arglist.colors; % retain old usage 'colorfile' for 'colors' -sm 4/04
end

if ~isempty(arglist.drawvertline)
    arglist.drawvertline = arglist.drawvertline/1000; % condrawvertline from ms to s
end
%
%%%%%% Collect information about the gca, then delete it %%%%%%%%%%%%%
%
uraxes = gca; % the original figure or subplot axes
pos=get(uraxes,'Position');
axcolor = get(uraxes,'Color');
delete(gca)

%
%%% Condrawvertline arglist.timerange and arglist.limitcontribtime to sec from ms %%%%
%
arglist.timerange = arglist.timerange/1000;   % the time range of the input data
arglist.limitcontribtime = arglist.limitcontribtime/1000; % the time range in which to select largest components


%
%%%%%%%%%%%% Collect time range information %%%%%%%%%%%%%%%%%%%%%%%%%%
%

xunitframes = 0;
xmin = arglist.timerange(1);
xmax = arglist.timerange(2);
pmin = xmin;
pmax = xmax;


%
%%%%%%%%%%%%%%% Find limits of the component selection window %%%%%%%%%
%

if arglist.limitcontribtime(1)<xmin
    arglist.limitcontribtime(1) = xmin;
end
if arglist.limitcontribtime(2)>xmax
    arglist.limitcontribtime(2) = xmax;
end
limframe1 = arglist.relativeFramesWithinPlotRange(1);
limframe2 = arglist.relativeFramesWithinPlotRange(end);

% Add dotted line to show pvaf frames
arglist.drawvertline(end+1) = arglist.limitcontribtime(1);
arglist.drawvertline(end+1) = arglist.limitcontribtime(2);

%
%%%%%%%%%%%%%%%%%%%%% Line color information %%%%%%%%%%%%%%%%%%%%%
%
% 16 colors names officially supported by W3C specification for HTML
colors{1,1}  = [1 1 1];            % White
colors{2,1}  = [1 1 0];            % Yellow
colors{3,1}  = [1 0 1];            % Fuchsia
colors{4,1}  = [1 0 0];            % Red
colors{5,1}  = [0.75  0.75  0.75]; % Silver
colors{6,1}  = [0.5 0.5 0.5];      % Gray
colors{7,1}  = [0.5 0.5 0];        % Olive
colors{8,1}  = [0.5 0 0.5];        % Purple
colors{9,1}  = [0.5 0 0];          % Maroon
colors{10,1} = [0 1 1];            % Aqua
colors{11,1} = [0 1 0];            % Lime
colors{12,1} = [0 0.5 0.5];        % Teal
colors{13,1} = [0 0.5 0];          % Green
colors{14,1} = [0 0 1];            % Blue
colors{15,1} = [0 0 0.5];          % Navy
colors{16,1} = [0 0 0];            % Black

% Silver is twice brighter because used for background
colors{5,1} = [0.875 0.875 0.875];

% Choosing and sorting 12 colors for line plot, namely Red, Blue, Green, Fuchsia, Lime, Aqua, Maroon, Olive, Purple, Teal, Navy, and Gray
linecolors = colors([4 13 14 3 11 10 9 7 8 12 15 6]);

%
%%%%%%%%%%%%%%%% Check other input variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
arglist.clusterIdxToUseOriginal = arglist.clusterIdxToUse;
[tmp,pframes] = size(projERP{1});
if frames ~= pframes
    error('Size of trial in projERP and grandenvERP do not agree');
end

if isempty(arglist.voffsets) || ( size(arglist.voffsets) == 1 && arglist.voffsets(1) == 0 )
    arglist.voffsets = zeros(1,MAXTOPOS);
end

if isempty(arglist.clusterIdxToUse) || arglist.clusterIdxToUse(1) == 0
   arglist.clusterIdxToUse = 1:length(projERP); % by default the number of projected ERP input
end
if min(arglist.clusterIdxToUse) < 0
    if length(arglist.clusterIdxToUse) > 1
        error('Negative clustnums must be a single integer.');
    end
    if -arglist.clusterIdxToUse > MAXTOPOS
        fprintf('Can only plot a maximum of %d components.\n',MAXTOPOS);
        return
    else
        MAXTOPOS = -arglist.clusterIdxToUse;
        arglist.clusterIdxToUse = 1:length(projERP); % by default the number of projected ERP input
    end
end

%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Process components %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
ncomps = length(arglist.clusterIdxToUse);

%
%%%%%%%%%%%%%%% Compute plotframes and envdata %%%%%%%%%%%%%%%%%%%%%
%
ntopos = length(arglist.clusterIdxToUse);
if ntopos > MAXTOPOS
    ntopos = MAXTOPOS; % limit the number of topoplots to display
end

plotframes = ones(ncomps,1);
%
% first, plot the data envelope
%
envdata = zeros(2,frames*(ncomps+1));
envdata(:,1:frames) = envelope(grandERP, arglist.envmode);

fprintf('Data epoch is from %.0f ms to %.0f ms.\n',1000*xmin,1000*xmax);
fprintf('Plotting data from %.0f ms to %.0f ms.\n',1000*xmin,1000*xmax);
fprintf('Comparing maximum projections for components:  ');
if ncomps>32
    fprintf('\n');
end
compvars = zeros(1,ncomps);

%
% Compute frames to plot
%
sampint  = (xmax-xmin)/(frames-1);     % sampling interval in sec
times    = xmin:sampint:xmax;          % make vector of data time values

[~, minf] = min(abs(times-pmin));
[~, maxf] = min(abs(times-pmax));
if limframe1 < minf
    limframe1 = minf;
end
if limframe2 > maxf
    limframe2 = maxf;
end

%
%%%%%%%%%%%%%% find max variances and their frame indices %%%%%%%%%%%
%
for c = 1:ncomps
    if ~rem(c,5)
        fprintf('%d ... ',arglist.clusterIdxToUse(c)); % c is index into clustnums
    end
    if ~rem(c,100)
        fprintf('\n');
    end

    envdata(:,c*frames+1:(c+1)*frames) = envelope(projERP{c}, arglist.envmode);

    [maxval,maxi] = max(sum(projERP{c}(:,limframe1:limframe2).*projERP{c}(:,limframe1:limframe2)));
    % find point of max variance for comp c
    compvars(c)   = maxval;
    maxi = maxi+limframe1-1;
    plotframes(c) = maxi;
    maxproj(:,c)  = projERP{c}(:,maxi); % Note: maxproj contains only arglist.plotchans -sm 11/04

end % component c
fprintf('\n');

%
%%%%%%%%%%%%%%% Compute component selection criterion %%%%%%%%%%%%%%%%%%%%%%%%%%
%

if ~xunitframes
    fprintf('  in the interval %3.0f ms to %3.0f ms.\n',1000*times(limframe1),1000*times(limframe2));
end

% sort components by maximum mean back-projected power 
% in the 'limitcontribtime' time range: mp(comp) = max(Mean(back_proj.^2));
% where back_proj = comp_map * comp_activation(t) for t in 'limitcontribtime'

%
%%%%%% Calculate sortedVariance, used to sort the components %%%%%%%%%%%
%
for c = 1:length(projERP)
    if     strcmpi(arglist.sortedVariance,'maxp')  % Maximum Power of backproj
        sortedVariance(c) = max(mean(projERP{c}(:,limframe1:limframe2).*projERP{c}(:,limframe1:limframe2)));
        fprintf('%s maximum mean power of back-projection: %g\n',arglist.clustlabels{c},sortedVariance(c));

    elseif strcmpi(arglist.sortedVariance,'pvaf')   % Percent Variance
        wholeCluster     = grandERP(:,limframe1:limframe2);
        remainingCluster = grandERP(:,limframe1:limframe2)-projERP{c}(:,limframe1:limframe2);
        sortedVariance(c) = 100-100*mean(var(remainingCluster))/mean(var(wholeCluster));
  
%         vardat = var(reshape(grandERP(:,limframe1:limframe2),1,nvals));
%         difdat = grandERP(:,limframe1:limframe2)-projERP{c}(:,limframe1:limframe2);
%         difdat = reshape(difdat,1,nvals);
%         sortedVariance(c) = 100-100*(var(difdat)/vardat); %var of diff div by var of full data
        fprintf('%s variance %2.4f, percent variance accounted for (pvaf): %2.1f%%\n',arglist.clustlabels{c}, mean(var(projERP{c}(:,limframe1:limframe2))), sortedVariance(c));
        % fprintf('%s percent variance accounted for(pvaf): %2.1f%%\n',arglist.clustlabels{c},sortedVariance(c));
    elseif strcmpi(arglist.sortedVariance,'ppaf')    % Percent Power
        powdat = mean(mean(grandERP(:,limframe1:limframe2).^2));
        sortedVariance(c) = 100-100*mean(mean((grandERP(:,limframe1:limframe2)...
                    -projERP{c}(:,limframe1:limframe2)).^2))/powdat;
        fprintf('%s percent power accounted for(ppaf): %2.1f%%\n',arglist.clustlabels{c},sortedVariance(c));

    elseif strcmpi(arglist.sortedVariance,'rltp')    % Relative Power
        powdat = mean(mean(grandERP(:,limframe1:limframe2).^2));
        sortedVariance(c) = 100*mean(mean((projERP{c}(:,limframe1:limframe2)).^2))/powdat;
        fprintf('%s relative power of back-projection: %2.1f%%\n',arglist.clustlabels{c},sortedVariance(c));
        
    elseif strcmpi(arglist.sortedVariance,'area')    % Enveloped Area ratio
        outermostEnv      = envelope(grandERP(:,limframe1:limframe2), arglist.envmode);
        outermostEnv_area = sum(abs(outermostEnv(1,:)))+sum(abs(outermostEnv(2,:)));
        tmp_projERP       = envelope(projERP{c}(:,limframe1:limframe2), arglist.envmode);
        tmp_projERP_area  = sum(abs(tmp_projERP(1,:)))+sum(abs(tmp_projERP(2,:)));
        sortedVariance(c)        = 100*tmp_projERP_area/outermostEnv_area;
        fprintf('%s enveloped area ratio : %2.1f%%\n',arglist.clustlabels{c},sortedVariance(c));
    end
end

%%%%%% Normalize the sortedVariance to 100 if requested %%%%%%
if strcmp(arglist.sortedVariancenorm, 'on')
    sortedVariance = sortedVariance*1/sum(sortedVariance)*100;
    fprintf('\n')
    fprintf('sortedVariancenorm is on: sortedVariance is normalized to 100%% in the plot \n');
end

%
%%%%%%%%%%%%%%%%%%%%%%%%% Sort by max variance in data %%%%%%%%%%%%%%%%%%%%%%%%%%%
%
[sortedVariance,clusterIdx] = sort(sortedVariance, 'descend');  % sort clustnums on max sortedVariance
compvarorder = arglist.clusterIdxToUse(clusterIdx);    % actual cluster numbers (output var)
plotframes   = plotframes(clusterIdx);     % plotted comps have these max frames

maxproj    = maxproj(:,clusterIdx); % maps in plotting order 
if ~isempty(arglist.clustlabels) 
   complabels = arglist.clustlabels(clusterIdx);  
   complabels = complabels(1:ntopos);% actual component numbers (output var)
end;

%
%%%%%%%%%%%%%%%%%%%%%%%% Reduce to ntopos %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
clusterIdx = clusterIdx(1:ntopos);
sortedVariance = sortedVariance(1:ntopos);
maxproj    = maxproj(:,1:ntopos);
compvarorder = compvarorder(1:ntopos);
[plotframes,ifx] = sort(plotframes(1:ntopos));% sort plotframes on their temporal order (min:max)
plottimes  = times(plotframes);       % condrawvertline to times in ms
clusterIdx      = clusterIdx(ifx);              % indices into clustnums, in plotting order
maporder   = compvarorder(ifx);       % reorder cluster numbers
maxproj    = maxproj(:,ifx);          % maps in plotting order
if ~isempty(arglist.clustlabels) 
   complabels = complabels(ifx);     % actual component numbers (output var)
end;
sortedVariance = sortedVariance(ifx);
vlen = length(arglist.voffsets); % extend voffsets if necessary
while vlen< ntopos
    arglist.voffsets = [arglist.voffsets arglist.voffsets(vlen)]; % repeat last offset given
    vlen=vlen+1;
end

head_sep = 1.2;
topowidth = pos(3)/(ntopos+(ntopos-1)/5); % width of each topoplot
if topowidth > 0.20    % adjust for maximum height
    topowidth = 0.2;
end

if rem(ntopos,2) == 1  % odd number of topos
    topoleft = pos(3)/2 - (floor(ntopos/2)*head_sep + 0.5)*topowidth;
else % even number of topos
    topoleft = pos(3)/2 - (floor(ntopos/2)*head_sep)*topowidth;
end

%
%%%%%%%%%%%%%%%%%%%% Print times and frames of comp maxes %%%%%%%%%%%%%%
%
if ~xunitframes
    fprintf('    with max var at times (ms): ');
    for t=1:ntopos
        fprintf('%4.0f  ',1000*plottimes(t));
    end
    fprintf('\n');
end

fprintf('                  epoch frames: ');
for t=1:ntopos
    fprintf('%4d  ',limframe1-1+plotframes(t));
end
fprintf('\n');

fprintf('Component sortedVariance in interval:  ');
fprintf('%2.1f ', sortedVariance);
fprintf('\n');

%
%%%%%%%%%%%%%%%%%%%%% Plot the data envelopes %%%%%%%%%%%%%%%%%%%%%%%%%
%
BACKCOLOR = [0.7 0.7 0.7];
newaxes=axes('position',pos);
axis off
set(newaxes,'FontSize',16,'FontWeight','Bold','Visible','off');
set(newaxes,'Color',BACKCOLOR); % set the background color
delete(newaxes) %XXX

% site the plot at bottom of the current axes
axe = axes('Position',[pos(1) pos(2) pos(3) 0.6*pos(4)],...
    'FontSize',16,'FontWeight','Bold');

set(axe,'GridLineStyle',':')
set(axe,'Xgrid','off')
set(axe,'Ygrid','on')
axes(axe)
set(axe,'Color',axcolor);

%
%%%%%%%%%%%%%%%%% Plot the envelope of the summed selected components %%%%%%%%%%%%%%%%%
%

sumproj = zeros(size(projERP{1}));
for n = 1:ntopos
    sumproj = sumproj + projERP{clusterIdx(n)}; % add up all cluster projections
end

% calculate summed sortedVariance of selected clusters
if     strcmpi(arglist.sortedVariance,'maxp')  % Maximum Power of backproj
    selectclusvar = max(mean(sumproj(:,limframe1:limframe2).*sumproj(:,limframe1:limframe2)));

elseif strcmpi(arglist.sortedVariance,'pvaf')   % Percent Variance
    wholeCluster     = grandERP(:,limframe1:limframe2);
    remainingCluster = grandERP(:,limframe1:limframe2)-sumproj(:,limframe1:limframe2);
    selectclusvar = 100-100*mean(var(remainingCluster))/mean(var(wholeCluster));
    
%     vardat = var(reshape(grandERP(:,limframe1:limframe2),1,nvals));
%     difdat = grandERP(:,limframe1:limframe2)-sumproj(:,limframe1:limframe2);
%     difdat = reshape(difdat,1,nvals);
%     selectclusvar = 100-100*(var(difdat)/vardat); %var of diff div by var of full data

elseif strcmpi(arglist.sortedVariance,'ppaf')    % Percent Power
    powdat = mean(mean(grandERP(:,limframe1:limframe2).^2));
    selectclusvar = 100-100*mean(mean((grandERP(:,limframe1:limframe2)...
                -sumproj(:,limframe1:limframe2)).^2))/powdat;

elseif strcmpi(arglist.sortedVariance,'rltp')    % Relative Power
    powdat = mean(mean(grandERP(:,limframe1:limframe2).^2));
    selectclusvar = 100*mean(mean((sumproj(:,limframe1:limframe2)).^2))/powdat;

elseif strcmpi(arglist.sortedVariance,'area')    % Enveloped Area ratio
    outermostEnv      = envelope(grandERP(:,limframe1:limframe2), arglist.envmode);
    outermostEnv_area = sum(abs(outermostEnv(1,:)))+sum(abs(outermostEnv(2,:)));
    tmp_projERP       = envelope(sumproj(:,limframe1:limframe2), arglist.envmode);
    tmp_projERP_area  = sum(abs(tmp_projERP(1,:)))+sum(abs(tmp_projERP(2,:)));
    selectclusvar        = 100*tmp_projERP_area/outermostEnv_area;
end

fprintf('Summed cluster sortedVariance in interval [%s %s] ms: %3.1f%',...
    int2str(1000*times(limframe1)),int2str(1000*times(limframe2)), selectclusvar);
fprintf('\n')

%
% Plot the summed projection filled
%
sumenv = envelope(sumproj, arglist.envmode);
if     strcmpi(arglist.fillenvsum,'selective')
    filltimes = times(limframe1:limframe2);
    mins = matsel(sumenv,frames,0,2,0);
    p=fill([filltimes filltimes(end:-1:1)],...
         [matsel(sumenv,frames,limframe1:limframe2,1,0) mins(limframe2:-1:limframe1)], arglist.fillenvsumcolor);
    set(p,'EdgeColor', arglist.fillenvsumcolor);
    hold on
    % redraw outlines
    p=plot(times,matsel(envdata,frames,0,1,1),'Color', colors{16,1});% plot the max
    set(p,'LineWidth',2);
    p=plot(times,matsel(envdata,frames,0,2,1),'Color', colors{16,1});% plot the min
    set(p,'LineWidth',2);
    
elseif strcmpi(arglist.fillenvsum,'all')
    mins = matsel(sumenv,frames,0,2,0);
    p=fill([times times(frames:-1:1)],...
        [matsel(sumenv,frames,0,1,0) mins(frames:-1:1)], arglist.fillenvsumcolor);
    set(p,'EdgeColor', arglist.fillenvsumcolor);
    hold on
    % redraw outlines
    p=plot(times,matsel(envdata,frames,0,1,1),'Color', colors{16,1});% plot the max
    set(p,'LineWidth',2);
    p=plot(times,matsel(envdata,frames,0,2,1),'Color', colors{16,1});% plot the min
    set(p,'LineWidth',2);

else % if no 'fill'
    tmp = matsel(sumenv,frames,0,2,0);
    p=plot(times,tmp);% plot the min
    hold on
    set(p,'Color', colors{5,1});
    set(p,'linewidth',2);
    p=plot(times,matsel(sumenv,frames,0,1,0));% plot the max
    set(p,'linewidth',2);
    set(p,'Color', colors{5,1});
end

%
% %%%%%%%%%%%%%%%%%%%%%%%% Plot the computed component envelopes %%%%%%%%%%%%%%%%%%
%
envx = [1,clusterIdx+1];
hold on
for c = 1:ntopos+1
    for envside = [1 2]
        if envside == 1 % maximum envelope
            curenv = matsel(envdata,frames,0,1,envx(c));
        else           % minimum envelope
            curenv = matsel(envdata,frames,0,2,envx(c));
        end
        p=plot(times,curenv);

        % First, the outermost envelope
        if c == 1
            set(p, 'Color', colors{16,1},'LineWidth',2, 'LineStyle', '-');
        % After the second, each cluster
        elseif isempty(intersect(colorlog(:,1), envx(c)))
            if colorlog(1,1) == 0 && colorlog(1,2) == 0 % initial state
                colorlog(1,:) = [envx(c) 1];
            else
                colorlog(end+1,:) = [envx(c) size(colorlog,1)+1];
            end

            if     colorlog(end,2) < 13
                set(p, 'Color' ,linecolors{colorlog(end,2)},   'LineWidth',1, 'LineStyle', '-');
            elseif colorlog(end,2) < 25
                set(p, 'Color' ,linecolors{colorlog(end,2)-12},'LineWidth',3, 'LineStyle', ':');
            elseif colorlog(end,2) < 37
                set(p, 'Color' ,linecolors{colorlog(end,2)-24},'LineWidth',1, 'LineStyle', '--');
            elseif colorlog(end,2) < 49
                set(p, 'Color' ,linecolors{colorlog(end,2)-36},'LineWidth',2, 'LineStyle', '-.');
            elseif colorlog(end,2) < 61
                set(p, 'Color' ,linecolors{colorlog(end,2)-48},'LineWidth',2, 'LineStyle', '-');
            else   % this is for cluster numbers more than 60 
                set(p, 'Color', colors{16,1},                  'LineWidth',1, 'LineStyle', ':');
            end
        else
            [~,IA] = intersect(colorlog(:,1), envx(c));
            if     IA < 13
                set(p, 'Color' ,linecolors{IA},   'LineWidth',1, 'LineStyle', '-');
            elseif IA < 25
                set(p, 'Color' ,linecolors{IA-12},'LineWidth',3, 'LineStyle', ':');
            elseif IA < 37
                set(p, 'Color' ,linecolors{IA-24},'LineWidth',1, 'LineStyle', '--');
            elseif IA < 49
                set(p, 'Color' ,linecolors{IA-36},'LineWidth',2, 'LineStyle', '-.');
            elseif IA < 61
                set(p, 'Color' ,linecolors{IA-48},'LineWidth',2, 'LineStyle', '-');
            else   % this is for cluster numbers more than 60 
                set(p, 'Color', colors{16,1}   ,'LineWidth',1, 'LineStyle', ':');
            end
        end
    end
end
set(gca,'FontSize',12,'FontWeight','Bold')

%%%%%%%%%%%%%%%%%%%%%%%%
%%% axis min and max %%%
%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(arglist.limitamp)
    ymin = min([grandERP(:); sumenv(:)]);
    ymax = max([grandERP(:); sumenv(:)]);
    yspace = (ymax-ymin)*0.01;
    ymin = ymin-yspace;
    ymax = ymax+yspace;
else
    ymin = arglist.limitamp(1);
    ymax = arglist.limitamp(2);
    ylim([ymin ymax])
end
xlim([pmin pmax])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% fill specified component %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(arglist.fillclust)
    if      sum(arglist.clusterIdxToUseOriginal) < 0
        [~,fillIdx] = ismember(arglist.fillclust, arglist.clust_grandERP(clusterIdx));
    elseif  sum(arglist.clusterIdxToUseOriginal) > 0
        [~,fillIdx] = ismember(arglist.fillclust, arglist.clust_selected);
    else
           fillIdx  = 0;
    end
        
    if any(fillIdx)
        fprintf('filling the envelope of component %d\n',arglist.fillclust);
        mins = matsel(envdata,frames,0,2,clusterIdx(fillIdx)+1);
        fill([times times(frames:-1:1)],...
            [matsel(envdata,frames,0,1,clusterIdx(fillIdx)+1) mins(frames:-1:1)],arglist.fillclustcolor);
        % Overplot the data envlope again so it is not covered by the filled component
        plot(times,matsel(envdata,frames,0,1,1), 'k', 'LineWidth',2);% plot the max
        plot(times,matsel(envdata,frames,0,2,1), 'k', 'LineWidth',2);% plot the min
    else
        fprintf('cluster %d is not on the list for plotting\n',arglist.fillclust);
    end
else
    fillIdx = 0;
end
clear clustlist clustn

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Add drawvertline %%%
%%%%%%%%%%%%%%%%%%%%%%%%  
% draw a vertlcal line at time zero
if arglist.timerange(1) <= 0 && arglist.timerange(2) >= 0
    vl=plot([0 0], [-1e10 1e10],'k');
    set(vl,'linewidth',1,'linestyle','-');
end

% if specified by option, draw a vertlcal line at specified latency
if ~isempty(arglist.drawvertline)
    for v=1:length(arglist.drawvertline)
        vl=plot([arglist.drawvertline(v) arglist.drawvertline(v)], [-1e10 1e10],'k');
        if any(arglist.limitcontribtime ~= 0) && v>= length(arglist.drawvertline)-1;
            set(vl,'linewidth',limitcontribtimeWEIGHT);
            set(vl,'linestyle',':');
        else
            set(vl,'linewidth',drawvertlineWEIGHT);
            set(vl,'linestyle','--');
        end
    end
end
ylim([ymin ymax])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Show sortedVariance and fillclust %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t = text(double(xmin+0.02*(xmax-xmin)), double(ymin+0.12*(ymax-ymin)), ...
    ['Summed ' arglist.sortedVariance ' ' num2str(selectclusvar,'%2.1f')]);
set(t,'fontsize',15)

if ~isempty(arglist.fillclust) && any(fillIdx)
    t = text(double(xmin+0.02*(xmax-xmin)), ...
        double(ymin+0.03*(ymax-ymin)), ...
        ['Cluster ' num2str(arglist.fillclust) ' filled.']);
    set(t,'fontsize',15)
end

%
%%%%%%%%%%%%%%%%%%%%%% Label axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
set(axe,'Color',axcolor);

if strcmpi(arglist.xlabel, 'on')
    l= xlabel('Latency (s)');
    set(l,'FontSize',14);
end

if strcmpi(arglist.ylabel, 'on')
    l = ylabel('RMS uV');
    set(l,'FontSize',14);
end

%
%%%%%%%%%%%%%% Draw maps and oblique/drawvertlineical lines %%%%%%%%%%%%%%%%%%%%%
%
% axall = axes('Units','Normalized','Position',pos,...
axall = axes('Position',pos,...
    'Visible','Off','Fontsize',16); % whole-figure invisible axes
axes(axall)
set(axall,'Color',axcolor);
axis([0 1 0 1])

width  = xmax-xmin;
pwidth  = pmax-pmin;
height = ymax-ymin;


for t=1:ntopos % draw oblique lines from max env vals (or plot top) to map bases, in left to right order
    %
    %%%%%%%%%%%%%%%%%%% draw oblique lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    axes(axall) %#ok<*LAXES>
    axis([0 1 0 1]);
    set(axall,'Visible','off');
    maxenv = matsel(envdata,frames,plotframes(t),1,clusterIdx(t)+1);
    % max env val
    data_y = 0.6*(arglist.voffsets(t)+maxenv-ymin)/height;
    if (data_y > pos(2)+0.6*pos(4))
        data_y = pos(2)+0.6*pos(4);
    end

    % plot the oblique line
    l1 = plot([(plottimes(t)-pmin)/pwidth topoleft + 1/pos(3)*(t-1)*1.2*topowidth + (topowidth*0.6)], [data_y 0.653]); % 0.68 is bottom of topo maps

    % match cluster number and color using colorlog
    [~, IA] = intersect(colorlog(:,1), clusterIdx(t)+1);
    if     IA < 13
        set(l1, 'Color' ,linecolors{IA},'LineWidth',1, 'LineStyle', '-');
    elseif IA < 25
        set(l1, 'Color' ,linecolors{IA-12},'LineWidth',3, 'LineStyle', ':');
    elseif IA < 37
        set(l1, 'Color' ,linecolors{IA-24},'LineWidth',1, 'LineStyle', '--');
    elseif IA < 49
        set(l1, 'Color' ,linecolors{IA-36},'LineWidth',2, 'LineStyle', '-.');
    elseif IA < 61
        set(l1, 'Color' ,linecolors{IA-48},'LineWidth',2, 'LineStyle', '-');
    else   % this is for cluster numbers more than 60 
        set(l1, 'Color', colors{16,1}   ,'LineWidth',1, 'LineStyle', ':');
    end

    hold on
    %
    %%%%%%%%%%%%%%%%%%%% add specified drawvertlineical lines %%%%%%%%%%%%%%%%%%%%%%%%%
    %
    if arglist.voffsets(t) > 0
        l2 = plot([(plottimes(t)-xmin)/width (plottimes(t)-xmin)/width],[0.6*(maxenv-ymin)/height 0.6*(arglist.voffsets(t)+maxenv-ymin)/height]);
        if isempty(intersect(colorlog(:,1), clusterIdx(t)+1))
            if     t > 60
                set(l2, 'Color', colors{16,1}         ,'LineWidth',1, 'LineStyle', ':');
            elseif t > 48
                set(l2, 'Color' ,linecolors{mod(t,12)},'LineWidth',2, 'LineStyle', '-');
            elseif t > 36
                set(l2, 'Color' ,linecolors{mod(t,12)},'LineWidth',2, 'LineStyle', '-.');
            elseif t > 24
                set(l2, 'Color' ,linecolors{mod(t,12)},'LineWidth',1, 'LineStyle', '--');
            elseif t > 12
                set(l2, 'Color' ,linecolors{mod(t,12)},'LineWidth',3, 'LineStyle', ':');
            elseif t > 0
                set(l2, 'Color' ,linecolors{mod(t,12)} ,'LineWidth',1, 'LineStyle', '-');
            end
        else
            d = intersect(colorlog(:,1), clusterIdx(t)+1);
            if     d > 60
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',1, 'LineStyle', ':');
            elseif d > 48
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',2, 'LineStyle', '-');
            elseif d > 36
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',2, 'LineStyle', '-.');
            elseif d > 24
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',1, 'LineStyle', '--');
            elseif d > 12
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',3, 'LineStyle', ':');
            elseif d > 0
                set(l2, 'Color' ,linecolors{colorlog(IA, 2)},'LineWidth',1, 'LineStyle', '-');
            end
        end
    end
    set(gca,'Visible','off');
    axis([0 1 0 1]);
end % t


%
%%%%%%%%%%%%%%%%%%%%%%%%% Plot topoplots %%%%%%%%%%%%%%%%%%%%%%%%%%
%

for t=1:ntopos % left to right order  (maporder)
    axt = axes('Units','Normalized','Position',...
        [pos(3)*topoleft+pos(1)+(t-1)*head_sep*topowidth pos(2)+0.66*pos(4) ...
        topowidth topowidth*head_sep]);
    axes(axt)                             % topoplot axes
    cla

    if strcmp(arglist.downsampled, 'on')
        if arglist.gridind ~= 0
            tmp = zeros(23,23);
            tmp(:)=nan ;
            tmp(arglist.gridind) = maxproj(:,t);
            %tmp(arglist.gridind) = projERP{clusterIdx(t)}(:,plotframes(t));
        end
    elseif strcmp(arglist.downsampled, 'off')
        if arglist.gridind ~= 0
            tmp = zeros(67,67);
            tmp(:)=nan ;
            tmp(arglist.gridind) = maxproj(:,t);
            %tmp(arglist.gridind) = projERP{clusterIdx(t)}(:,plotframes(t));
        end
    end

    % check polarity of the map - if abs peak is negative and arglist.forcePositiveTopo
    % 'off', flip the topo polarity. 08/15/2013 Makoto
    if strcmp(arglist.forcePositiveTopo, 'on')
        % check topo polarity
        [~,oneDaddress] = max(abs(tmp(:)));
        [row,column] = ind2sub(size(tmp),oneDaddress);
        % if absolute maximum is negative, multiply -1 to reverse negative topo to positive 
        if tmp(row,column)<0
            tmp = tmp*-1;
        end
    end

    figure(myfig);
    if strcmp(arglist.topotype, 'inst')
        toporeplot(tmp, 'style', 'both', 'plotrad',0.5,'intrad',0.5, 'verbose', 'off');
    else % which is arglist.topytype == 'ave'
        toporeplot(STUDY.cluster(1, arglist.clust_grandERP(clusterIdx(t))).topo, 'style', 'both', 'plotrad',0.5,'intrad',0.5, 'verbose', 'off');
    end

    axis square

    %
    %%%%%%%%%%%%%%%%%%%%%%%% label components %%%%%%%%%%%%%%%%%%%%%%%
    %
    if t==1
        chid = fopen('envtopo.labels','r');
        if chid <3,
            numlabels = 1;
        else
            fprintf('Will label scalp maps with labels from file %s\n','envtopo.labels');
            compnames = fscanf(chid,'%s',[4 MAXPLOTDATACHANS]);
            compnames = compnames';
            [r, c] = size(compnames);
            for i=1:r
                for j=1:c
                    if compnames(i,j)=='.',
                        compnames(i,j)=' ';
                    end;
                end;
            end;
            numlabels=0;
        end
    end
    if numlabels == 1
        if ~isempty(complabels)
            complabel = complabels(t);
        else
            complabel = int2str(maporder(t));        % label comp. numbers
        end
    else
        complabel = compnames(t,:);              % use labels in file
    end
    text(0.00,  0.80,complabel,'FontSize',14, 'FontWeight','Bold','HorizontalAlignment','Center');
    text(0.00, -0.605,[arglist.sortedVariance ' ' sprintf('%2.1f', sortedVariance(t))],'FontSize',13, 'HorizontalAlignment','Center');

    % axt = axes('Units','Normalized','Position',[0 0 1 1],...
    axt = axes('Position',[0 0 1 1],...
        'Visible','Off','Fontsize',16);
    set(axt,'Color',axcolor);           % topoplot axes
    drawnow
end

%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot a colorbar %%%
%%%%%%%%%%%%%%%%%%%%%%%
axt = axes('Position',[pos(1)+pos(3)*1.01  pos(2)+0.675*pos(4) pos(3)*.02 pos(4)*0.09]);
h=cbar(axt);   
set(h,'YAxisLocation', 'left', 'YTick', [0 1], 'YTickLabel', {'-' '+'}, 'FontSize', 16)
axes(axall)
set(axall,'Color',axcolor);

%%%%%%%%%%%%%%%%%%%%%%%
%%% plot main title %%%
%%%%%%%%%%%%%%%%%%%%%%%
tmp = text(0.50,0.92, arglist.title,'FontSize',18,'HorizontalAlignment','Center','FontWeight','Bold');
set(tmp, 'interpreter', 'none');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% bring component lines to top %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(axall)
set(axall,'layer','top');

%
%%%%%%%%%%%%%%%%%%%%%%%%% turn on axcopy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
axcopy(gcf, 'if ~isempty(get(gca, ''''userdata'''')), eval(get(gca, ''''userdata'''')); end;');

return %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function envdata = envelope(data, envmode)  % also in release as env()
if nargin < 2
    envmode = 'avg';
end;
if strcmpi(envmode, 'rms');
    warning off; %#ok<*WNOFF>
    negflag = (data < 0);
    dataneg = negflaarglist.* data;
    dataneg = -sqrt(sum(datanearglist.*dataneg,1) ./ sum(negflag,1));
    posflag = (data > 0);
    datapos = posflaarglist.* data;
    datapos = sqrt(sum(datapos.*datapos,1) ./ sum(posflag,1));
    envdata = [datapos;dataneg];
    warning on; %#ok<*WNON>
else
    if size(data,1)>1
        maxdata = max(data); % max at each time point
        mindata = min(data); % min at each time point
        envdata = [maxdata;mindata];
    else
        maxdata = max([data;data]); % max at each time point
        mindata = min([data;data]); % min at each time point
        envdata = [maxdata;mindata];
    end
end;

return %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [STUDY, ALLEEG] = separateToposIntoGroups(STUDY, ALLEEG)
disp('Loading and separating scalp topos (done only once)...')
var2Len = size(STUDY.design(STUDY.currentdesign).variable(2).value, 2);
for cls = 2:length(STUDY.cluster)
    for var2 = 1:var2Len
        for icLen = 1:length(STUDY.cluster(1,cls).setinds{1,var2})
            tmpAllinds = STUDY.cluster(1,cls).allinds{1,var2}(icLen);
            tmpSetinds = STUDY.cluster(1,cls).setinds{1,var2}(icLen);
            tmpDataset = STUDY.design(STUDY.currentdesign).cell(tmpSetinds).dataset;
            STUDY.cluster(1,cls).topoall_group{1,var2}{1,icLen} = std_readtopo(ALLEEG, tmpDataset, tmpAllinds);
        end
    end
end



function smoothdata = myeegfilt(data, srate, locutoff, hicutoff)
disp('Applying low pass filter (Hamming).')
disp('Transition band width is the half of the passband edge frequency.')
tmpFiltData.data   = data;
tmpFiltData.srate  = srate;
tmpFiltData.trials = 1;
tmpFiltData.event  = [];
tmpFiltData.pnts   = length(data);
filtorder = pop_firwsord('hamming', srate, hicutoff/2);
tmpFiltData_done   = pop_eegfiltnew(tmpFiltData, locutoff, hicutoff, filtorder);
smoothdata         = tmpFiltData_done.data;



function [pvalList, ciList] = statPvaf(STUDY, clusterIdx, arglist, originalConvTopoErpAllClusters, normalizationFactors)

% (From orignal code)
frames = size(originalConvTopoErpAllClusters(:,arglist.totalPlotRange(1):arglist.totalPlotRange(end),:,:,:),2);

% (From original code) Find limits of the component selection window.
xmin = arglist.timerange(1);
xmax = arglist.timerange(2);
if any(arglist.limitcontribtime ~= 0)
    if arglist.limitcontribtime(1)<xmin
        arglist.limitcontribtime(1) = xmin;
    end
    if arglist.limitcontribtime(2)>xmax
        arglist.limitcontribtime(2) = xmax;
    end
    limframe1 = arglist.relativeFramesWithinPlotRange(1);
    limframe2 = arglist.relativeFramesWithinPlotRange(end);
    arglist.drawvertline(end+1) =  arglist.limitcontribtime(1);
    arglist.drawvertline(end+1) =  arglist.limitcontribtime(2);
else
    limframe1 = 1;
    limframe2 = frames;
end;
dataInterval = [limframe1, limframe2];

% Prepare parameters for bootstrap test.
alpha = arglist.statPvaf(1);
numIteration = arglist.statPvaf; 
pvalList = zeros(length(clusterIdx),2);
ciList   = zeros(length(clusterIdx),3);
designLabel = {STUDY.design(STUDY.currentdesign).variable.label};
groupFieldIdx = find(strcmp(designLabel, 'group')|strcmp(designLabel, 'session'));
%%%%%%%%%%%%%
%%% A - B %%%
%%%%%%%%%%%%%
if length(arglist.designVector)==4
    for clusterIdxIdx = 1:length(clusterIdx)
        if arglist.clusterIdxToUse < 0
            tmpClust = arglist.clust_grandERP(clusterIdx(clusterIdxIdx));
        else
            tmpClust = arglist.clusterIdxToUse(clusterIdxIdx);
        end
        clustLabel{clusterIdxIdx} = ['Cluster ' num2str(tmpClust)];

        % Check if the difference is within or between subjects.
        if isempty(groupFieldIdx)
            numIC1 = length(STUDY.cluster(1,tmpClust).topoall);
            numIC2 = length(STUDY.cluster(1,tmpClust).topoall);
            topo10 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall), [67 67 numIC1]);
            topo20 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall), [67 67 numIC2]);
        else
            numIC1 = length(STUDY.cluster(1,tmpClust).topoall_group{1, arglist.designVector(1,2)});
            numIC2 = length(STUDY.cluster(1,tmpClust).topoall_group{1, arglist.designVector(1,4)});
            topo10 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall_group{1,arglist.designVector(1,2)}), [67 67 numIC1]);
            topo20 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall_group{1,arglist.designVector(1,4)}), [67 67 numIC2]);
        end
        
        % Combine ERPs across conditions
        ERP1 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,1),arglist.designVector(1,2)}(arglist.totalPlotRange,:);
        ERP2 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,3),arglist.designVector(1,4)}(arglist.totalPlotRange,:);
        ERP1 = ERP1(dataInterval(1):dataInterval(2),:);
        ERP2 = ERP2(dataInterval(1):dataInterval(2),:);
        combinedERP = [ERP1 ERP2];
        
        % Combine vectorized scalp topography
        topo11 = topo10(1:3:67,1:3:67,:);
        topo12 = reshape(topo11, [23^2 numIC1]);
        topo13 = topo12(~isnan(topo12));
        topo14 = reshape(topo13, [length(topo13)/numIC1 numIC1]);
        topo21 = topo20(1:3:67,1:3:67,:);
        topo22 = reshape(topo21, [23^2 numIC2]);
        topo23 = topo22(~isnan(topo22));
        topo24 = reshape(topo23, [length(topo23)/numIC2 numIC2]);
        combinedTopos = [topo14 topo24];
        
        % Set up bootstrap iteration
        selectionNumber = floor((size(topo14,2)+size(topo24,2))/2);
        if mod(selectionNumber,2)==1
            selectionNumber = selectionNumber + 1;
        end
        
        % Calculate truePvaf
        convStack1 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,1),arglist.designVector(1,2));
        convStack2 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,3),arglist.designVector(1,4));
        
        conv1 = convStack1(:,:,clusterIdx(clusterIdxIdx));
        full1    = sum(convStack1,3);
        varFull1 = mean(var(full1));
        less1    = full1-(conv1);
        varLess1 = mean(var(less1));
        pvaf1    = 100-100*(varLess1./varFull1);
        
        conv2 = convStack2(:,:,clusterIdx(clusterIdxIdx));
        full2    = sum(convStack2,3);
        varFull2 = mean(var(full2));
        less2    = full2-(conv2);
        varLess2 = mean(var(less2));
        pvaf2    = 100-100*(varLess2./varFull2);
        
        trueDeltaPvaf = pvaf1-pvaf2;

%         % Alternatively
%         conv1    = convStack1(:,:,clusterIdx(clusterIdxIdx));
%         conv2    = convStack2(:,:,clusterIdx(clusterIdxIdx));
%         full1    = sum(convStack1,3);
%         full2    = sum(convStack2,3);
%         varFull  = mean(var(full1-full2));
%         less1    = full1-(conv1);
%         less2    = full2-(conv2);
%         varLess  = mean(var(less1-less2));
%         trueDeltaPvaf = 100-100*(varLess/varFull);
        
        % Compute surrogate pvaf
        surroStack1 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,1),arglist.designVector(1,2));
        surroStack2 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,3),arglist.designVector(1,4));
        
        % Enter the main loop
        surroPvafDistribution = zeros(numIteration,1);
        for iterationIdx = 1:numIteration
            if mod(iterationIdx,100)==0
                disp(sprintf('Cluster %.0f (%.0f/%.0f), iteration %.0f/%.0f', tmpClust, clusterIdxIdx, length(clusterIdx), iterationIdx, numIteration))
            end
            
            % Divide the bootstrap index equiprobably between conditions (by Zhou, Gao, Hui, 1997)
            bootIdxIdx = randi(size(combinedERP,2), size(combinedERP,2), 1);
            bootIdx1 = bootIdxIdx(1:size(ERP1,2));
            bootIdx2 = bootIdxIdx(size(ERP1,2)+1:end);
            
            % Compute surrogate ERP
            surroERP1 = combinedERP(:,bootIdx1);
            surroERP2 = combinedERP(:,bootIdx2);
            
            % Compute surrogate Topos
            surroTopo1 = combinedTopos(:,bootIdx1);
            surroTopo2 = combinedTopos(:,bootIdx2);
            
            % Convolve topo x ERP, then normalize projection
            surroConv1 = surroTopo1*surroERP1'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,2));
            surroConv2 = surroTopo2*surroERP2'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,4));
            
            % Stack surrogate topo_x_ERP
            surroStack1(:,:,clusterIdx(clusterIdxIdx)) = surroConv1;
            surroStack2(:,:,clusterIdx(clusterIdxIdx)) = surroConv2;
            
            % Compute pvaf of surrogate data
            surro1Full       = sum(surroStack1,3);
            surro1ToSubtract = sum(surroStack1(:,:,clusterIdx(clusterIdxIdx)),3);
            surroPvaf1 = 100-100*(mean(var(surro1Full-surro1ToSubtract))/mean(var(surro1Full)));

            surro2Full       = sum(surroStack2,3);
            surro2ToSubtract = sum(surroStack2(:,:,clusterIdx(clusterIdxIdx)),3);
            surroPvaf2 = 100-100*(mean(var(surro2Full-surro2ToSubtract))/mean(var(surro2Full)));
            
            surroPvafDistribution(iterationIdx,1) = surroPvaf1 - surroPvaf2;

%             % Alternatively
%             conv1    = surroStack1(:,:,clusterIdx(clusterIdxIdx));
%             conv2    = surroStack2(:,:,clusterIdx(clusterIdxIdx));
%             full1    = sum(surroStack1,3);
%             full2    = sum(surroStack2,3);
%             varFull  = mean(var(full1-full2));
%             less1    = full1-(conv1);
%             less2    = full2-(conv2);
%             varLess  = mean(var(less1-less2));
%             surroPvafDistribution(iterationIdx,1) = 100-100*(varLess/varFull);
            
        end
        %[~,~,~,stat] = ttest2(var(condition1Full(:,arglist.pvafFrames)-condition1Selected(:,arglist.pvafFrames),1), var(condition1Full(:,arglist.pvafFrames)))
        pvalList(clusterIdxIdx,1)   = stat_surrogate_pvals(surroPvafDistribution(:,1), trueDeltaPvaf, 'upper');
        pvalList(clusterIdxIdx,2:3) = stat_surrogate_ci(surroPvafDistribution(:,1), 0.05, 'upper')';
    end
    

    
%%%%%%%%%%%%%%%%%%%%%%%%%
%%% (A - B) - (C - D) %%%
%%%%%%%%%%%%%%%%%%%%%%%%%     
elseif length(arglist.designVector)==8
    for clusterIdxIdx = 1:length(clusterIdx)
        if arglist.clusterIdxToUse < 0
            tmpClust = arglist.clust_grandERP(clusterIdx(clusterIdxIdx));
        else
            tmpClust = arglist.clusterIdxToUse(clusterIdxIdx);
        end
        clustLabel{clusterIdxIdx} = ['Cluster ' num2str(tmpClust)];
        
        % Check if the difference is within or between subjects.
        if isempty(groupFieldIdx)
            numIC1 = length(STUDY.cluster(1,tmpClust).topoall);
            numIC2 = length(STUDY.cluster(1,tmpClust).topoall);
            topo10 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall), [67 67 numIC1]);
            topo20 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall), [67 67 numIC2]);
        else
            numIC1 = length(STUDY.cluster(1,tmpClust).topoall_group{1, arglist.designVector(1,2)});
            numIC2 = length(STUDY.cluster(1,tmpClust).topoall_group{1, arglist.designVector(1,4)});
            topo10 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall_group{1,arglist.designVector(1,2)}), [67 67 numIC1]);
            if numIC2 == numIC1 % ERP1 and ERP2 from same group
                numIC2 = length(STUDY.cluster(1,tmpClust).topoall_group{1, arglist.designVector(1,6)});
                topo20 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall_group{1,arglist.designVector(1,6)}), [67 67 numIC2]);
                similarGroup = 1;
            else
                topo20 = reshape(cell2mat(STUDY.cluster(1,tmpClust).topoall_group{1,arglist.designVector(1,4)}), [67 67 numIC2]);
                similarGroup = 0;
            end
        end
            
        % combine ERP
        ERP1 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,1),arglist.designVector(1,2)}(arglist.pvafFrames,:);
        ERP2 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,3),arglist.designVector(1,4)}(arglist.pvafFrames,:);
        ERP3 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,5),arglist.designVector(1,6)}(arglist.pvafFrames,:);
        ERP4 = STUDY.cluster(1,tmpClust).erpdata{arglist.designVector(1,7),arglist.designVector(1,8)}(arglist.pvafFrames,:);
              
        combinedERP1 = [ERP1 ERP2];
        combinedERP2 = [ERP3 ERP4];
        
        clear ERP*
        
        % combine topo
        topo11 = topo10(1:3:67,1:3:67,:);
        topo12 = reshape(topo11, [23^2 numIC1]);
        topo13 = topo12(~isnan(topo12));
        topo14 = reshape(topo13, [length(topo13)/numIC1 numIC1]);
              
        topo21 = topo20(1:3:67,1:3:67,:);
        topo22 = reshape(topo21, [23^2 numIC2]);
        topo23 = topo22(~isnan(topo22));
        topo24 = reshape(topo23, [length(topo23)/numIC2 numIC2]);
        
        if similarGroup == 0
            combinedTopo1 = [topo14 topo24];
            combinedTopo2 = [topo14 topo24];
        elseif similarGroup == 1
            combinedTopo1 = [topo14 topo14];
            combinedTopo2 = [topo24 topo24];
        end
        
        clear topo1* topo2*
                
        % calculate trueDeltaPvaf       
        convStack1 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,1),arglist.designVector(1,2));
        convStack2 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,3),arglist.designVector(1,4));
        convStack3 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,5),arglist.designVector(1,6));
        convStack4 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,7),arglist.designVector(1,8));
      
        conv1 = convStack1(:,:,clusterIdx);
        conv2 = convStack2(:,:,clusterIdx);
        conv3 = convStack3(:,:,clusterIdx);
        conv4 = convStack4(:,:,clusterIdx);

        full1    = sum(convStack1,3);
        varFull1 = mean(var(full1));
        less1    = full1-(conv1);
        varLess1 = mean(var(less1));
        pvaf1    = 100-100*(varLess1/varFull1);
        
        full2    = sum(convStack2,3);
        varFull2 = mean(var(full2));
        less2    = full2-(conv2);
        varLess2 = mean(var(less2));
        pvaf2    = 100-100*(varLess2/varFull2);
        
        full3    = sum(convStack3,3);
        varFull3 = mean(var(full3));
        less3    = full3-(conv3);
        varLess3 = mean(var(less3));
        pvaf3    = 100-100*(varLess3/varFull3);
        
        full4    = sum(convStack4,3);
        varFull4 = mean(var(full4));
        less4    = full4-(conv4);
        varLess4 = mean(var(less4));
        pvaf4    = 100-100*(varLess4/varFull4);
        
        trueDeltaPvaf = (pvaf1 - pvaf2) - (pvaf3 - pvaf4);
        
        clear conv*
        
        % Prepare bootstrap. Initialize envtopo stack data and loop
        surroStack1 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,1),arglist.designVector(1,2));
        surroStack2 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,3),arglist.designVector(1,4));
        surroStack3 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,5),arglist.designVector(1,6));
        surroStack4 = originalConvTopoErpAllClusters(:,arglist.pvafFrames,:,arglist.designVector(1,7),arglist.designVector(1,8));
      
        deltaPvaf = zeros(numIteration,1);
        for iterationIdx = 1:numIteration
            if mod(iterationIdx,100)==0
                disp(['Cluster ' num2str(tmpClust) ' iteration ' num2str(iterationIdx) '...'])
                toc
            end
            
            bootstrpIdx1 = randi(size(combinedERP1,2), [1 size(combinedERP1,2)]);
            bootstrpIdx2 = randi(size(combinedERP2,2), [1 size(combinedERP2,2)]);
            
            % surrogate ERP
            surroERP1 = combinedERP1(:,bootstrpIdx1(1:numIC1));
            surroERP2 = combinedERP1(:,bootstrpIdx1(numIC1+1:end));
            surroERP3 = combinedERP2(:,bootstrpIdx2(1:numIC2));
            surroERP4 = combinedERP2(:,bootstrpIdx2(numIC2+1:end));
            
            % surrogate Topos
            surroTopo1 = combinedTopo1(:,bootstrpIdx1(1:numIC1));
            surroTopo2 = combinedTopo1(:,bootstrpIdx1(numIC1+1:end));
            surroTopo3 = combinedTopo2(:,bootstrpIdx2(1:numIC2));
            surroTopo4 = combinedTopo2(:,bootstrpIdx2(numIC2+1:end));    
            
            % convolve topo x ERP, normalize projection
            surroConv1 = surroTopo1*surroERP1'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,2));
            surroConv2 = surroTopo2*surroERP2'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,4));
            surroConv3 = surroTopo3*surroERP3'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,6));
            surroConv4 = surroTopo4*surroERP4'...
                /normalizationFactors(1,1,clusterIdx(clusterIdxIdx),1, arglist.designVector(1,8));
                        
            % replace surrogate Topo
            surroStack1(:,:,clusterIdx(clusterIdxIdx)) = surroConv1;
            surroStack2(:,:,clusterIdx(clusterIdxIdx)) = surroConv2;
            surroStack3(:,:,clusterIdx(clusterIdxIdx)) = surroConv3;
            surroStack4(:,:,clusterIdx(clusterIdxIdx)) = surroConv4;
            
            surroStackSummed1 = sum(surroStack1,3);
            surroStackSummed2 = sum(surroStack2,3);
            surroStackSummed3 = sum(surroStack3,3);
            surroStackSummed4 = sum(surroStack4,3);
            
            % compute pvaf
            surroFull1    = (surroStackSummed1);
            varSurroFull1 = mean(var(surroFull1));
            surroLess1    = surroFull1 -(surroConv1);
            varSurroLess1 = mean(var(surroLess1));
            pvaf1         = 100-100*(varSurroLess1/varSurroFull1);
       
            surroFull2    = (surroStackSummed2);
            varSurroFull2 = mean(var(surroFull2));
            surroLess2    = surroFull2 -(surroConv2);
            varSurroLess2 = mean(var(surroLess2));
            pvaf2         = 100-100*(varSurroLess2/varSurroFull2);
                      
            surroFull3    = (surroStackSummed3);
            varSurroFull3 = mean(var(surroFull3));
            surroLess3    = surroFull3 -(surroConv3);
            varSurroLess3 = mean(var(surroLess3));
            pvaf3         = 100-100*(varSurroLess3/varSurroFull3);
    
            surroFull4    = (surroStackSummed4);
            varSurroFull4 = mean(var(surroFull4));
            surroLess4    = surroFull4 -(surroConv4);
            varSurroLess4 = mean(var(surroLess4));
            pvaf4         = 100-100*(varSurroLess4/varSurroFull4);
            
            deltaPvaf(iterationIdx) = (pvaf1 - pvaf2) - (pvaf3 - pvaf4);
        end
        pvalList(clusterIdxIdx,1)   = stat_surrogate_pvals(deltaPvaf(:,1), trueDeltaPvaf, 'upper');
        pvalList(clusterIdxIdx,2:3) = stat_surrogate_ci(deltaPvaf(:,1), 0.05, 'upper')';
    end
end

% Display results
for n = 1:size(pvalList,1)
    if pvalList(n,1)<0.05
        disp(sprintf('\n\n%s, %.0f-%.0f ms: p < %.4f, Delta pvaf %.1f (95%% C.I. %.1f)\n\n',...
            clustLabel{n}, STUDY.cluster(1,2).erptimes(arglist.pvafFrames(1)), STUDY.cluster(1,2).erptimes(arglist.pvafFrames(end)),...
            pvalList(n,1), trueDeltaPvaf, pvalList(n,3)))
    else
        disp(sprintf('\n\n%s, %.0f-%.0f ms: p = %.3f, Delta pvaf %.1f (95%% C.I. %.1f)\n\n',...
            clustLabel{n}, STUDY.cluster(1,2).erptimes(arglist.pvafFrames(1)), STUDY.cluster(1,2).erptimes(arglist.pvafFrames(end)),...
            pvalList(n,1), trueDeltaPvaf, pvalList(n,3)))
    end
end