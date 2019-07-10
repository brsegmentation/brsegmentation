% --- Developed by Mainak Jas, IIT Kharagpur --- %
%
% Double force implementation of Demon's algorithm
%
% Inputs: 
% -------------------------------------------
% S: Static Image 
% M: Moving Image
% iterations: Maximum iterations
% sigma: sigma for gaussian smoothing
% alpha: noise factor
% sk: speed up factor
%
% Outputs:
% -------------------------------------------
% M: Registered Image
% val : Performance paramters from the registration
%
% -------------------------------------------
% References
% -------------------------------------------
% Wang et. al., Validation of an accelerated
% 'demons' algorithm for deformable image
% registration in radiation therapy

function [M,val] = demons(S,M,iterations,sigma,alpha,sk)

% The transformation fields
Tx=zeros(size(M)); Ty=zeros(size(M));

% Find gradient of static image
[Sy,Sx] = gradient(S);

% Initialise
Istat = M; Istart = M;
val.crr(1:iterations) = 0;      % 2-D cross correlation
t0 = 0; t1 = 0; t2 = 0; t3 = 0; t4 = 0;
Gsmooth=fspecial('gaussian',6*sigma,sigma);

fprintf('\nStarting Deformable Demons Registration ...\n')

% Uncomment to look at the image transformation during registration
% subplot(1,2,1); imshow(S);
% subplot(1,2,2); imshow(M);
% h = get(gca,'Children');

t0s = tic;

for itt=1:iterations
            
        % Difference image between moving and static image
        Idiff=M-S;                                           

        % Gradient vector of moving image
        [My,Mx] = gradient(M);          
                      
        t1s = tic;        
        %Ux and Uy are the components of the displacement vector
        Ux = -Idiff.*((Sx./((Sx.^2+Sy.^2)+alpha*alpha*Idiff.^2))+(Mx./((Mx.^2+My.^2)+alpha*alpha*Idiff.^2)));
        Uy = -Idiff.*((Sy./((Sx.^2+Sy.^2)+alpha*alpha*Idiff.^2))+(My./((Mx.^2+My.^2)+alpha*alpha*Idiff.^2)));
        t1 = t1 + toc(t1s);
        
        % When divided by zero
        Ux(isnan(Ux))=0; Uy(isnan(Uy))=0;
        
        t2s = tic;        
        % Smooth the transformation field               
        Uxs=sk*imfilter(Ux,Gsmooth);
        Uys=sk*imfilter(Uy,Gsmooth);
        t2 = t2 + toc(t2s);
        
        t3s = tic;
        % Find stopping criteria
        val.crr(itt) = corr2(S,M);
        t3 = t3 + toc(t3s);
        
        % Add the new transformation field to the total transformation field.
        Tx=Tx+Uxs;
        Ty=Ty+Uys;
        
        % Bilinear interpolation
        t4s = tic;
        M = movepixels(Istart,Tx,Ty,[],1); % Faster because this has been implemented using multi-threading
        t4 = t4 + toc(t4s);
        
        % Uncomment to look at image transformation during registration
        % set(h,'CData', M); drawnow;
        if itt>10 & ((val.crr(itt) - val.crr(itt-10))< 0.0001)
             break;
        end          
end

t0 = t0 + toc(t0s);

% Print results
fprintf('Time taken = \n');
fprintf('Iterations: %d\nTotal: %f secs\nDisplacement vector: %f secs\nGaussian smoothing: %f secs\nStopping criteria: %f secs\nInterpolation %f secs\n',itt,t0,t1,t2,t3,t4);

% Performance parameters
val.time = [itt,t0,t1,t2,t3,t4];

end