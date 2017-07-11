function [cell_area,MC_location] = MC_related(cell_type,cell_side, MC_square_number)
if(strcmp(cell_type,'square'))
    % cell covers the area between [0,cell_side] x [0, cell_side]
% horizontal is the real part, vertical is the imaginary
    cell_area = cell_side^2;
    MC_location = cell_side/2+sqrt(-1)*cell_side/2;
elseif(strcmp(cell_type,'square9'))
            % cell covers the area between [0,cell_side] x [0, cell_side]
% horizontal is the real part, vertical is the imaginary
% cell area is deivided into 9 small squares. The middle cell and other
% cells have different user density. MC can be in the center of any of the
% 9 small squares
% 0+2i  1+2i  2+2i
% 0+i   1+i   2+i
% 0     1     2

    cell_area = cell_side^2;
    
    %imag(MC_square_number)
    %real(MC_square_number)
    
    MC_location = cell_side/3/2+sqrt(-1)*cell_side/3/2;
    MC_location = MC_location + cell_side/3*(sqrt(-1)*imag(MC_square_number)+real(MC_square_number));
        
else 
    cell_type_problem
end