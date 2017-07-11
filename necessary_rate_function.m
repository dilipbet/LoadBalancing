 function [x] = necessary_rate_function(rates,UE_NumPoints,NumFrames,what)
    for frame = 1: NumFrames
        if(strcmp(what,'mean'))
        x(frame) = mean(rates(frame,1:UE_NumPoints(frame)));
        elseif(strcmp(what,'geomean'))
        x(frame) = geomean(rates(frame,1:UE_NumPoints(frame)));
        elseif(strcmp(what,'fivep')) 
        fivep = sort(rates(frame,1:UE_NumPoints(frame)));
        x(frame) = fivep(:,round(0.05*length(fivep)));
        end
    end
    
    x = sort(x);