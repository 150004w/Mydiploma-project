function Interleaversignal_port=Op_interleaver(n,output,BasebandBandwidth,carrierfreq,f_c2,f_c,f_sampling)
%=============================Filtered Transmission Signal (Signal 1)=============%
[FilterCoeffrecupper1_1]=FBGfiltersim(BasebandBandwidth/4,carrierfreq,f_sampling);
outputsplitedupper_signal1_1= filter2(FilterCoeffrecupper1_1,output); 
%================
% if for 3Ghz system, using this, better add the dispersion compensation
% scheme in the SMF Channel
% n=0;
% [FilterCoeffrecupper]=FBGfiltersim(f_c/2+BasebandBandwidth,carrierfreq+n*f_c2-f_c/2,f_sampling);
% outputsplitedupper= filter2(FilterCoeffrecupper,output); 
%==================
n=n+1;
[FilterCoeffreclower1_2]=FBGfiltersim(BasebandBandwidth,carrierfreq+f_c,f_sampling);
outputsplitedupper_signal1_2= filter2(FilterCoeffreclower1_2,output); %filter each frequency for the sake of simulation 
Interleaversignal_port=outputsplitedupper_signal1_1+outputsplitedupper_signal1_2;