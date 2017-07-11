function [samples] = poisson_sample(a,array_size)

samples = zeros(size(array_size));
for i = 1:array_size
    
    
    sample = 0;
    f = exp(-a);
    if(f == 0)
        i = array_size+1;
        if(array_size>1000)
            ask_dilip_for_new_files;
        end
        load(sprintf('PoissonSamples_NumFrames%d_lambda%d.mat',100,a));
        samples = x(1:array_size)';
    else
        p = exp(-a);
        u = rand(1,1);
        while(f<=u)
            
            p = p*a/(sample+1);
            f = f+p;
            sample = sample+1;
            
        end
        samples(i) = sample;
    end
end

