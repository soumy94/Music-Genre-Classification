load('Users/soumy/Documents/highdimensional/pcaResult/pcaResults.mat');
variables = who;
distance = [];
for i=1:length(variables)
   if strncmpi(variables{i}, 'mfcc_', 5)==1
       matrix1 = eval(char(variables{i}));
       values = [];
       for j=1: length(variables)
            if strncmpi(variables{j}, 'mfcc_', 5)==1
                matrix2 = eval(char(variables{j}));
                euclideanDistance = sqrt(sum((matrix1 - matrix2) .^ 2));
                frobeniusNorm = norm(euclideanDistance, 'fro');
                values = [values frobeniusNorm];
            end
       end
       distance(i,:) = values;
   end
end
imagesc(distance);
colorbar;