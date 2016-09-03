function [trackLocBatch,trackVelBatch] = extractTrackTw(tracksAll,m,n,tw,iframe)

% find similar pattern given a histogram feature by sliding a window in a
% new movie
% INPUT:
%     movieParam
%     rawCenters
%     histFeatures
%     iframe: start frame index


%% sort cubes

% initialization, final result will be stored in a cell array
trackVelBatch = cell(1,m*n);
trackLocBatch = cell(1,m*n);

%indt = 1; % index of time window
count = 1; % counting within the time window
for i = iframe+1:iframe+tw % neglect incomplete time window
    
    infomat = tracksAll{i};
    infomatPrev = tracksAll{i-1};
    
    % go through all the tracked cells in current frame
    for j = 1:size(infomat,1)
        
        indPrev = find(infomatPrev(:,1)==infomat(j,1));
        inds = infomat(j,4);
        
        % take out the matrices for modification        
        velmat = trackVelBatch{1,inds};
        locmat = trackLocBatch{1,inds};
        
        if ~isempty(indPrev) % if previous tracking information available
            

            if isempty(velmat)
                velmat(1,1) = infomat(j,1);
                velmat(1,count*2:count*2+1) = infomat(j,2:3)-infomatPrev(indPrev,2:3);
                locmat(1,1) = infomat(j,1);
                locmat(1,count*2:count*2+1) = infomat(j,2:3); 
            else
                
                % get index
                indtmp = find(velmat(:,1)==infomat(j,1));
             
                if ~isempty(indtmp)
                    velmat(indtmp,2*count:2*count+1) = infomat(j,2:3)-infomatPrev(indPrev,2:3); 
                    locmat(indtmp,2*count:2*count+1) = infomat(j,2:3);
                else % otherwise start a new row
                    velmat(end+1,1) = infomat(j,1);
                    velmat(end,2*count:2*count+1) = infomat(j,2:3)-infomatPrev(indPrev,2:3); 
                    locmat(end+1,1) = infomat(j,1);
                    locmat(end,2*count:2*count+1) = infomat(j,2:3); 
                end
            
            end
            
        end
        
        trackVelBatch{1,inds} = velmat;
        trackLocBatch{1,inds} = locmat;
        
    end
    
    count = count+1;
    
    if count > tw % this time window is finished
        
        % go through all batches and fill in zeros
        for j = 1:m*n
            velmat = trackVelBatch{1,j};
            locmat = trackLocBatch{1,j};
            if ~isempty(velmat)
                if size(velmat,2)<2*tw+1
                    velmat(:,end:2*tw+1) = 0;
                    locmat(:,end:2*tw+1) = 0;
                end
                velmat = velmat(:,2:2*tw+1);
                locmat = locmat(:,2:2*tw+1);
                trackVelBatch{1,j} = velmat;
                trackLocBatch{1,j} = locmat;
            end
        end
        
    end
    
    
end

end