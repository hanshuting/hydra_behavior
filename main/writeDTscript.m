function [] = writeDTscript(param)
% this function generates a bash script that runs DenseTrajectory code with
% the given parameters

% open file to write
fid = fopen(sprintf('%srunDT.sh',param.dtpath),'w');

% write script
fprintf(fid,'run_dt () {\n');
fprintf(fid,'\n');

% define parameters
fprintf(fid,'L=%u\n',param.dt.L);
fprintf(fid,'W=%u\n',param.dt.W);
fprintf(fid,'NXY=%u\n',param.dt.s);
fprintf(fid,'NT=%u\n',param.dt.t);
fprintf(fid,'N=%u\n',param.dt.N);
fprintf(fid,'TL=%u\n',param.dt.tlen);
fprintf(fid,'TH=%2.1f\n',param.dt.thresh);
fprintf(fid,'\n');

% set input file information
fprintf(fid,'IN_FILE_NAME=$1\n');
fprintf(fid,'IN_FILE_PATH="%s"\n',param.segvidpath);
fprintf(fid,'OUT_FILE_PATH="%s"\n',param.dtpath);
fprintf(fid,'IN_FILE_FORMAT="$IN_FILE_PATH"$IN_FILE_NAME"_"$TL"s_"$TH"/"$IN_FILE_NAME"_"$TL"s_"$TH"_%%04d.avi"\n');
fprintf(fid,'\n');

% set output file informatioin
fprintf(fid,'if [ ! -d "$OUT_FILE_PATH"$IN_FILE_NAME"_"$TL"s_"$TH"_L_"$L"_W_"$W"_N_"$N"_s_"$NXY"_t_"$NT"" ]; then\n');
fprintf(fid,'  mkdir "$OUT_FILE_PATH"$IN_FILE_NAME"_"$TL"s_"$TH"_L_"$L"_W_"$W"_N_"$N"_s_"$NXY"_t_"$NT""\n');
fprintf(fid,'fi\n');
fprintf(fid,'OUT_FILE_FORMAT="$OUT_FILE_PATH"$IN_FILE_NAME"_"$TL"s_"$TH"_L_"$L"_W_"$W"_N_"$N"_s_"$NXY"_t_"$NT"/"$IN_FILE_NAME"_"$TL"s_"$TH"_L_"$L"_W_"$W"_N_"$N"_s_"$NXY"_t_"$NT"_%%04d.txt"\n');
fprintf(fid,'NUM_FILE=$( ls "$IN_FILE_PATH"$IN_FILE_NAME"_"$TL"s_"$TH"" | wc -l )\n');
fprintf(fid,'\n');

% run DT
fprintf(fid,'for (( i=1; i<=$NUM_FILE; i++ ))\n');
fprintf(fid,'do\n');
fprintf(fid,'  IN_FILE=$(printf "$IN_FILE_FORMAT" "$i")\n');
fprintf(fid,'  OUT_FILE=$(printf "$OUT_FILE_FORMAT" "$i")\n');
fprintf(fid,'  if [ -f $IN_FILE ] ; then\n');
fprintf(fid,'    echo "processing $IN_FILE ..."\n');
fprintf(fid,'    %s/DenseTrack $IN_FILE -L $L -W $W -N $N -s $NXY -t $NT> $OUT_FILE\n',param.dt.src);
fprintf(fid,'  else\n');
fprintf(fid,'    echo "$IN_FILE does not exist!"\n');
fprintf(fid,'  fi\n');
fprintf(fid,'done\n');
fprintf(fid,'\n');
fprintf(fid,'}\n');
fprintf(fid,'\n');

% generate a string with file names to be processed
fstr = '';
for n = 1:length(param.fileIndx)
    fname = fileinfo(param.fileIndx(n));
    fstr = [fstr,sprintf('"%s" ',fname)];
end
fstr = fstr(1:end-1);
fprintf(fid,'declare -a FILENAMES=(%s)\n',fstr);
fprintf(fid,'\n');

% loop through files
fprintf(fid,'for (( i=1; i<=${#FILENAMES[@]}; i++ ));\n');
fprintf(fid,'do\n');
fprintf(fid,'  echo $i\n');
fprintf(fid,'  run_dt ${FILENAMES[$i-1]} &\n');
% fprintf(fid,'  run_dt ${FILENAMES[$i-1]}\n');
fprintf(fid,'done\n');

end