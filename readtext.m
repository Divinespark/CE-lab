clear;
%read file
fid = fopen('listData.txt','rt');
ind = 0;
%read floder
upFloder = fscanf(fid,'%5s',1);
while (strcmp(upFloder,'.')~=1)
    %read \
    Slash = fscanf(fid,'%1s',1);
    %read file name
    downFloder = fscanf(fid,'%s',1);
    
    ind = ind + 1;
    fileStruct(ind).floder = upFloder;
    fileStruct(ind).file = downFloder;
    %storage
    Floder{ind,1} = upFloder;
    File{ind,1} = downFloder;

    upFloder = fscanf(fid,'%5s',1);
end
fclose(fid);
 
%read audio
for i = 1:length(Floder)
    %Formation of relative paths
    f = strcat('./wavOrig/',Floder{i},'/',File{i},'.wav');
    [wav,fs] = audioread(f);
    %Waveform length
    wavl = length(wav);
    
    wavnew = [zeros([6 1]); wav];
    %New wave length
    wavnewl = length(wavnew);
    %Input step response coefficient
    h = [-0.7, -0.9, -0.9, 0.7, 0.5, 0.3, 0.3];
    
    outwav = zeros([wavl 1]);
    %FIR
    for j = 7:wavnewl
        outwav(j-6) = h(1)*wavnew(j) + h(2)*wavnew(j-1) + h(3)*wavnew(j-2) + ...
            h(4)*wavnew(j-3) + h(5)*wavnew(j-4) + h(6)*wavnew(j-5) + ...
            h(7)*wavnew(j-6);
    end
    
    outwav = outwav/max(abs(outwav));
    %write
    fnew = strcat('./wavFilt/',Floder{i},'/',File{i},'.wav');
    audiowrite(fnew, outwav, fs);
end
%extend coefficient
impResExp = [h, zeros(1, 249)];
%DFT
magFreqChar = abs(fft(impResExp));
magFreqChar_dB = 20*log10(magFreqChar);
%Drawing
subplot(1,2,1);
plot(magFreqChar_dB);
grid on;
xlabel('Frequency index');
ylabel('Magnitude(dB)');
subplot(1,2,2);
plot([0:127]*8000/256,magFreqChar_dB(1:128));
grid on;
xlabel('Frequency(Hz)');
ylabel('Magnitude(dB)');
    