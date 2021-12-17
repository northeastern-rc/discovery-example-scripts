function [numWorkers,time] = myParallelAlgorithmFcn ()

complexities =  [2^18 2^20 2^21 2^22];
numWorkers = [16 32 64];
%numWorkers = [1 2 4 8 16 32 64];

time = zeros(numel(numWorkers),numel(complexities));

% To obtain obtain predictable sequences of composite numbers, fix the seed
% of the random number generator.
rng(0,'twister');

for c = 1:numel(complexities)
    
    primeNumbers = primes(complexities(c));
    compositeNumbers = primeNumbers.*primeNumbers(randperm(numel(primeNumbers)));
    factors = zeros(numel(primeNumbers),2);
    
    for w = 1:numel(numWorkers)
        tic;
        parfor (idx = 1:numel(compositeNumbers), numWorkers(w))
            factors(idx,:) = factor(compositeNumbers(idx));
        end
        time(w,c) = toc;
	pause(1);
    end
end
