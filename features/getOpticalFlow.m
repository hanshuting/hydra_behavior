function [flows,flowCoord] = getOpticalFlow(uu,vv,mask,time_step,cube_step)

% calculate optical flows using the results from the flow code

dims = size(uu);
tt = floor(dims(3)/time_step);
flows = cell(tt,1);
flowCoord = cell(tt,1);

for i = 1:tt
       
    tw_mask = sum(mask(:,:,(i-1)*time_step+1:i*time_step),3);
    nz = sum(tw_mask(:)~=0);
    tw_flows = zeros(nz,2*time_step);
    tw_coord = zeros(nz,2);
    for j = 1:time_step
        
        count = 0;
        
        % sort per-frame flows in the same order
        f_uu = double(squeeze(uu(:,:,(i-1)*time_step+j)));
        f_vv = double(squeeze(vv(:,:,(i-1)*time_step+j)));
%         f_uu = f_uu(tw_mask~=0);
%         f_vv = f_vv(tw_mask~=0);
%         % store by spatial patch index
%         for k = 1:numPatch
%             tw_flows = flows{i,k};
%             tw_flows(:,j*2-1) = f_uu(spInd{i}==k);
%             tw_flows(:,j*2) = f_vv(spInd{i}==k);
%             flows{i,k} = tw_flows;
%         end
%         tw_flows(:,j*2-1) = f_uu(:);
%         tw_flows(:,j*2) = f_vv(:);
        
        for xx = 1:cube_step:dims(1)
            for yy = 1:cube_step:dims(2)
                if tw_mask(xx,yy)~=0
                    count = count+1;
                    tw_flows(count,j*2-1) = f_uu(xx,yy);
                    tw_flows(count,j*2) = f_vv(xx,yy);
                    if j==1
                        tw_coord(count,1) = xx;
                        tw_coord(count,2) = yy;
                    end
                end
            end
        end
        
    end

    % exclude zero rows
    tw_flows = int16(tw_flows);
    keepInd = sum(tw_flows,2)~=0;
    flows{i} = tw_flows(keepInd,:);
    flowCoord{i} = tw_coord(keepInd,:);
%     keepInd{i} = sum(tw_flows,2)~=0;
%     flows{i} = tw_flows(keepInd{i},:);
end

end