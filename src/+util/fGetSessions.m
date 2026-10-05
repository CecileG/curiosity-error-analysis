function idx = fGetSessions(groups, T)

arguments
    groups (1,:) cell {mustBeText, mustBeMember(groups, {'all', 'R', 'NR'})}
    T table
end

for i_Group = 1:size(groups,2)
    group = groups{i_Group};
    if strcmp(group,'all')
        idx.(group)  = 1:size(T.session,1);
    elseif strcmp(group,'R') || strcmp(group,'NR')
        % Get indices for mirror groups
        idx.(group)  = find(strcmp(T.mirror, group));
        idx.(group)  = find(strcmp(T.mirror, group));
    else
        error('Group is not defined -- edit the util function fGetSessions to define it');
    end
end

end