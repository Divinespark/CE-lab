clear;
close all;

clc

fname1='scan1.obj';
fname2='scan2.obj';

obj1=readObj1(fname1);

obj2=readObj1(fname2);
figure(1)
patch('vertices',obj1.v,'faces',obj1.f.v)
title('from the first data')

figure(2)
patch('vertices',obj2.v,'faces',obj2.f.v)
title('from the second data')


function obj = readObj1(fname)
%
% obj = readObj(fname)
%
% This function parses wavefront object data
% It reads the mesh vertices, texture coordinates, normal coordinates
% and face definitions(grouped by number of vertices) in a .obj file
%
%
% INPUT: fname - wavefront object file full path
%
% OUTPUT: obj.v - mesh vertices
%       : obj.vt - texture coordinates
%       : obj.vn - normal coordinates
%       : obj.f - face definition assuming faces are made of of 3 vertices
%,
% Bernard Abayowa, Tec^Edge
% 11/8/07

% set up field types
v = []; vt = []; vn = []; f.v = []; f.vt = []; f.vn = [];

fid = fopen(fname);

% parse .obj file
while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end  % exit at end of file
     ln = sscanf(tline,'%s',1); % line type
     %disp(ln)
    switch ln
        case 'v'   % mesh vertexs
            v = [v; sscanf(tline(2:end),'%f')'];
        case 'vt'  % texture coordinate
            vt = [vt; sscanf(tline(3:end),'%f')'];
        case 'vn'  % normal coordinate
            vn = [vn; sscanf(tline(3:end),'%f')'];
        case 'f'   % face definition
            fv = []; fvt = []; fvn = [];
            str = textscan(tline(2:end),'%s'); str = str{1};

           nf = length(findstr(str{1},'/')); % number of fields with this face vertices


           [tok str] = strtok(str,'//');     % vertex only
            for k = 1:length(tok) fv = [fv str2num(tok{k})]; end

            if (nf > 0)
            [tok str] = strtok(str,'//');   % add texture coordinates
                for k = 1:length(tok) fvt = [fvt str2num(tok{k})]; end
            end
            if (nf > 1)
            [tok str] = strtok(str,'//');   % add normal coordinates
                for k = 1:length(tok) fvn = [fvn str2num(tok{k})]; end
            end
             f.v = [f.v; fv]; f.vt = [f.vt; fvt]; f.vn = [f.vn; fvn];
    end
end
fclose(fid);

% set up matlab object
obj.v = v; obj.vt = vt; obj.vn = vn; obj.f = f;

end
%Published with MATLAB® R2018a
