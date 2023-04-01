function [BitstreamNonDiff Bitstream Voltage1 Voltage2]= BitGen(Datarate, SignalTime, Vpi, Fsampling) 
% how was the bit generated in this way. I have no idea..fuck fuck fuck
% fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
% fuck fuck fuck fuck fuck 
BitstreamNonDiff= randn(1,(SignalTime* Datarate))>0;

Bitstream(1)=BitstreamNonDiff(1);
for count=2:length(BitstreamNonDiff)
    Bitstream(count)= xor(Bitstream(count-1),BitstreamNonDiff(count)); %%%% why?? Motherfucker what the fuck is this.
end


VoltageVal = (Bitstream-0.5) *Vpi;
UpsampleRatio= Fsampling/Datarate;
% i am such an idiot not understanding even one statement in this m file.
% motherfucker sisterfucker shit 


ReshapedVoltage= reshape(VoltageVal, 2, length(VoltageVal)/2);
for Count=1:length(ReshapedVoltage(1,:))
    Voltage1Val(2*Count-1)= ReshapedVoltage(1,Count);
    Voltage2Val(2*Count-1)= ReshapedVoltage(2,Count);
    Voltage1Val(2*Count)= (ReshapedVoltage(2,Count)*-1)+ Vpi;
    Voltage2Val(2*Count)= ReshapedVoltage(1,Count)*-1;
end

Voltage1=kron(Voltage1Val,ones(1,UpsampleRatio));
Voltage2=kron(Voltage2Val,ones(1,UpsampleRatio));

% go to gym then.