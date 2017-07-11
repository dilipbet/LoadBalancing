function [pdf,cdf] = poisson_pdf(lambda)

max_number_of_points = min(2*lambda, lambda+100);

x = (0:max_number_of_points);

pdf = exp(-lambda)*((lambda.^x)./factorial(x));


if((sum(pdf)-1)>10^(-4))
    poisson_pdf_error
end

pdf = pdf./sum(pdf);

cdf = cumsum(pdf);