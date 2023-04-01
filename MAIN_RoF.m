tic ;
%% %%%Main Function for the SSB aided SM of RoF%%%%
%%%%%%%%%%%%%%%%%%%%%Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% L   ---   Fiber Length
% Transmittedsymbol --- fiber output (four outputs for the beamforming element)
% BER --- the fiber output BER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
close all
clc
signalType='bpsk';
for L=[20]
[Totalbits,hConEnc]=CovCodebook();
save Totalbits Totalbits
for iter=1:10000; %looping our simulation (Monte Carlo) 
    iter      %for counting the loops
%% fiber-link transmission
[yreceived1_left]=leftsidebandmain(L,1e-3,signalType,iter);
[yreceived1_right]=rightsidebandmain(L,1e-3,signalType,iter);
load wavedataSM.mat
bitsnew(:,iter)=bits;
controlbitsset(:,iter)=controlbits;
yreceived1new_left(:,iter)=yreceived1_left;
yreceived1new_right(:,iter)=yreceived1_right;
end
yreceived1new=[yreceived1new_left(:),yreceived1new_right(:)];
Transmittedsymbol=transpose(yreceived1new);
% Transmittedsymbol(1,zerosymbol1)=0;
% Transmittedsymbol(2,zerosymbol2)=0;
%==============================BPSK demo=======================================%
% load wavedataSM.mat
% %==========16qam demodulation and BER=======%
if strcmp(signalType,'bpsk')
[b_hat1]=real(sum((Transmittedsymbol)))>0;
elseif strcmp(signalType,'4qam')
[b_hat1]=qam4_demo(sum(Transmittedsymbol));
elseif strcmp(signalType,'16qam')
[b_hat1]=qam16_demo(sum(Transmittedsymbol));
end
%%% recovered controlbits
% [controlbitsindexrow,controlbitsindexcol]=find(abs(real(Transmittedsymbol))>0.2);
% controlbitsindexrow(find(controlbitsindexrow==2))=0
%%%
%=========================================================================%
errors1=sum((b_hat1)~=bitsnew(:)');
% controlbits_error=sum((controlbitsindexrow)~=controlbitsset(:));
bitnumber=length(bitsnew);
BER1=errors1/bitnumber;
if BER1==1
    Transmittedsymbol=-Transmittedsymbol;
end
save (['SM_SSB_20km_2Gbps_bpsk_coded' num2str(L) 'm.mat'],...
    'bitsnew', 'Transmittedsymbol','BER1',...
    'controlbitsset')
clear all
close all
clc
end
toc;