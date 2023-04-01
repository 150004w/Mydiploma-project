%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [yreceived1,yreceived2,yreceived3,yreceived4]=leftsidebandmain(L,Laserpower,signalType,iter)
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
[RFsignal11,RFsignal21,RFsignal12,RFsignal22]=wavegeneratorSM(signalType,f_sampling,f_c,T,iter);
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
phasecontrol=-1;
[E_outputmod1]=opticalmodulationSSB(LaserOutput,RFsignal11,phasecontrol*RFsignal21,MZMType,tsamples,carrierfreq);
% figure(3)
% pwelch(E_outputmod1,[],[],[],f_sampling,'power')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=====================MZM modulator(phase shift scheme)===================%
%====================multiwavelength system===============================%
%step two for multi-wavelength generation
% VLO=cos(2*pi*f_c2*tsamples);
% MZMType1='dual drive QP'; Vbias=1;
% [E_output1]=opticalmodulatione(E_outputmod1,VLO,MZMType1,Vbias,tsamples,0);
% [E_output]=opticalmodulatione(E_outputmod2,VLO,MZMType1,Vbias,tsamples,0);
% figure(3)
% pwelch(E_output1,[],[],[],f_sampling,'power')

%%%%%%%%%%%%%Channel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%===SMF
lambda=1550;
[output]=SMFchannel(E_outputmod1,lambda,f_sampling,L);
% output=10*output;
%===Amplifier
% output=10*output;
% figure(5)
% pwelch(output,[],[],[],f_sampling,'power')

%%%%%%%%%%%%Optical_Filtering (need correction)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Interleaversignal_port2_1=Op_interleaver_left(-2,output,BasebandBandwidth,carrierfreq,...
f_c2,f_c,f_sampling);
% %signal 2
% Interleaversignal_port2_2=Op_interleaver_left(0,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% %signal 3
% Interleaversignal_port2_3=Op_interleaver_left(2,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% %signal 4
% Interleaversignal_port2_4=Op_interleaver_left(4,output,BasebandBandwidth,carrierfreq,...
% f_c2,f_c,f_sampling);
% 
% figure(5)
% pwelch(Interleaversignal_port2_1,[],[],[],f_sampling,'power')

%%%%%%%%%%%%Demodulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Demodulation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%photodetection
Photodetectedsignal1=photodiode_left(samples_per_symbol,sn1,noise,Interleaversignal_port2_1,f_sampling);
% Photodetectedsignal2=photodiode_left(samples_per_symbol,sn1,noise,Interleaversignal_port2_2,f_sampling);
% Photodetectedsignal3=photodiode_left(samples_per_symbol,sn1,noise,Interleaversignal_port2_3,f_sampling);
% Photodetectedsignal4=photodiode_left(samples_per_symbol,sn1,noise,Interleaversignal_port2_4,f_sampling);

%=============Receiver RF-baseband conversion=============%


%% Baseband Demodulation%%%%%%%%
yreceived1=Basebandmodulation_left(BasebandBandwidth,f_sampling,Photodetectedsignal1,...
    RFTransmittedPower1,output,symbols,B_rrcos,samples_per_symbol);
% yreceived2=Basebandmodulation_left(BasebandBandwidth,f_sampling,Photodetectedsignal2,...
%     RFTransmittedPower1,output,symbols,B_rrcos,samples_per_symbol);
% yreceived3=Basebandmodulation_left(BasebandBandwidth,f_sampling,Photodetectedsignal3,...
%     RFTransmittedPower1,output,symbols,B_rrcos,samples_per_symbol);
% yreceived4=Basebandmodulation_left(BasebandBandwidth,f_sampling,Photodetectedsignal4,...
%     RFTransmittedPower1,output,symbols,B_rrcos,samples_per_symbol);
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
