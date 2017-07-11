function u = utility(r,alpha)

if(alpha==1)
    u = log(r);
else
    u = r.^(1-alpha)/(1-alpha);
end

u = sum(u);