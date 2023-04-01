clear all
close all
clc
%% Spatial Modulation Wireless Simulation-input the data from MAIN-RoF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for times=1:5
    Range_Eb_No=0:30;
% BER=zeros(1,length(Range_Eb_No));
testindexss=['SM_SSB_20km_2Gbps_bpsk_coded20m.mat']
load (['SM_SSB_20km_2Gbps_bpsk_coded20m.mat'])
bits=transpose(bitsnew(:));
Nt=2;
Nr=1;
framelength=length(Transmittedsymbol);
Transmittedsymbol_normalized=Transmittedsymbol;
%Wireless Channel
normalized_coefficient=sum(sum(abs(Transmittedsymbol).^2))/length(Transmittedsymbol);
Transmittedsymbol_normalized=Transmittedsymbol./sqrt(normalized_coefficient);
%where No is the average noise power
%Set the power of whole h

for Eb_No=Range_Eb_No;
BERinside=1;
errorcount=0;
wholebitnumber=0;
%Each part of the complex value follows N(0,1/2*sigma^2) while randn is just for N(0,1)  
NO = 1/(10^(Eb_No/10));
% Eb_No=20;
%% Wireless Part%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% col=1;
%prearranged h and n (for the sake of noise power comparison)
hhub = 1/sqrt(2)*[randn(Nr*Nt,framelength) + 1j*randn(Nr*Nt,framelength)]; % Rayleigh channel
n = sqrt(NO/2)*[randn(Nr,framelength) + 1j*randn(Nr,framelength)]; % Rayleigh channel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %MIMO Chanenl precoding with parallel decomposition
% [U,S,V] = svd(h);
% Symbolafterprocessing=V*Transmittedsymbol_normalized(:,2);
% %=Channel and noise Noise addition
% y = h*Symbolafterprocessing; 
% % Equalization
% yhat=U'*(y);
% abs(yhat)/S(1)% this precoding is just for parallel decomposition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Maximum Likelihood Detection MIMO Channel====================================
% [U,S,V] = svd(h);
% Symbolafterprocessing=V*Transmittedsymbol_normalized(:,1); %precoding
recoveredsymbol=zeros(1,size(Transmittedsymbol_normalized,2));
activatedantennaindex=zeros(1,size(Transmittedsymbol_normalized,2));
inirow=1;
inicol=1;
for symbolcol=1:size(Transmittedsymbol_normalized,2);
Symbolafterprocessing=Transmittedsymbol_normalized(:,symbolcol);
% Channel and noise Noise addition 
h=reshape(hhub(:,inicol),Nr,Nt);
y = h*Symbolafterprocessing+n(:,inicol);  % we do not add the SNR in the receiver antenna
inicol=inicol+1;
% There need some changes here . Normalization?
% Equalization
% yhat=U'*(y);
% abs(yhat)/S(1)% this precoding is just for parallel decomposition

%%%%%%%Sub-optimal detection MRC
% g=h'*y;
% absg=(abs(g));
% activatedantennaindex(symbolcol)=find(absg==max(abs(g)));
% recoveredsymbol(symbolcol)=(g(activatedantennaindex(symbolcol)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ML detection
% activatedantenna=find(z==max(z));
% Maximum Likelihood detection
% Descision=zeros(2,2*Nt);
Q=[1,-1];
% xjq=zeros(1,2);
for sj=1:Nt
    a=1;
for q=Q;
g_jq=h(:,sj)*q;
coeff1=(sum(abs(g_jq).^2));
coeff2=2*real(y'*g_jq);
% xjq(sj)=q;
% yPDF=pi*(-Nr)*exp(-(sum(abs(y-h*xjq').^2)));
Decision(sj,a)=(coeff1-coeff2);
a=a+1;
end
end
[activatedantenna,symbolindex]=find(Decision==min(Decision(:)));
recoveredsymbol(symbolcol)=Q(symbolindex);
activatedantennaindex(symbolcol)=activatedantenna;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %==================================================================
        activatedantennaindex(find(activatedantennaindex==2))=0;
        recoveredcontrolbits=activatedantennaindex;
        recoveredcontrolbits=reshape(recoveredcontrolbits,200,length(recoveredcontrolbits)/200);
        %==============================BPSK demo=======================================%
        % %==========bpsk demodulation and BER=======%
          b_hat_before=real(recoveredsymbol)>0;
          b_hat_=double(b_hat_before');
          b_hat_=reshape(b_hat_,200,length(b_hat_)/200);
          b_hat_=[b_hat_;recoveredcontrolbits];
          load Orbits
          b_hat = step(hDec,b_hat_(:));
%==================================================================
%=========================================================================%
%remove first bit
% controlerrors=sum(activatedantennaindex~=controlbits);
        
        errors=sum(b_hat(35:end,1)~=Orbits(1:2000000-34,:));
        bitnumber=length(b_hat);
        errorcount1(Eb_No+1)=errorcount+errors;
        wholebitnumber1(Eb_No+1)=bitnumber+wholebitnumber;
        BER(Eb_No+1)=errors/bitnumber
end
semilogy(Range_Eb_No,BER);
grid on
saveas(gcf,['BER_21_nobeamforming_coded_modi' num2str(times) '.fig'])
clear all
close all
clc
end