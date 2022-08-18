disp('You selected FIR filtering ')
% START READ LIST DATA TEXT FILE
%MAtlab script to Implement FIR with cutoff 8KHz 
[filename,pathname]=uigetfile('*.*','Select the Input Audio');
[x,Fs]=audioread(num2str(filename));

%Filter Impelementation
Fsf=44100;%Sampling Frequency
Fp=8e3;%Passband Frequency in Hz
Fst=8.4e3; %Stop Band Frequency
Ap=1; %Passband Ripple in dB
Ast=95; %Stopband attenuation in dB

%Designing the Filter
df=designfilt('lowpassfir','PassbandFrequency',Fp,'StopbandFrequency',Fst,'PassbandRipple',Ap,'StopbandAttenuation',Ast,'SampleRate',Fsf);
fvtool(df); %Gives a visual Frequency Response Filter
xn=awgn(x,15,'measured'); %Signal Corrupted by white Gaussian Noise
y=filter(df,xn);

vals=randn(1,1000)*100;
figure;
histogram(vals,100);
figure;
histogram(vals,200);
[a,b]=titanium;
f=fit(a.',b.','gauss2');
plot(f,a,b)

%plotting signals
subplot(3,1,1);
plot(y);
title('original Signal');
subplot(3,1,2)
plot(xn);
title('Noisy Signal');
subplot(3,1,3)
plot(y);
title('Filtered Signal');