% Create table outputs for preprint supplementary materials

function T_out = fET_MakeTablesForSupplementaryTables(T_in, Variables, TrialsSets, Groups)
 
arguments
    T_in table
    Variables (1,:) cell {mustBeText}
    TrialsSets (1,:) cell {mustBeText}
    Groups (1,:) cell {mustBeText, mustBeMember(Groups, {'all', 'NR', 'R'})}
end

T_out = table;
if isempty(TrialsSets)
    TrialsSets = {'NA'};
end
nVars = length(Variables); nSets = length(TrialsSets); nGroups = length(Groups);
iRow = 0;
for iVar = 1:nVars
    for iGroup = 1:nGroups
        for iTrialSet = 1:nSets
            % Save values for each loop index
            iRow = iRow + 1;
            curr_Var = Variables{iVar};
            curr_TrialsSet = TrialsSets{iTrialSet};
            curr_Group = Groups{iGroup};
            T_out.Variable{iRow}  = curr_Var;
            T_out.TrialsSet{iRow} = curr_TrialsSet;
            T_out.Group{iRow}     = curr_Group;
            % Get relevant column in table given variable and trialset (if provided)
            if ~strcmp(curr_TrialsSet, 'NA')
                tableVar = strcat(curr_Var, '_', curr_TrialsSet);
            else
                tableVar = curr_Var;                
            end
            % Get relevant rows in table given group
            if ~strcmp(curr_Group, 'all')
                tableRows = strcmp(T_in.mirror,curr_Group);
            else
                tableRows = 1:length(T_in.mirror);
            end
            % Get the current datset from table
            curr_data = T_in.(tableVar)(tableRows);
            % Gets descriptive stats on it
            T_out.Mean(iRow)      = round(mean(curr_data, 'omitmissing'), 2);
            T_out.Std(iRow)       = round(std(curr_data, 'omitmissing'), 2);
            T_out.Min(iRow)       = round(min(curr_data, [], 'omitmissing'), 2);
            T_out.Max(iRow)       = round(max(curr_data, [],'omitmissing'), 2);
        end
    end
end

end