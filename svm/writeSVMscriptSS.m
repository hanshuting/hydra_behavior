function [] = writeSVMscriptSS(svmparam,wei_str,datapath,filename)
% write bash script for running libsvm
% This version works for small datasets; when doing cross-validation for
% parameters, the entire dataset, instead of a random subset of 1000
% samples, were used.

% open file to write
fid = fopen(sprintf('%srunSVM.sh',datapath),'w');

% check data format:
fprintf(fid,'# check data format:\n');
fprintf(fid,sprintf('IN_FILE_STR="%s%s"\n',datapath,filename));
fprintf(fid,sprintf('WEI_STR="%s"\n',wei_str));
fprintf(fid,sprintf('python %s/tools/checkdata.py "$IN_FILE_STR"_train.txt\n',svmparam.src));
fprintf(fid,sprintf('python %s/tools/checkdata.py "$IN_FILE_STR"_test.txt\n',svmparam.src));
fprintf(fid,'\n');

% parameter selection with pre-defined parameter space
fprintf(fid,'# parameter selection: (optional: class weights)\n');
% fprintf(fid,sprintf(['python %s/tools/grid.py -log2c -5,15,2'...
%     ' -log2g -5,15,2 -v 5 -t 2 -b 1 $WEI_STR -svmtrain "%s/svm-train"'...
%     ' "$IN_FILE_STR"_train.txt > "$IN_FILE_STR"_grids.txt\n'],...
%     svmparam.src,svmparam.src));
% use small C values
fprintf(fid,sprintf(['python %s/tools/grid.py -log2c 5,15,1'...
    ' -log2g -5,15,2 -v 5 -t 2 -b 1 $WEI_STR -svmtrain "%s/svm-train"'...
    ' "$IN_FILE_STR"_train.txt > "$IN_FILE_STR"_grids.txt\n'],...
    svmparam.src,svmparam.src));
fprintf(fid,'\n');

% get optimal parameters
fprintf(fid,'# get optimal parameters\n');
fprintf(fid,['tac -r "$IN_FILE_STR"_grids.txt | egrep -m 1 . >'...
    '"$IN_FILE_STR"_bestcg.txt\n']);
fprintf(fid,'cg=( $(cat "$IN_FILE_STR"_bestcg.txt))\n');
fprintf(fid,'\n');

% Training: (optional: class weights)
fprintf(fid,'# Training: (optional: class weights)\n');
fprintf(fid,sprintf(['%s/svm-train -t %u -b %u -c $cg[0] -g $cg[1] $WEI_STR '...
    '"$IN_FILE_STR"_train.txt "$IN_FILE_STR".model\n'],...
    svmparam.src,svmparam.kernel,svmparam.probest));
fprintf(fid,'\n');

% classify training data
fprintf(fid,'# classify training data\n');
fprintf(fid,sprintf(['%s/svm-predict -b 1 "$IN_FILE_STR"_train.txt'...
    ' "$IN_FILE_STR".model "$IN_FILE_STR"_train_pred.txt\n'],...
    svmparam.src));
fprintf(fid,'\n');

% Test:
fprintf(fid,'# classify test data\n');
fprintf(fid,sprintf(['%s/svm-predict -b 1 "$IN_FILE_STR"_test.txt'...
    ' "$IN_FILE_STR".model "$IN_FILE_STR"_test_pred.txt\n'],...
    svmparam.src));
fprintf(fid,'\n');

end