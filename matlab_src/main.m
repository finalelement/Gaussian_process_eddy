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
    bvecs = dlmread('/fs4/masi/hansencb/icewater_preprocessing/ice_20171005/scans/1701_A MB2 DTI b1000 d32 RLL/BVEC/A_MB2_DTI_b1000_d32_RLL.bvec');
    nifti = load_untouch_nii('/fs4/masi/hansencb/icewater_preprocessing/ice_20171005/scans/1701_A MB2 DTI b1000 d32 RLL/NIFTI/A_MB2_DTI_b1000_d32_RLL.nii.gz');

    %dwmri = nifti_utils.load_untouch_nii4D_vol_scaled('/fs4/masi/hansencb/icewater_preprocessing/ice_20171005/scans/1701_A MB2 DTI b1000 d32 RLL/NIFTI/A_MB2_DTI_b1000_d32_RLL.nii.gz');
    [x,y,z,t] = size(nifti.img);
    
    nifti.img = double(nifti.img);
    
    % This is code for b0 normalization, it shows the exact same
    % predictions which is quite unexpected, needs to be explored further.
    %{
    %b0 = nifti.img(:,:,:,1:6);
    %mean_b0 = mean(b0,4);
    
    
    %new_data = zeros(x,y,z,t);
    % Normalize all signal intensities by the mean_b0
    %for i=1:t
    %    new_data(:,:,:,i) = squeeze(nifti.img(:,:,:,i))./mean_b0;
    %end
    %}
    
    vox = nifti.img(round(x/2),round(y/2),round(z/2),7:t);
    %vox = nifti.img(73,45,37,7:t);

    %vox = new_data(round(x/2),round(y/2),round(z/2),7:t);
    % Different Voxel Trials
    %vox = new_data(73,45,37,7:t);
    
    vox = reshape(vox,[1 (t-6)]);
    vox = double(vox);
    
    gradient_dirs = bvecs';

    % Get rid of b0 from gradient directions and the data BOTH !
    gradient_dirs = gradient_dirs(7:t,:);

    
    % Manual Calculation of Covariance Matrix
    K = zeros(9216,2);

    counter = 1;
    for i=1:31
        for j=1:31
            [temp, temp2] = test_spherical_covar(gradient_dirs(i,:),gradient_dirs(j,:),1.23);
            K(counter,:) = [temp,temp2];
            counter = counter + 1;
        end
    end

    L = zeros(9216,2);

    counter = 1;
    for i=1:31
        for j=1:31
            [temp, temp2] = test_exponential_covar(gradient_dirs(i,:),gradient_dirs(j,:),0.5);
            L(counter,:) = [temp,temp2];
            counter = counter + 1;
        end
    end
    
    figure
    %subplot(1,2,1)
    scatter(K(:,2),K(:,1))
    hold on
    %plot(K(:,2),K(:,1))
    grid on
    scatter(L(:,2),L(:,1)) 
    xlabel('Angular Distance')
    ylabel('Covariance (Arbitrary Scaling)')
    title('Single shell b-value-1000')
    % Put Gradient dirs for X and signal for Y
    

    beta = [1.23 1 1];
    gpr = fitrgp(gradient_dirs,vox,'kernelfunction',@gpr_K_matrix,'kernelparameters',beta,'verbose',1);
    
    % Plot the predictions
    
    
    %figure
    %plot(vox,'r')
    %hold on;
    %plot(predict(gpr,gradient_dirs),'b')
    
    
    figure
    % Original Signal Intensity
    subplot(1,3,1)
    plot(vox,'r')
    title('Original Signal Intensity')
    grid on
    xlabel('Gradient Directions')
    ylabel('Signal Intensity')
    %y_limits = ylim;
    ylim([-20 180])
    % Predicted After GPR
    subplot(1,3,2)
    plot(predict(gpr,gradient_dirs),'b')
    hold on
    grid on
    xlabel('Gradient Directions')
    ylabel('Predicted Signal Intensity')
    %ylim(y_limits);
    ylim([-20 180])
    % yint is equivalent to confidence intervals (green color)
    [~,~,yint] = resubPredict(gpr);
    plot(1:(t-6),yint,'g--')
    title('Predicted Signal Intensity using GPR')
    legend('Pred','Confidence Interval','Location', 'Best')
    
    % Plot the difference between original and predicted signal
    subplot(1,3,3)
    a1 = plot(vox,'r');
    hold on
    a2 = plot(predict(gpr,gradient_dirs),'b');
    a3 = plot(vox - predict(gpr,gradient_dirs)','green');
    grid on
    xlabel('Gradient Directions')
    ylabel('Signal Intensity')
    title('Superimposed Original,Predicted & Difference')
    legend('Raw','Pred','Diff','Location','Best')
    
end



