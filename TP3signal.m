clear all
close all
clc
load("ecg.mat");
x=ecg;
%%
fs=500;
N=length(x)
ts=1/fs
%Representation du signal en fct du temps
t=(0:N-1)*ts;
plot(t,x);
title("Signal ECG");
%%
%%spectre Amplitude
y = fft(x);
f = (0:N-1)*(fs/N);
fshift = (-N/2:N/2-1)*(fs/N);
plot(fshift,fftshift(abs(y)))
title("spectre Amplitude")


%%
%%suppression du bruit des movements de corps
h = ones(size(x));
fh = 0.5;
index_h = ceil(fh*N/fs);
h(1:index_h)=0;
h(N-index_h+1:N)=0;
%TFDI pour restituer le signal filtré
ecg1_freq = h.*y;
ecg1 =ifft(ecg1_freq,"symmetric");
%Nouveau signal
plot(t,ecg1);
title("signal filtré")
%%
plot(t,x-ecg1);
title("La différence")
%%
% Elimination interference 50Hz
Notch = ones(size(x));
fn = 50;
index_hcn = ceil(fn*N/fs)+1;
Notch(index_hcn)=0;
Notch(index_hcn+2)=0;
ecg2_freq = Notch.*fft(ecg1);
ecg_2 =ifft(ecg2_freq,"symmetric");
subplot(2,1,1)
plot(t,ecg);
xlim([0.5 1.5])
subplot(2,1,2)
plot(t,ecg_2);
title("signal filtré")
xlim([0.5 1.5])

%%
pass_bas = zeros(size(x));
fc = 40;
index_hcb = ceil(fc*N/fs);
pass_bas(1:index_hcb)=1;
pass_bas(N-index_hcb+1:N)=1;
ecg3_freq = pass_bas.*fft(ecg_2);
ecg3 =ifft(ecg3_freq,"symmetric");
subplot(2,1,1)
plot(t,ecg,"linewidth",1.5);
xlim([0.5 1.5])
subplot(2,1,2)
plot(t,ecg3);
xlim([0.5 1.5])
%%
plot(t,ecg3);
xlim([0.5 1.5])

%%
[b,lags] = xcorr(ecg3,ecg3);
stem(lags/fs,b)