
% Next the XY Labels and Title font sizes
XLabel_handle = get(gca,'XLabel');
YLabel_handle = get(gca,'YLabel');
Title_handle = get(gca,'Title');

set(XLabel_handle, 'FontSize',FXYL)
set(YLabel_handle, 'FontSize',FXYL)
set(Title_handle, 'FontSize',FTIT)
set(gca, 'FontSize',FAXS)

% Finally the Legend fontsize

Legend_handle = legend;
set(Legend_handle, 'FontSize',FLEG)