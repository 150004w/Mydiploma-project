function [FilterCoeff]=FBGfiltersim(BasebandBandwidth,f_c,f_sampling)
UpperEdgeOfBandwidth= f_c+1.5*BasebandBandwidth;                               % Highest frequency in the received signal
LowerEdgeOfBandwidth= f_c-1.5*BasebandBandwidth;                               % Lowest Frequency in the  received RF signal
FilterCoeff = fir1(10000,[ LowerEdgeOfBandwidth/(0.5*f_sampling) UpperEdgeOfBandwidth/(0.5*f_sampling) ]);    % generating