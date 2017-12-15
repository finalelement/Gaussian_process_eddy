addpath(genpath('~/masimatlab/trunk/users/blaberj/matlab/justinlib_v1_7_0'));
addpath('~/masimatlab/trunk/users/blaberj/dwmri_libraries/dwmri_visualizer_v1_2_0');
addpath('~/NIFTI');
 
%acquisition parameters [p t]
A = [1 0 0 0.03; -1 0 0 0.03];
voxdim = [1.875 1.875 2];
%susceptability field from topup
h = load_untouch_nii('../scans/field.nii.gz');
h = h.img;

B = [0 0 0 0 0 0 0 0 0 0];
r = [0 0 0 0 0 0];

dwmri = load_untouch_nii('../scans/dwmri_all.nii.gz');
dwmri = dwmri.img;

[x y z t] = size(dwmri);

bval = importdata('../scans/dwmri_all.bval');
bvec = importdata('../scans/dwmri_all.bvec');


derivSusceptField = load_untouch_nii('../scans/derivField.nii.gz');
derivSusceptField = derivSusceptField.img;



%{
for i = t:-1:1
    if bval(i) <1
        dwmri = cat(4,dwmri(:,:,:,1:t-1),dwmri(:,:,:,t+1:end));
        bvec = [bvec(:,1:t-1) bvec(:,t+1:end)];
        bval = [bval(1:t-1) bval(t+1:end)];
        t = t+1;
    end
end
%}

i =1;
while(i<=length(squeeze(dwmri(1,1,1,:))))
    if(bval(i)~=1000)
       dwmri(:,:,:,i) = [];
       bvec(:,i) = [];
       bval(i) = [];
       t = t-1;
    else
       i = i+1;
    end
    
end


dwmri = dwmri(23:46,48:69,37:39,1:t/2);

h = h(23:46,48:69,37:39);
derivSusceptField = derivSusceptField(23:46,48:69,37:39);

bvec = bvec(:,1:t/2);
bval = bval(1:t/2);

[x y z t] = size(dwmri);


%dwmri(:,:,:,end) = [];
%bvec(:,end) = [];
%bval(end) = [];



%URGENT: M doesn't seem to be at geocenter exactly
M = voxel2mm(x,y,z,1.875,1.875,2);

vox_coord = zeros(x,y,z,3);
for i = 1:x
    for j = 1:y
        for k = 1:z
            vox_coord(i,j,k,:) = [i j k];
        end
    end
end

%for so many iterations, do eddy
%for iter = 1:5

S = zeros(x,y,z,t);
big_derivPhiField = dwmri;

disp('Converting to corrected space');
for i = 1:t
    tic
    %VOXEL SPACE OR MM SPACE FOR EDDY/TOPUP?  
    e = eddyField(x,y,z,B);
    
    %use the correct acquisition params
%     if i <= t/2
%         a = A(1,:);
%     else---
%         a = A(2,:);
%     end
    a=A(1,:);
    
    X_p = f2s(x,y,z,r,M,h,e,a,vox_coord);

    [e_x, e_y, e_z] = eddyDerivField(x,y,z,B);
    %[h_x, h_y, h_z] = susceptDerivField([1 x],[1 y],[1 z],voxdim, 4, '../scans/topup_out_fieldcoef.nii.gz');


    derivPhiField = e_x + derivSusceptField;

    f_p = interp3(squeeze(dwmri(:,:,:,i)),squeeze(X_p(:,:,:,1)),squeeze(X_p(:,:,:,2)),squeeze(X_p(:,:,:,3)));

    S(:,:,:,i) = f_p.*derivPhiField;
    toc
end


% %gaussian process prediction
% gradient_dirs = bvec';
% S_p = S;
% 
% disp('Drawing predictions from GP');
% for i = 1:x
%     for j= 1:y
%         for k = 1:z
%             tic
%             vox = squeeze(S(i,j,k,:));
%             vox(isnan(vox)) = 0;
%             beta = [1.23 1 1];
%             gpr = fitrgp(gradient_dirs,vox,'kernelfunction',@gpr_K_matrix,'kernelparameters',beta,'verbose',0);
%             p_vox = predict(gpr,gradient_dirs);
%             S_p(i,j,k,:) = p_vox;
%             toc
%         end
%     end
% end
% pause(1);
% 
%TODO: from s to f space
F = S;
for i=1:t
    tic
    e = eddyField(x,y,z,B);
    a = A(1,:);
    
    X_p = s2f(x,y,z,r,M,h,e,a,vox_coord);
    
    [e_x, e_y, e_z] = eddyDerivField(x,y,z,B);
    %[h_x, h_y, h_z] = susceptDerivField([1 x],[1 y],[1 z],voxdim, 4, '../scans/topup_out_fieldcoef.nii.gz');


    derivPhiField = e_x + derivSusceptField;
    %f_p = interp3(squeeze(S_p(:,:,:,i)),squeeze(X_p(:,:,:,1)),squeeze(X_p(:,:,:,2)),squeeze(X_p(:,:,:,3)));
    f_p = interp3(squeeze(S(:,:,:,i)),squeeze(X_p(:,:,:,1)),squeeze(X_p(:,:,:,2)),squeeze(X_p(:,:,:,3)));
    
    F(:,:,:,i) = f_p .* (1./derivPhiField);
    toc
end

%TODO: update eddy parameters


%end
% 
