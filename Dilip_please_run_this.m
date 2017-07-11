
NumFrames = 100;
lambda = 700;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 800;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 900;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 1000;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 1200;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 1500;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');

NumFrames = 100;
lambda = 2000;
x = poissrnd(lambda,NumFrame,1);
filename = sprintf('PoissonSamples_NumFrames%d_lambda%d',NumFrames,lambda);
save(filename,'x');
