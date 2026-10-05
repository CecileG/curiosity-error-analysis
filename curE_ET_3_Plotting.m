%% Make plots of the eyetracking data

clear all
close all

%% Define important variables
visit        = 1;        % 1/2/3
flagParallel = false;    % fathere we didn't parallelise anyway

%% Define more things and load data
% Define input/output paths (normally no need to change)
pathData         = [filesep, fullfile('Users',getenv('USER'),'Data','curE',sprintf('Visit%d',visit),'eyetracking')];
pathDataStatsOut = fullfile(pathData, '4_OutputsForStats');
pathFiguresPng   = fullfile(pwd, "Figures", sprintf('Visit%d', visit), "eyetracking");
pathFiguresSvg   = fullfile(pathFiguresPng, "Figures final vectorised");
% Add paths and parallel processing or not
addpath("src");
util.fSetUpFieldtripAndLibrariesAndParallelPool(flagParallel=flagParallel, flagLibraries=true, flagFT=false);
% For the outputs: make the folders or prompt to empty it if files are detected
util.fMkDirSafe(pathFiguresPng);
util.fMkDirSafe(pathFiguresSvg);
% Colormap
colors = linspecer(9);
%  Load data
T = readtable(fullfile(pathDataStatsOut,sprintf('visit%d_AllData_EEGandET_wholeGroup.csv',visit)));

%% Create stats tables with descriptives as in preprint suplementary materials
Variables  = {'ERN_min33to172ms', 'FRN_min457to930ms'};
TrialSets = {'Corr','Incorr','Diff'};
Groups     = {'all'};
T_S1 = fET_MakeTablesForSupplementaryTables(T, Variables, TrialSets, Groups)
writetable(T_S1, fullfile(pathDataStatsOut,sprintf('visit%d_tableS1.csv',visit)));

Variables  = {'ERN_min332to547ms', 'FRN_min46to298ms'};
TrialSets = {'Corr','Incorr','Diff'};
Groups     = {'all'};
T_S2 = fET_MakeTablesForSupplementaryTables(T, Variables, TrialSets, Groups)
writetable(T_S2, fullfile(pathDataStatsOut,sprintf('visit%d_tableS2.csv',visit)));

Variables  = {'ERN_min33to172ms', 'FRN_min457to930ms'};
TrialSets = {'Corr','Incorr','Diff'};
Groups     = {'NR', 'R'};
T_S3_EEG = fET_MakeTablesForSupplementaryTables(T, Variables, TrialSets, Groups)
writetable(T_S3_EEG, fullfile(pathDataStatsOut,sprintf('visit%d_tableS3EEG.csv',visit)));

Variables  = {'nFixExpB', 'nSwitchExpB', 'decLat'};
TrialSets = {'PriorCorr','PriorIncorr','Diff'};
Groups     = {'NR', 'R'};
T_S3_ET = fET_MakeTablesForSupplementaryTables(T, Variables, TrialSets, Groups)
writetable(T_S3_ET, fullfile(pathDataStatsOut,sprintf('visit%d_tableS3ET.csv',visit)));

Variables  = {'performance_slopeAccu', 'accuracy', 'Ntr_Test', 'Ntr_Easy', 'Ntr_Medium', 'Ntr_Hard', 'Ntr_xHard', 'age_12m', 'ASQ_Sum_12m'};
TrialSets = {};
Groups     = {'NR', 'R'};
T_S4 = fET_MakeTablesForSupplementaryTables(T, Variables, TrialSets, Groups)
writetable(T_S4, fullfile(pathDataStatsOut,sprintf('visit%d_tableS4.csv',visit)));

%% Plot relevant variables as boxplots or rainclouds or scatter plots for all, R & NR
% --- EYETRACKING VARIABLES BOXPLOTS
% Decide what to plot
groups     = {'R', 'NR'}; % can also use 'all'
trialTypes = {'PriorCorr', 'PriorIncorr'};
variables  = {'nFixExpB', 'nSwitchExpB', 'decLat'};
% And how
yL = {[-2 27], ...
    [-0.2 9.5], ...
    [0 10.6]};
args = [];
args.labels={'Post-Corr.','Post-Incorr.'};
args.colors=[colors(3,:);colors(1,:)];
% Plot
fET_PlotAndSave_Boxplots(T, pathFiguresPng, pathFiguresSvg, groups, trialTypes, variables, args, yL=yL);
% --- PERFORMANCE VARIABLE BOXPLOTS
% Decide what to plot
groups     = {'R', 'NR'};
trialTypes = {};
variables  = {'performance_slopeAccu'};
% And how
yL = {};
args = [];
args.labels = {'R', 'NR'};
args.plotLines = 0;
% Plot
fET_PlotAndSave_Boxplots(T, pathFiguresPng, pathFiguresSvg, groups, trialTypes, variables, args, yL=yL);
% --- PERFORMANCE & ERN REGRESSION
% Decide what to plot
groups = T.mirror;
variables = {'performance_slopeAccu', 'ERN_min33to172ms_Diff'};
labels = {'Performance', 'ERN (uV)'};
% Plot
fET_PlotAndSave_Regressions(T, pathFiguresPng, pathFiguresSvg, groups, variables, labels);