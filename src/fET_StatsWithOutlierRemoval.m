% Outlier removal -- being mindful of low N trials in some cases
% -> we use the MAD per participant, variable (nFix, nSwitch, decLat) and
% trialType, then remove whole trial if one variable is bad
% /!\ nSwitch is very discrete -> median not appropriate -> use a frequency
% approach (remove very rare alues e.g. happening <5% of the time)
%
% (This function could be improved by iterating over variables and making
% the overall + difference score values more automatic but ok for now)
%

function T_out = fET_StatsWithOutlierRemoval(idx, session, T_in, T_out, trialTypes, opts)

arguments
    idx   struct
    session categorical
    T_in  table
    T_out table
    trialTypes (1,:) cell {mustBeText, mustBeMember(trialTypes, {'Corr', 'Incorr', 'PriorCorr', 'PriorIncorr', 'Easy', 'Medium', 'Hard', 'xHard', 'Harder'})}
    opts.threshMed   double = 6
    opts.threshFreq  double = 5
end

% -- Loop over trialTypes
for iTrialType = length(trialTypes):-1:1
    % Get current trial type
    trialType = trialTypes{iTrialType};
    % Find outliers
    isNotOutlier{iTrialType} = fET_OutlierRemoval(idx, T_in, trialType, threshMed=opts.threshMed, threshFreq=opts.threshFreq);
    % Calculate mean without outliers
    % (This returns a NaN for empty arrays, not a zero: ok for later stats)
    iSession = find(T_out.session == session);
    T_out.(strcat('nFixExpB_', trialType))(iSession)        = mean(T_in.nFixB_expl(isNotOutlier{iTrialType}.allVars),'omitmissing');
    T_out.(strcat('nSwitchExpB_', trialType))(iSession)     = mean(T_in.nSwitchesB_expl(isNotOutlier{iTrialType}.allVars),'omitmissing');
    T_out.(strcat('decLat_', trialType))(iSession)          = mean(T_in.dur_deci(isNotOutlier{iTrialType}.allVars),'omitmissing');
end
% -- Get also the overall and difference score values IF we're in the prior accuracy conditions
if length(trialTypes) == 2 && strcmp(trialTypes{1},'PriorCorr') && strcmp(trialTypes{2}, 'PriorIncorr')
    % Find outliers
    isNotOutlierOverall = [isNotOutlier{1}.allVars; isNotOutlier{2}.allVars];
    % Calculate mean without outliers
    % (This returns a NaN for empty arrays, not a zero: ok for later stats)
    iSession = find(T_out.session == session);
    T_out.nFixExpB(iSession)        = mean(T_in.nFixB_expl(isNotOutlierOverall),'omitmissing');
    T_out.nSwitchExpB(iSession)     = mean(T_in.nSwitchesB_expl(isNotOutlierOverall),'omitmissing');
    T_out.decLat(iSession)          = mean(T_in.dur_deci(isNotOutlierOverall),'omitmissing');
    % Also calculate difference scores
    iSession = find(T_out.session == session);
    T_out.nFixExpB_Diff        = T_out.(strcat('nFixExpB_', trialTypes{2})) - T_out.(strcat('nFixExpB_', trialTypes{1}));
    T_out.nSwitchExpB_Diff     = T_out.(strcat('nSwitchExpB_', trialTypes{2})) - T_out.(strcat('nSwitchExpB_', trialTypes{1}));
    T_out.decLat_Diff          = T_out.(strcat('decLat_', trialTypes{2})) - T_out.(strcat('decLat_', trialTypes{1}));

end

end