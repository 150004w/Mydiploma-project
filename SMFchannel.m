function [signalaftertransmision]=hnlfchannel(u,lambda,Fsampling,L)
% Simulation constants
NumberOfSamples=length(u);                                                 % The number of samples of the transmitted RF signals                                                                      % The time axis value for each frame
dt=1/Fsampling;                                                            % The sampling time period of the RF signal
c = 3e5;                                                                   % speed of light in km/s
i=sqrt(-1);


% FIBER PARAMETERS                                                            % The optical frequency used
alpha_dB = 0.2;                                                              % Attenuation in dB/km
alpha = alpha_dB/4.343;                                                    % Per km---[using relation => alpha_dB(dB/km) = 4.343 * alpha(per km)] 
gamma =2;                                                                 % Fiber non linearity in /W/km
D=18e-12;                                                                  % Dispersion parameter in s/km/nm
beta2 = -(D*lambda^2)/(2*pi*c*1e12);                                       % 2nd order disp. term (s2/km)

% If dispersion compensation is implemented
DispersionCompensation='yes';                                               % Is it a dispersion compensated fibre. 
if strcmp(DispersionCompensation,'yes')
    Lcompensation=5;                                                       % length of compensation fibre.
    Dcompensation=-54e-12;                                                % Dispersion parameter in s/km/nm of compensation fibre
    beta2compensation = -(Dcompensation*lambda^2)/(2*pi*c*1e12);           % 2nd order disp. term (s2/km) 
    gammacompensation=gamma;
elseif strcmp(DispersionCompensation,'no')
    Lcompensation=0;
    beta2compensation=beta2;
    gammacompensation=gamma;
end

%---------------------------------------------------------------------
%   PULSE PROPAGATION --- SPLIT STEP FOURIER METHOD

% The step size is given by the variable "step" but the pulse shape is recorded only after "step1" kms ( and not "step" kms). 
% This is because recording after every "step" kms will result in a huge matrix. 
% op_pulse and output_f logs the output signal in time domain and frequency domain, respectively, at regular intervals of "step1" Kms
% Ensure that total length L is a integer multiple of step1 and that step1 is an integer multiple of step.


ln=1;
input=u;
op_pulse(ln,:)=abs(u).^2;                                                  % Intial time domain plot of the optical signal. The plot considers instantaneous power(intensity)
op_pulse_phase(ln,:)=angle(op_pulse(ln,:));  
spectrum = fftshift(fft(u));
output_f(ln,:) = abs(spectrum).^2;                                         % spectrum of initial optical signal.  
ln = ln+1;                                                                 % Incrementing the recording counter

step =1;                                                                % step size (km). 
jj = step;
l = max(size(u));  
dw = ((2*pi)/dt)/l; 
w=  (-l/2:l/2-1)*dw; %(0:1:l-1)*dw;
u=fftshift(u);
w=fftshift(w);
spectrum=fft(fftshift(u));                                                 % Pulse spectrum


for jj = jj:step:L              %simulation pupose actually fiber length is 1 km
    if  jj <= L-Lcompensation                                              % If conpensation is done then these steps
        beta2current=beta2;                                                % ensure that after propogating through L-Lcompensation Kms of the usual fiber
        gammaCurrent= gamma;                                               % the optical signal propogates through Lcompensation Kms of dispersion compensation fiber
    else                                                                   % if there is no dispersion compensation then Lcompensation=0 and the optical signal propogates through the usual fiber only.
        beta2current=beta2compensation;
        gammaCurrent= gammacompensation;
    end
    %==Dispersion==%
    spectrum=spectrum.*exp(-alpha/2*(step/2)+i*beta2current/2*w.^2*(step/2));  % The non-linear schrodinger equation of signal propogation is numerically
    f=ifft(spectrum);                                                      % solved in these steps by dividing the fiber into steps of length "step"   
    %==nonearity==%  
    %self-phase modulation
    phispm=gammaCurrent*(abs(f).^2)*(step);    
    %spm
    f=f.*exp(i*phispm);
   %============% 
   %second step (dispersion)
    spectrum=fft(f);
    spectrum=spectrum.*exp(-alpha/2*(step/2)+i*beta2current/2*w.^2*(step/2));
    fstep=ifft(spectrum);
    output_f(ln,:) = abs(fftshift(spectrum)).^2; 
    op_pulse(ln,:)=abs(fstep).^2; 
    op_pulse_phase(ln,:)=angle(fstep);
    ln = ln+1; 
end
signalaftertransmision=ifft(spectrum);
% %=========coherent detection===============================================%
% ocillationfrq=exp(j*2*pi*0*t);
% coherentphotodectectedsignal=abs(fstep+ocillationfrq).^2;
% %direct photodetetction
% % coherentphotodectectedsignal=abs(fstep).^2;
% %==========================================================================%
% 
% %=========bandpass filter==================================================%
% BasebandBandwidth=75000000;
% UpperEdgeOfBandwidth= f_c+BasebandBandwidth;                               % Highest frequency in the received signal
% LowerEdgeOfBandwidth= f_c-BasebandBandwidth;                               % Lowest Frequency in the  received RF signal
% FilterCoeff = fir1(10000,[ LowerEdgeOfBandwidth/(0.5*Fsampling) UpperEdgeOfBandwidth/(0.5*Fsampling) ]);    % generating filter coefficients.
% FilteredRFSignal= filter2(FilterCoeff,  coherentphotodectectedsignal);
%==========================================================================%
% figure(1)
% plot(T(1:100),op_pulse(1,1:100),T(1:100),op_pulse(end,1:100),'-*',T(1:100),FilteredRFSignal(1:100),'-^')
% hold on
% plot(T,FilteredRFSignal)
% legend('input','output')
% figure(2)
% plot(T,op_pulse_phase(1,:),T,op_pulse_phase(end,:))
% legend('input','output')
% figure(3)
% hold on
% plot(T(1:100),coherentphotodectectedsignal(1:100),T(1:100),op_pulse(end,1:100))
% hold on
% plot(T(1:200),FilteredRFSignal(1:200),'-*')

% figure(4)
% plot(output_f(1,:))
% hold on
% plot(output_f(end,:),'g')
% figure(5)
% pwelch(input,[],[],[],Fsampling,'power')
% figure(6)
% pwelch(op_pulse(end,:),[],[],[],Fsampling,'power') 
% figure(7)
% pwelch(fstep,[],[],[],Fsampling,'power')
% figure(8)
% pwelch(FilteredRFSignal,[],[],[],Fsampling,'power')
% figure(9)
% hold on
% plot(T(1:200),FilteredRFSignal(1:200),'-*')
% xlabel('t')
% ylabel('Amplitude')
% title('Outout RF signal')
