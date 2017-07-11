function DistanceM = BS_UE_Distance_Calculation(BS_Locs,UE_Locs, NumFrames,cell_side)

UE_LocsM = zeros(size(BS_Locs,2),size(UE_Locs,2),NumFrames);
BS_LocsM = zeros(size(BS_Locs,2),size(UE_Locs,2),NumFrames);


for frame = 1:NumFrames
    UE_LocsM(:,:,frame) = repmat(UE_Locs(frame,:),size(BS_Locs,2),1);
    BS_LocsM(:,:,frame) = repmat((BS_Locs(frame,:)).',1,size(UE_Locs,2));

end


HDistance = abs(real(BS_LocsM)-real(UE_LocsM));
HDistance = min(HDistance,cell_side-HDistance); % modulo operation due to wrap-around

VDistance = abs(imag(BS_LocsM)-imag(UE_LocsM));
VDistance = min(VDistance,cell_side-VDistance); % modulo operation due to wrap-around

%DistanceM = zeros(size(BS_Locs,2),size(UE_Locs,2),NumFrames);
DistanceM  = sqrt(HDistance.^2+VDistance.^2);
