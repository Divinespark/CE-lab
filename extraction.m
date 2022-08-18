disp('You selected Extract signal segments')
fileID = fopen('listData.txt');
list = textscan(fileID,'%s','delimiter','\n');
fclose(fileID);
for i = 1:50
    %read
    inputPath=strcat('wavOrig\',list{1}{i},'.wav');
    [d,sr] = audioread(inputPath);
    labelPath=strcat('labels\',list{1}{i},'.lab');
    fileID = fopen(labelPath);
    labelsList = textscan(fileID,'%s');
    cellList = list{1};
    [r,c]=size(cellList);
    matrixList = ["r","t","k";"s","a","z"];
    segOrig_phIY = zeros(2,3)
    segFilt_phIY = zeros(2,3)
    segOrig_phS = zeros(2,3)
    segFilt_phS = zeros(2,3)
    index=1;
    %populate matrix list
    for ii = 1:r/3
        for j = 1:3
            matrixList(ii,j)=cellList{index};
            index= index+1;
        end
    end
    fclose(fileID);

    if list{1}{i}=="MDPK0\SA1"
        plot(),title('phonemIY_original'),subplot(2,1,1),plot(),title('phonemIY_filterd'),subplot(2,1,2);
        print('-dpng','-r100','MDPK0_SA1_phonem_iy');
        plot(),title('phonemS_original'),subplot(2,1,1),plot(),title('phonemS_filterd'),subplot(2,1,2);
        print('-dpng','-r100','MDPK0_SA1_phonem_s');
    end
end
%str2double(matrixList(3,2))+str2double(matrixList(4,2)) 
%save('segAllData.mat', '<array>');