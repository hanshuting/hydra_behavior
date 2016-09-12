function fieldstring=dispStructNested(structvar, substructvar, filename)
%Display nested structures in 'structvar'; 'substructvar' is used in
%      recursion, must be [] in main call. Result string is saved in
%      file 'filename'
%filename: filename to use for output
%fieldstring: output (with \n linefeeds)
%example call datastructure(saliencyData,[],'saliencyData.txt')

%store format spacing, set compact:
fs=get(0,'FormatSpacing');
format compact

%lines and double lines for display:
lines=repmat('-',1,25);
dlines=repmat('=',1,25);

%get name of variable from call
if exist('substructvar') && ~isempty(substructvar)
    fieldstring = sprintf('%s\n%s\n',substructvar,lines);
else
    fieldstring = sprintf('%s\n%s\n',inputname(1),lines);
end

if isstruct(structvar)
    %display main structure at current level of recursion:
    fieldstring=sprintf('\n%s %s',fieldstring,evalc('disp(structvar)')); 
    fieldstring=sprintf('%s%s \n',fieldstring,dlines);
    %get fields names at current level of recursion:
    fields=fieldnames(structvar);
    for k=1:length(fields)
        if isstruct(eval(['structvar.' fields{k}]))
            %recursive call to get substructures:
            fieldstring=[fieldstring dispStructNested(eval(['structvar.' fields{k}]),fields{k})];
        end
    end
end
%save result
if exist('filename')
     % in main call
     fid=fopen(filename,'w');
     fprintf(fid, fieldstring);
     fclose(fid);
end

%rstore format spacing
set(0,'FormatSpacing',fs);

end