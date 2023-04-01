function Photodetectedsignal=photodiode(samples_per_symbol,sn1,noise,Interleaversignal_port2,f_sampling)
Photodetectedsignal=abs(Interleaversignal_port2).^2; %PD Signal is the Square 
%====
%3GHZ system using this 
% Photodetectedsignal=abs(outputsplitedupper).^2; %PD Signal is the Square 
%====
%=========Noise added Thermal noise and shot noise
%shot noise
e=1.60217e-19;
Idc=mean(Photodetectedsignal);
noisebandwidth=f_sampling/2; %still confused about this
shotnoisepower=2*e*Idc*noisebandwidth;
%Thermalnoise
AmplifierNoiseFigure_dB = 6;                                                                                        % Amplifier Noise Figure in dB. Digitized Radio over Fiber Technologies for converged optical wireless access networks
AmplifierNoiseFigure= 10^(AmplifierNoiseFigure_dB/10);                                                              % Amplifier Noise Figure;
Tambient=290;  kboltzmann = 1.3806e-23;Rload = 150;                                                                                                     % Ambient temperature in Kelvin
ThermalNoisePower = 4*((kboltzmann*(AmplifierNoiseFigure*Tambient))/Rload)* noisebandwidth ;                        % (4*kT/RL) where k is the boltmann's constant, T is system temperature including noise temperature and RL is the load resistance,
Totalnoisereceiverpower=shotnoisepower+ThermalNoisePower;
Totalnoise=sqrt(Totalnoisereceiverpower)*randn(1,length(Photodetectedsignal)); %confused about this as well

zerosymbol1=find(sn1==0);
% for stuff=zerosymbol1;
% Totalnoise(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
% end
% figure(4)
% pwelch(Interleaversignal_port2,[],[],[],f_sampling,'power')
% figure(5)
% pwelch(Photodetectedsignal,[],[],[],f_sampling,'power')
% here the unactivated one has no effect of noise
if strcmp(noise,'yes')
Photodetectedsignal=Photodetectedsignal+Totalnoise;
else Photodetectedsignal=Photodetectedsignal;
end