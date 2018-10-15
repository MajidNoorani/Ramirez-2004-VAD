close all
clear all


[statement,fs] = audioread('sp06_eddited.wav');
[noise,fs] = audioread('babble.wav');

statement_size=size(statement);
noise=noise(1:statement_size(1,1));

%% signal making with different SNRs :0 5 10 20

[snr,ratio]=SNR(statement,noise);
if snr~=0
    noise0=noise*sqrt(ratio);
end
noise5 = noise0 * 1/sqrt(sqrt(10));
noise10 = noise0 * 1/sqrt(10);
noise20 = noise0 *1/10;
%[snr1,ratio1]=SNR(statement,noise20);

audio0 = statement + noise0;  % noisy audio with snr = 0
audio5 = statement + noise5;
audio10 = statement + noise10;
audio20 = statement + noise20;


%% framming
% [frames] = framming(statement,fs);
[frames0] = framming(audio0,fs);
[frames5] = framming(audio5,fs);
[frames10] = framming(audio10,fs);
[frames20] = framming(audio20,fs);


%% FFT
% [frames_FFT,frq] = FFT_of_Frames(frames,fs);
% frames_FFT1 = frames_FFT(:,1:256);
% frames_FFT = frames_FFT1;

[frames0_FFT,frq] = FFT_of_Frames(frames0,fs);
frames0_FFT1 = frames0_FFT(:,1:256);
frames0_FFT = frames0_FFT1;

[frames5_FFT,frq] = FFT_of_Frames(frames5,fs);
frames5_FFT1 = frames5_FFT(:,1:256);
frames5_FFT = frames5_FFT1;

[frames10_FFT,frq] = FFT_of_Frames(frames10,fs);
frames10_FFT1 = frames10_FFT(:,1:256);
frames10_FFT = frames10_FFT1;

[frames20_FFT,frq] = FFT_of_Frames(frames20,fs);
frames20_FFT1 = frames20_FFT(:,1:256);
frames20_FFT = frames20_FFT1;

%% noise estimation
n = 5; % number of frames that are selected for estimation in first step
% noisy_frames = frames_FFT(1:n,:);
% noise_est = sum(noisy_frames)/n;

noisy_frames = frames0_FFT(1:n,:);
noise_est0 = sum(noisy_frames)/n;

noisy_frames = frames5_FFT(1:n,:);
noise_est5 = sum(noisy_frames)/n;

noisy_frames = frames10_FFT(1:n,:);
noise_est10 = sum(noisy_frames)/n;

noisy_frames = frames20_FFT(1:n,:);
noise_est20 = sum(noisy_frames)/n;

%% LTSE
% [ltse,order] = LTSE(frames_FFT,n);
[ltse0,order] = LTSE(frames0_FFT,n);
[ltse5,order] = LTSE(frames5_FFT,n);
[ltse10,order] = LTSE(frames10_FFT,n);
[ltse20,order] = LTSE(frames20_FFT,n);

%% LTSD
% threshold_up = 53;
% threshold_down = 40;
% [HR0,HR1] = decision(frames_FFT,threshold_up,threshold_down,ltse,noise_est,order,n,1,statement,fs);
threshold_up = 20;
threshold_down = 20;
[HR0_0,HR1_0] = decision(frames0_FFT,threshold_up,threshold_down,ltse0,noise_est0,order,n,1,audio0,fs);
% threshold_up5 = 25;
% threshold_down5 = 20;
[HR0_5,HR1_5] = decision(frames5_FFT,threshold_up,threshold_down,ltse5,noise_est5,order,n,3,audio5,fs);
% threshold_up10 = 25;
% threshold_down10 = 20; %23
[HR0_10,HR1_10] = decision(frames10_FFT,threshold_up,threshold_down,ltse10,noise_est10,order,n,5,audio10,fs);
% threshold_up20 = 25;
% threshold_down20 = 20;
[HR0_20,HR1_20] = decision(frames20_FFT,threshold_up,threshold_down,ltse20,noise_est20,order,n,7,audio20,fs);

figure
v = 1:4;
plot(v,[HR0_20,HR0_10,HR0_5,HR0_0])
hold on
plot(v,[HR1_20,HR1_10,HR1_5,HR1_0],'r')
set(gca, 'XTick',1:5, 'XTickLabel',{'20db','10db','5db','0db'})
axis([1 4 0 1])
title('HR1(red) and HR0(blue)')
grid on
%% plot

% figure
% subplot(3,1,1)
% plot(1:size(audio0,1), audio0)
% subplot(3,1,2)
% plot(1:size(audio5,1), audio5)
% subplot(3,1,3)
% plot(1:size(audio10,1), audio10)

