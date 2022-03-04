function resTestImg(dirName)
%Generate images of heat flow and temperature in restest runs.

if nargin < 1, dirName = 'resTestImg';end

if ~isdir(dirName)
    mkdir(dirName);
end

rNames = {'res1'; 'res2'; 'res3'};

bNames = {'b300'; 'b600'};

datNames = {'p11q0'; 'p11q1'; 'p11q10'; 'p11q50'; ...
    'p12q0'; 'p12q1'; 'p12q10'; 'p12q50'};

sy = [5e3; 4e3; 5e3];
sz = [3500; 3525; 3525];
b = [300; 600];

for i = 1:length(rNames)
    for j = 1:length(bNames)
        if i == 3 && j == 2
            datNames = {'p11q0'; 'p12q0'; 'p12q1'; 'p12q10'; 'p12q50'};
        end
        for k = 1:length(datNames)
            
            dirStr = [rNames{i}, '/', bNames{j}, '/' datNames{k}];
            outStr = [dirName,'/', strrep(dirStr, '/', '_')];
            
            %heatout(1,dirStr,1);
            plotTz(sz(i),[0,1e4],[0,1e4],[55,85], 'nearest', dirStr, 1);
            colormap('Hot');
            colorbar('off');
            axis square;
            print([outStr, '_Tz'], '-dpng');
            
            plotT(sy(i),[0,1e4],[450,450+b(j)],[55,85], 'nearest', dirStr, 1);
            colormap('Hot');
            colorbar('off');
            print([outStr, '_Tx'], '-dpng');
            
        end
    end
end
end

