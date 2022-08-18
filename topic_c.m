clear;
file = 'listData.txt';
fidin = fopen(file);
segAllData = {};
segOrig_phIY = [];
segFilt_phIY = [];
segOrig_phS = [];
segFilt_phS = [];
ind = 0;
upFloder = fscanf(fidin,'%5s',1);
while (strcmp(upFloder,'.')~=1)
    Slash = fscanf(fidin,'%1s',1);
    
    downFloder = fscanf(fidin,'%s',1);
    
    ind = ind + 1;

    
    Floder{ind,1} = upFloder;
    File{ind,1} = downFloder;

    upFloder = fscanf(fidin,'%5s',1);
end
fclose(fidin);
for i = 1:length(Floder)
    f1 = ['./wavOrig/', Floder{i}, '/', File{i}, '.wav'];
    f2 = ['./wavFilt/', Floder{i}, '/', File{i}, '.wav'];
    f3 = ['./labels/', Floder{i}, '/', File{i}, '.lab'];
    fidd = fopen(f3);
    [yOrig, fsOrig] = audioread(f1);

   [yFilt, fsFilt] = audioread(f2);


   while ~feof(fidd)
       ttline = fgetl(fidd);
       str1 = strsplit(ttline);
       if strcmp(str1{3}, 'iy')

           timePhStart_iy = str2double(str1(1))/10000;
           timePhEnd_iy = str2double(str1(2))/10000;
           timeSegStart_iy = (timePhStart_iy + (timePhEnd_iy - timePhStart_iy)/2 - 10)/1000;
           timeSegEnd_iy = (timePhStart_iy + (timePhEnd_iy - timePhStart_iy)/2 + 10)/1000;
           %Orig
           tOrigStart_iy = floor(timeSegStart_iy*fsOrig);
           tOrigEnd_iy = floor(timeSegEnd_iy*fsOrig);
           %Filt
          tFiltStart_iy = floor(timeSegStart_iy*fsFilt);
          tFiltEnd_iy = floor(timeSegEnd_iy*fsFilt);
        
          segOrig_phIY(i,:) = yOrig(tOrigStart_iy:tOrigEnd_iy,1);

          segFilt_phIY(i,:) = yFilt(tFiltStart_iy:tFiltEnd_iy,1);
       end
       if strcmp(str1{3},'s')
           timePhStart_s = str2double(str1(1))/10000;
           timePhEnd_s = str2double(str1(2))/10000;
           timeSegStart_s = (timePhStart_s + (timePhEnd_s - timePhStart_s)/2 - 10)/1000;
           timeSegEnd_s = (timePhStart_s + (timePhEnd_s - timePhStart_s)/2 + 10)/1000;
           %orig
           tOrigStart_s = round(timeSegStart_s*fsOrig);
           tOrigEnd_s = round(timeSegEnd_s*fsOrig);
           
           %Filt
           tFiltStart_s = round(timeSegStart_s*fsFilt);
           tFiltEnd_s = round(timeSegEnd_s*fsFilt);
           
          segOrig_phS(i,:) = yOrig(tOrigStart_s:tOrigEnd_s,1);

          segFilt_phS(i,:) = yFilt(tFiltStart_s:tFiltEnd_s,1);
       end
   end
  
   segAllData = {segOrig_phIY,segOrig_phS; segFilt_phIY,segFilt_phS};
end







%C:
[numiy , dataiy] = size(segOrig_phIY);
[nums , datas] = size(segOrig_phS);
aveEn_a = 0;
aveEn_b = 0;
for i = 1:numiy
    magfftiy = abs(fft(segOrig_phIY(i,:)));
    %region A
  
    for k = 13:51
        aveEn_a = 1/(1600 - 400 + 1)*(abs(magfftiy(k)))^2 + aveEn_a;
    end
    aveEn_a_dB = 10*log10(aveEn_a);
    %region B
    
    for k = 77:128
        aveEn_b = 1/(4000 - 2400 + 1)*(abs(magfftiy(k)))^2 + aveEn_b;
    end
    aveEn_b_dB = 10*log10(aveEn_b);

    enRegAB_orig_phIY(i,:) = [aveEn_a_dB , aveEn_b_dB];
end

for bl = 1:nums
    phs = segOrig_phS(bl,:);
    magffts = abs(fft(phs));
    %region A
  
    for k = 13:51
        aveEn_a = 1/(1600 - 400 + 1)*(abs(magffts(k)))^2 + aveEn_a;
    end
    aveEn_a_dB = 10*log10(aveEn_a);
    %region B
    
    for k = 77:128
        aveEn_b = 1/(4000 - 2400 + 1)*(abs(magffts(k)))^2 + aveEn_b;
    end
    aveEn_b_dB = 10*log10(aveEn_b);

    enRegAB_orig_phS(bl,:) = [aveEn_a_dB , aveEn_b_dB];
end

figure
subplot(2,2,1)
histogram(enRegAB_orig_phIY(:,1));
title('Orig-IY-A');
subplot(2,2,2)
histogram(enRegAB_orig_phIY(:,2));
title('Orig-IY-B');
subplot(2,2,3)
histogram(enRegAB_orig_phS(:,1));
title('Orig-S-A');
subplot(2,2,4)
histogram(enRegAB_orig_phS(:,2));
title('Orig-S-B');