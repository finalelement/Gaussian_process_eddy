%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Authors - Colin Hanse & Vish Nath

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Notes
% If shit doesn't go down then check on the minimum angle stuff again
% for two 3D vectors which are g and g_prime. 
function main
    
    addpath(genpath('~/masimatlab/trunk/users/blaberj/matlab/justinlib_v1_7_0'));
    addpath('~/masimatlab/trunk/users/blaberj/dwmri_libraries/dwmri_visualizer_v1_2_0');
    addpath('~/NIFTI');
    addpath('/fs4/masi/hansencb/eddy_project/matlab_src/return_angle_two_ngs.m');
    addpath('/fs4/masi/hansencb/eddy_project/matlab_src/gpr_spherical_covar.m');
    addpath('/fs4/masi/hansencb/eddy_project/matlab_src/gpr_K_matrix.m');

    % Load the data
    %bvecs = importdata('../scans/401_WIP_dti25_9_3000b/BVEC/bvec.txt');
    bvecs = dlmread('/fs4/masi/hansencb/eddy_project/scans/BVEC/bvec.txt');
    nifti = load_untouch_nii('/fs4/masi/hansencb/eddy_project/scans/NIFTI/401.nii');

    %dwmri = nifti_utils.load_untouch_nii4D_vol_scaled('./scans/401_WIP_dti25_9_3000b/401.nii.gz','double');

    vox = nifti.img(48,48,19,2:97);
    vox = reshape(vox,[1 96]);
    vox = double(vox);
    
    gradient_dirs = bvecs';

    % Get rid of b0 from gradient directions and the data BOTH !
    gradient_dirs = gradient_dirs(2:97,:);

    %{
    % Manual Calculation of Covariance Matrix
    K = zeros(9216,2);

    counter = 1;
    for i=1:96
        for j=1:96
            [temp, temp2] = test_spherical_covar(gradient_dirs(i,:),gradient_dirs(j,:),1.23);
            K(counter,:) = [temp,temp2];
            counter = counter + 1;
        end
    end

    figure
    scatter(K(:,2),K(:,1))
    %}
    
    % Put Gradient dirs for X and signal for Y
    

    beta = [1.23 1 1];
    gpr = fitrgp(gradient_dirs,vox,'kernelfunction',@gpr_K_matrix,'kernelparameters',beta,'verbose',1);
    
    % Plot the predictions
    
    figure
    plot(y,'r')
    hold on;
    plot(predict(gpr,gradient_dirs),'b')
    
    
    
end



