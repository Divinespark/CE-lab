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




%D:
IYAmean = mean(enRegAB_orig_phIY(:,1));
IYBmean = mean(enRegAB_orig_phIY(:,2));
SAmean = mean(enRegAB_orig_phS(:,1));
SBmean = mean(enRegAB_orig_phS(:,2));

IYAdev = std(enRegAB_orig_phIY(:,1));
IYBdev = std(enRegAB_orig_phIY(:,2));
SAdev = std(enRegAB_orig_phS(:,1));
SBdev = std(enRegAB_orig_phS(:,2));

name = ['IYA';'IYB';'SA ';'SB '];
Mean = [IYAmean;IYBmean; SAmean; SBmean];
Dev = [IYAdev; IYBdev; SAdev; SBdev];

table(name, Mean, Dev)