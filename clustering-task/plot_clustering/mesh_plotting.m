clear
close all;
clc

load dancer.mat
% 

timestamp = 470; %(out of 573)

% dance_mesh = squeeze(X(:,timestamp,1:3));
% dance_mesh(:,1) = rescale(dance_mesh(:,1),0,168);
% dance_mesh(:,2) = rescale(dance_mesh(:,2),0,212);
% dance_mesh(:,3) = rescale(dance_mesh(:,3),0,178);

figure()
% scatter3(dance_mesh(:,1),dance_mesh(:,3),dance_mesh(:,2),'Marker','.');
for timestamp=1:T
    dance_mesh = squeeze(X(:,timestamp,[1,2,3]));
    dance_mesh(:,1) = rescale(dance_mesh(:,1),0,168);
    dance_mesh(:,2) = rescale(dance_mesh(:,2),0,212);
    dance_mesh(:,3) = rescale(dance_mesh(:,3),0,178);
    scatter3(dance_mesh(:,1),dance_mesh(:,3),dance_mesh(:,2),'Marker','.');
    drawnow;
end
