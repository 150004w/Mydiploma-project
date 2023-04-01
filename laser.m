function LaserOutput = laser(TransmitPower,Fs,NumberoOfSamples )

% This function generates the laser output.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                   Input
%TransmitPower_dBm            -Transmit power of the laser
%NumberoOfSamples             -Number of samples simulated.

%                                    Output
%LaserOutput                  - The output signal of the laser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RIN=-150; %-inf;               % Intensity noise level in the laser
LineWidth=10*10^6;             % Linewidth of the laser                               
% TransmitPower=10^((TransmitPower_dBm)/10)*0.001;                                                                                                    % Transmit power in watts;                                                                                                                                     % The optical frequency used
NoiseBandwidth=Fs/2;                                                       % RIN noise bandwidth
% rng('default');
InstantaneousLaserPower=sqrt(2)*sqrt(TransmitPower*ones(1,NumberoOfSamples) + sqrt(TransmitPower^2*10^(RIN/10)*NoiseBandwidth)*randn(1,NumberoOfSamples)); % laser output power incorporating RIN noise
LaserOutput=InstantaneousLaserPower.*LinewidthGen(LineWidth,Fs,NumberoOfSamples);  
% Laser output with a linewd
% LaserOutputpower= sum(abs(LaserOutput).^2)/length(LaserOutput)