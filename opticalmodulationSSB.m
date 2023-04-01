function [E_output]=opticalmodulation(LaserOutput,RFsignal,RFsignal2,MZMType,t,carrierfreq)
%optical carrier frequency is set to be zero. I have no idea why.
if strcmp(MZMType,'dual drive QP')
    Vbias1=2;
    Vbias2=-2;
    Vpi=8;
    RFsignal1=RFsignal;
    RFsignal2=RFsignal2;
    E_output1=LaserOutput./2.*(exp(j*pi*Vbias1/Vpi+j*pi*RFsignal1/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output2=LaserOutput./2.*(exp(j*pi*Vbias2/Vpi+j*pi*RFsignal2/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output=(E_output1+E_output2);
elseif strcmp(MZMType,'dual drive MATP')
    Vbias1=1.5;
    Vbias2=1.5;
    Vpi=6;
    RFsignal1=RFsignal/2;
    RFsignal2=-RFsignal/2;
    E_output1=LaserOutput./2.*(exp(j*pi*Vbias1/Vpi+j*pi*RFsignal1/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output2=LaserOutput./2.*(exp(j*pi*Vbias2/Vpi+j*pi*RFsignal2/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output=(E_output1+E_output2);
elseif  strcmp(MZMType,'dual drive MITP')
    Vbias1=3;
    Vbias2=-3;
    Vpi=6;
    RFsignal1=RFsignal/2;
    RFsignal2=-RFsignal/2;
    E_output1=LaserOutput./2.*(exp(j*pi*Vbias1/Vpi+j*pi*RFsignal1/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output2=LaserOutput./2.*(exp(j*pi*Vbias2/Vpi+j*pi*RFsignal2/Vpi)).*exp(1j*2*pi*t*carrierfreq);
    E_output=(E_output1+E_output2);
end