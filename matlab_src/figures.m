
images = load('eddy_images.mat');

% all_raw = load_untouch_nii('../scans/dwmri_all.nii.gz');
% all_raw = all_raw.img;
% H = load_untouch_nii('../scans/field.nii.gz');
% H = H.img;

derivPhiField = images.derivPhiField;

phiField = images.h;

eddy_jesper = images.eddy_dwmri;

raw = images.dwmri;

cor_space = images.S;
S(isnan(S))=0;

gpr_pred = images.S_p;

diff_cor_gpr = abs(cor_space-gpr_pred);
diff_raw_jesp = abs(eddy_jesper-raw);

vol = 1;

temp = diff_cor_gpr(:,:,:,1);

figure;
subplot(1,2,1);
hist(temp(:),1000);
grid on
xlim([0 4])
ylim([0 100])
title('Matlab Eddy');
xlabel('Difference in Signal Intensities')
ylabel('Number of Voxels')

temp = diff_raw_jesp(:,:,:,1);

subplot(1,2,2);
hist(temp(:),100);
grid on
xlim([0 4])
title('FSL Eddy');
xlabel('Difference in Signal Intensities')
ylabel('Number of Voxels')



% figure;
% subplot(1,3,1);
% imagesc(squeeze(raw(:,:,1,vol)));
% title('Raw Image');
% colorbar;
% subplot(1,3,2);
% imagesc(squeeze(eddy_jesper(:,:,1,vol)));
% title('Eddy Corrected Image');
% colorbar;
% subplot(1,3,3);
% imagesc(squeeze(diff_raw_jesp(:,:,1,vol)));
% title('Difference');
% colorbar;
% 
% 
% figure;
% subplot(1,3,1);
% imagesc(squeeze(S(:,:,1,vol)));
% title('Image in Corrected Space');
% colorbar;
% subplot(1,3,2);
% imagesc(squeeze(S_p(:,:,1,vol)));
% title('GPR Prediction');
% colorbar;
% subplot(1,3,3);
% imagesc(squeeze(diff_cor_gpr(:,:,1,vol)));
% title('Difference');
% colorbar;
% 
% figure;
% subplot(2,2,1);
% imagesc(squeeze(all_raw(:,:,38,1)));
% rectangle('Position',[23 48 46-23 69-48],'EdgeColor','red')
% colorbar;
% title('Raw DWMRI Phantom');
% subplot(2,2,2);
% imagesc(H(:,:,38));
% colorbar;
% title('Phi Field Phantom');
% subplot(2,2,3);
% imagesc(squeeze(raw(:,:,1,vol)));
% colorbar;
% title('Raw DMRI Vial');
% subplot(2,2,4);
% imagesc(phiField(:,:,1));
% colorbar;
% title('Phi Field Vial');