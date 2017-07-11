function[Locs, NumPoints] =  PointPoissonProcess2D(cell_area,density, frame_variant, cell_side, NumFrames)


%[pdf,cdf] = poisson_pdf(density*cell_area);


%NumPoints= density*cell_area*ones(NumFrames,1); %

if(density*cell_area<=745)
NumPoints= poisson_sample(density*cell_area,NumFrames);
else
    %in this case we need to use an offline mat file for the distribution.
    %We have these for 800, 900, 1000, 1200, 1500, 2000
    if((density*cell_area~=800)&&(density*cell_area~=900)&&(density*cell_area~=1000)&&(density*cell_area~=1200)&&(density*cell_area~=1500)&&(density*cell_area~=2000))
        Need_new_data_OR_use_avail_cases_800_900_1000_1200_1500_2000; %need to run Dilip_please_run_this.m
    else
        NumPoints= poisson_sample(density*cell_area,NumFrames);
    end
end

if(frame_variant == 1)
    %each row is for a new frame
    %create MaxNumPoints many points in the square region
    Locs = (rand(NumFrames,max(NumPoints))+rand(NumFrames,max(NumPoints))*sqrt(-1))*cell_side;
elseif(frame_variant ==0)
    % create according to the first row and keep their locations and
    % numbers fixed
    Locs = (rand(1,max(NumPoints(1)))+rand(1,max(NumPoints(1)))*sqrt(-1))*cell_side;
    Locs = repmat(Locs,NumFrames,1);
    NumPoints = repmat(NumPoints(1),NumFrames);

end



% %[pdf,cdf] = poisson_pdf(density*cell_area);
% 
% 
% %NumPoints= density*cell_area*ones(NumFrames,1); %
% NumPoints= poisson_sample(density*cell_area,NumFrames);
% 
% if(frame_variant == 1)
%     %each row is for a new frame
%     %create MaxNumPoints many points in the square region
%     Locs = (rand(NumFrames,max(NumPoints))+rand(NumFrames,max(NumPoints))*sqrt(-1))*cell_side;
% elseif(frame_variant ==0)
%     % create according to the first row and keep their locations and
%     % numbers fixed
%     Locs = (rand(1,max(NumPoints(1)))+rand(1,max(NumPoints(1)))*sqrt(-1))*cell_side;
%     Locs = repmat(Locs,NumFrames,1);
%     NumPoints = repmat(NumPoints(1),NumFrames);
% 
% end


