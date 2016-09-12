function [] = writeSVMTestScript(srcpath,datapath,svmname,filenames)
% write a bash script to run libSVM on individual test samples

fid = fopen(sprintf('%ssvmClassifyIndv.sh',datapath),'w');

% main function
fprintf(fid,'svm_test_classify () {\n');
fprintf(fid,'\n');

fprintf(fid,sprintf('IN_FILE="%s%s_"$1""\n',datapath,svmname));
fprintf(fid,'\n');

fprintf(fid,sprintf('%s/svm-predict -b 1 "$IN_FILE".txt %s%s.model "$IN_FILE"_pred.txt\n',...
    srcpath,datapath,svmname));
fprintf(fid,'\n');

fprintf(fid,'}\n');
fprintf(fid,'\n');

% loop through files
fprintf(fid,sprintf('declare -a FILENAMES=(%s)\n',filenames));
fprintf(fid,'for (( j=1; j<=${#FILENAMES[@]}; j++ ));\n');
fprintf(fid,'do\n');
fprintf(fid,'  echo ${FILENAMES[$j-1]}\n');
fprintf(fid,'  svm_test_classify ${FILENAMES[$j-1]}\n');
fprintf(fid,'done\n');

end