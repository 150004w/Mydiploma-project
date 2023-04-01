function yreceived=Basebandmodulation(BasebandBandwidth,f_sampling,Photodetectedsignal,...
    RFTransmittedPower,output,symbols,B_rrcos,samples_per_symbol)
% load wavedataSM
%=============Receiver RF-baseband conversion=============%
%====electronic BPF==============================%
[FilterCoeffdem]=FBGfiltersim(BasebandBandwidth,3e9,f_sampling);
%3GHz system change thisto 3GHz
Filteredphotodetetced= filter2(FilterCoeffdem,Photodetectedsignal); 

%Amplification
ReceivedRFSignalPower = sum(abs(Filteredphotodetetced).^2)/length(Filteredphotodetetced);
AmplificationNeeded= -1*sqrt(RFTransmittedPower/ReceivedRFSignalPower);

% zerosymbol1=find(sn1==0);
% zerosymbol2=find(sn2==0);
% x1=x;
% x2=x;
% for stuff=zerosymbol2;
% Filteredphotodetetced(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=AmplificationNeeded*Filteredphotodetetced(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)));
% end
Amplifiedsignal=AmplificationNeeded*Filteredphotodetetced;
% 
% figure(11)
% pwelch(Amplifiedsignal,[],[],[],f_sampling,'power')
%====RFsignaltobaseband conversion====%
basebandsignal=2*Amplifiedsignal.*exp(-1j*(2*pi*3*10^9*(0:size(output,2)-1)/f_sampling+pi/4));
%LPF
LPFco=fir1(10000,2*BasebandBandwidth/(0.5*f_sampling));
reconstructedbasebandsignal=filter2(LPFco,basebandsignal);
%3GHz system change this to 3GHz
%====Root raised cosine filter========%
xthat=filter2(B_rrcos,reconstructedbasebandsignal);
% figure(14)
% plot(tsamples,xthat)
% figure(15)
% plot(tsamples,RFsignal)
%====Sampling=========================%
yreceived= xthat(upsample(ones(1,symbols),samples_per_symbol,samples_per_symbol/2)==1);