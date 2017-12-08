variables = who;
save('./pcaResult/pcaResults_100.mat');
for i=1:length(variables)
    disp(i)
    if strncmpi(variables(i), 'mfcc_', 5)==1
       disp (variables(i));
       matrix = eval(char(variables(i)));
       pcaData = DimensionReduction(matrix, 'pca', 79);
       varname = char(variables(i));
       assignin('base', varname, pcaData);
       save('./pcaResult/pcaResults_100.mat', varname,'-append');        
    end
end