function r = getNestedField(a, fieldnm)
% GETNESTEDFIELD returns a cell containing fields with the same name from array of
% nested field

r = cell(length(a),1);
for ii = 1:length(a)
    eval(sprintf('r{ii} = a(ii).%s;',fieldnm));
end

end