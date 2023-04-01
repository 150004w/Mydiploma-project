function [yreceived1]=leftsidebandmain(L,Laserpower,signalType,iter)
f_c=3e9;
f_c2=25e9;
f_sampling=10e11;
T=1e-7;
samples=f_sampling*T;
wholebits=0;
wholeerror=0;
noise='yes';
%%%%%%%%%%%%%%%%%%Laser%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Laserpower=1e-3; %watt
LaserOutput=laser(Laserpower,f_sampling,samples);
% while wholeerror<100 && wholebits<1e8;
    
%%%%%%%%%%%%%%%%%%RF generation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tsamples=(0:samples-1)/f_sampling;
load wavedataSM.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%==========================optical direct modulation=============================%
%==================Alternative External Modulator_SM scheme_==============%
MZMType='dual drive QP';
carrierfreq=200e9; % simulation set to be zero

symbolindexstart=1;
symbolindexend=samples_per_symbol;
%==========================================================================
phasecontrol=1;
[E_outputmod2]=opticalmodulationSSB(LaserOutput,RFsignal12,phasecontrol*RFsignal22,MZMType,tsamples,carrierfreq);
% figure(3)
% pwelch(E_outputmod2,[],[],[],f_sampling,'power')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=====================MZM modulator(phase shift scheme)===================%
%====================multiwavelength system===============================%
%step two for multi-wavelength generation
% VLO=10*cos(2*pi*f_c2*tsamples);
% MZMType1='dual drive QP'; Vbias=1;
% [E_output1]=opticalmodulatione(E_outputmod2,VLO,MZMType1,Vbias,tsamples,0);
% [E_output]=opticalmodulatione(E_outputmod2,VLO,MZMType1,Vbias,tsamples,0);
% figure(3)
% pwelch(E_output1,[],[],[],f_sampling,'power')

%%%%%%%%%%%%%Channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===SMF
lambda=1550;
[output]=SMFchannel(E_outputmod2,lambda,f_sampling,L);
% output=10*output;
% figure(4)
% pwelch(output,[],[],[],f_sampling,'power')
% figure(5)
% pwelch(abs(output).^2,[],[],[],f_sampling,'power')
%%%%%%%%%%%%Optical_Filtering (need correction)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Interleaversignal_port2_1=Op_interleaver_right(-3,output,BasebandBandwidth,carrierfreq,...
f_c2,f_c,f_sampling);
% %signal 2
% Interleaversignal_port2_2=Op_interleaver_right(-1,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% %signal 3
% Interleaversignal_port2_3=Op_interleaver_right(1,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% %signal 4
% Interleaversignal_port2_4=Op_interleaver_right(3,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% figure(5)
% pwelch(Interleaversignal_port2_2,[],[],[],f_sampling,'power')

%%%%%%%%%%%%Demodulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demodulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%photodetection
Photodetectedsignal1=photodiode_right(samples_per_symbol,sn2,noise,Interleaversignal_port2_1,f_sampling);
% Photodetectedsignal2=photodiode_right(samples_per_symbol,sn2,noise,Interleaversignal_port2_2,f_sampling);
% Photodetectedsignal3=photodiode_right(samples_per_symbol,sn2,noise,Interleaversignal_port2_3,f_sampling);
% Photodetectedsignal4=photodiode_right(samples_per_symbol,sn2,noise,Interleaversignal_port2_4,f_sampling);

%=============Receiver RF-baseband conversion=============%


%% Baseband Modulation%%%%%%%%
yreceived1=Basebandmodulation_right(BasebandBandwidth,f_sampling,Photodetectedsignal1,...
    RFTransmittedPower2,output,symbols,B_rrcos,samples_per_symbol);
% yreceived2=Basebandmodulation_right(BasebandBandwidth,f_sampling,Photodetectedsignal2,...
%     RFTransmittedPower2,output,symbols,B_rrcos,samples_per_symbol);
% yreceived3=Basebandmodulation_right(BasebandBandwidth,f_sampling,Photodetectedsignal3,...
%     RFTransmittedPower2,output,symbols,B_rrcos,samples_per_symbol);
% yreceived4=Basebandmodulation_right(BasebandBandwidth,f_sampling,Photodetectedsignal4,...
%     RFTransmittedPower2,output,symbols,B_rrcos,samples_per_symbol);
% % %==============================BPSK demo=======================================%
% %==========bpsk demodulation and BER=======%
% b_hat=real(yreceived)>0;
% %=========================================================================%
% errors=sum(b_hat~=bits);
% bitnumber=length(bits);
% wholebits=wholebits+bitnumber;
% wholeerror=wholeerror+errors;
% bits
% BER=wholeerror/wholebits
% end