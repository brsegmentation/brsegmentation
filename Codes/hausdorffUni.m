%% Calculate Hausdorff distance between two sets of points
% Source: First set of points
% Dest: Second set of points
% hd: Hausdorff distance
%
% ----------Manish Kumar Sharma, IIT Kharagpur ----------------------------
%
% Hausdorff distance
% ------------------
% The directional Hausdorff distance between two sets P and Q is defined as:
% dhd(P,Q) = max pcP [min qcQ [||p-q||] ].
% Hausdorff distance is defined as max(dhd(P,Q),dhd(Q,P)
%
%========================================================================== 

function hd = hausdorffUni(Dest,Source)
    smax1=0;
    for i=1:length(Source(:,1))
        smin = min(sum( bsxfun(@minus,Source(i,:),Dest).^2,2));
        if smin > smax1
            smax1=smin;
        end
    end
    
    smax2=0;
    for i=1:length(Dest(:,1))
        smin = min(sum( bsxfun(@minus,Dest(i,:),Source).^2,2));
        if smin > smax2
            smax2=smin;
        end
    end
    
    hd=sqrt(max(smax1,smax2));
end