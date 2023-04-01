function [RFsignal11,RFsignal21,RFsignal12,RFsignal22]=wavegeneratorSM(signalType,f_sampling,f_c,T,iter)
% the bit is not fixed each time to support the multiplexing
% rng('default')
load Totalbits
if strcmp(signalType,'bpsk')
uncodedbitrate=1e9;
bitrate=uncodedbitrate*2;
samples=f_sampling*T;
bitsnumber=bitrate*T;
bits=transpose(Totalbits(2*(iter-1)*bitsnumber+1:(2*iter-1)*bitsnumber,1));

bits_per_symbol=1;
symbols=bitsnumber/bits_per_symbol;
symbolrate=bitrate/bits_per_symbol;
samples_per_symbol=f_sampling/symbolrate;
Tbit=(0:(samples-1))/f_sampling;
%==bit sequence========%
sn=2*(bits-0.5);
%======================% 
elseif strcmp(signalType, 'dbpsk')
    sn(1)=1+(0*i);
    for k=2:symbols
        if bits(k)==0
            Phaseshift=0;
        else
            Phaseshift=pi;
        end
        sn(k)=sn(k-1)*exp(j*Phaseshift);
    end
elseif strcmp(signalType, '4qam')
bitrate=4e9;
samples=f_sampling*T;
bitsnumber=bitrate*T;
bits=round(rand(1,bitsnumber));
bits_per_symbol=2;
symbols=bitsnumber/bits_per_symbol;
symbolrate=bitrate/bits_per_symbol;
samples_per_symbol=f_sampling/symbolrate;
Tbit=(0:(samples-1))/f_sampling;
b_hat=reshape(bits,bits_per_symbol,symbolrate*T);
b_1=b_hat(1,:);
b_2=b_hat(2,:);
sn1=-2*(b_1-0.5)+1j*-2*(b_2-0.5);
sn=sn1.*sqrt(size(sn1,2)./...
    sum(abs(sn1).^2));
elseif strcmp(signalType, '16qam')
    bitrate=8e9;
samples=f_sampling*T;
bitsnumber=bitrate*T;
bits=round(rand(1,bitsnumber));
bits_per_symbol=4;
symbols=bitsnumber/bits_per_symbol;
symbolrate=bitrate/bits_per_symbol;
samples_per_symbol=f_sampling/symbolrate;
Tbit=(0:(samples-1))/f_sampling;
b_mat= reshape (bits,bits_per_symbol,symbolrate*T);
b_1=b_mat(1,:) ;
b_2= b_mat(2,:) ;
b_3= b_mat(3,:) ;
b_4= b_mat(4,:) ;
a=1/sqrt(10);
values =a*[ 3 1 -1 -3];
sn= values( bi2de([b_3.' (xor(b_3,b_4).') ],'left-msb')+1 )...
    +1j* values( bi2de([b_1' (xor(b_1,b_2).') ],'left-msb')+1 );
end
%======================%Control Bits
controlbits=transpose(Totalbits((2*iter-1)*bitsnumber+1:2*iter*bitsnumber,1));
sn1=(real(sn)&controlbits).*sn; % controlbits 1
% sn1([1,4,6,7])=-1;
sn2=xor(real(sn),controlbits).*sn; 
% sn2([2,3,5,8,9,10])=1;
% controlbits 2 here we assume each side band transmit the bits while contaning zero voltage when it is not activated
% st1=upsample(sn1*samples_per_symbol,samples_per_symbol,samples_per_symbol/2);
% st2=upsample(sn2*samples_per_symbol,samples_per_symbol,samples_per_symbol/2);
st=upsample(sn*samples_per_symbol,samples_per_symbol,samples_per_symbol/2);
% figure(1)
% plot(t(1:1000),st(1:1000))

%==pulse shaping=======%
RollOff=0.5;                                                               % Roll off factor of 0.5 was used. % Roll Off Factor of 0.22 was used as per the 3G WCDMA standard
B_rrcos = firrcos(5*samples_per_symbol,1/samples_per_symbol,0.5,2,'rolloff','sqrt'); 
% x1=filter2(B_rrcos,st1);
% x2=filter2(B_rrcos,st2);

x=filter2(B_rrcos,st);

% zerosymbol1=find(sn1==0);
% zerosymbol2=find(sn2==0);
% x1=x;
% x2=x;
% for stuff=zerosymbol1;
% x1(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
% end
% for stuff=zerosymbol2;
% x2(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
% end

% figure(9)
% plot(real(x1))
% figure(10)
% plot(real(x2))
% figure(11)
% plot(real(x))


% figure(2)
% plot(t(1:1000),x(1:1000))
% figure(3)
% pwelch(x,[],[],[],f_sampling,'onesided')
%======================%

%==carrier frequency==%
Sc=exp(1j*2*pi*f_c*Tbit);
Sc2=exp(1j*(2*pi*f_c*Tbit+pi/2));
% figure(4)
% plot(t(1:100),Sc(1:100))
%=====================%
%==modulation=========%
RFsignal11=real(x.*Sc)/2;
RFsignal21=real(x.*Sc2)/2;
RFsignal12=real(x.*Sc)/2;
RFsignal22=real(x.*Sc2)/2;
RFsignal1=real(x.*Sc);
RFsignal2=real(x.*Sc);
zerosymbol1=find(sn1==0);
zerosymbol2=find(sn2==0);
x1=x;
x2=x;
for stuff=zerosymbol1;
RFsignal11(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
RFsignal21(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
RFsignal1(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
end
for stuff=zerosymbol2;
RFsignal12(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
RFsignal22(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
RFsignal2(((stuff-1)*(samples_per_symbol)+1:stuff*(samples_per_symbol)))=0;
end
RFTransmittedPower1=sum(abs((RFsignal1).^2))/length(RFsignal11);
RFTransmittedPower2=sum(abs((RFsignal2).^2))/length(RFsignal12);
BasebandPower=sum(abs(x.^2))/length(x);
% figure(5)
% pwelch(Sc,[],[],[],f_sampling,'onesided')
% %=====================%
% figure(10)
% plot(x)
% figure(17)
% plot(real(RFsignal11))
% figure(13)
% plot(RFsignal12)
% figure(14)
% plot(RFsignal12)
% figure(15)
% plot(RFsignal22)
% figure(16)
% plot(RFsignal)
BasebandBandwidth= (symbolrate/2)*(1+0.5); 
save wavedataSM.mat bits zerosymbol1 zerosymbol2 RFsignal2 RFsignal1 x x1 x2 RFTransmittedPower1 RFTransmittedPower2 B_rrcos Tbit RFsignal11 RFsignal21 RFsignal22 RFsignal12 controlbits sn sn1 sn2 samples_per_symbol symbolrate B_rrcos symbols bitsnumber BasebandPower BasebandBandwidth


