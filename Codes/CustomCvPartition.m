%% Custom cv partition to ensure that a group of images always lie in the same group
% In MIAS dataset consecutive images belong to the same patient
% Hence consecutive images should always belong to the same group of a
% partition

classdef CustomCvPartition
    properties
        NumTestSets
        numSamples
        numGroups
        partition
    end
    
    methods
        function obj = CustomCvPartition(kFolds, numSamples, numGroups)
            obj.NumTestSets = kFolds;
            obj.numSamples = numSamples;
            obj.numGroups = numGroups;
            
            rng(0);
            obj.partition = cvpartition(numSamples/numGroups,'Kfold',kFolds);
        end
        
        function training = training(this,i)
            training = false(this.numSamples,1);
            trainIdx = find(this.partition.training(i)); 
            training(2*trainIdx) =1;
            training(2*trainIdx-1)=1;
        end
        
        function trainSize = TrainSize(this,i)
            trainSize = length(find(this.partition.training(i)));
        end
        
        function test = test(this,i)
            test = false(this.numSamples, 1);
            testIdx = find(this.partition.test(i));
            test(2*testIdx)=1;
            test(2*testIdx-1) =1;
        end
        
        function testSize = TestSize(this,i)
            testSize = length(find(this.partition.test(i)));
        end
    end
end
            