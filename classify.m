function [probabilites, winnerClass] = classify(method, f, testsample, k)

if strcmp(method,'knn')
    [probabilites, winnerClass]=classifyKNN_D_Multi(f.features, testsample, k, 0, 1);
end

end