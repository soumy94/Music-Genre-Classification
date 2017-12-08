function [matrixDR] = DimensionReduction(matrix, method, num_dim)
if (strcmp(method, 'pca'))
    matrixDR = pca(matrix, num_dim);
end
end