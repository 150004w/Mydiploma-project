function [encodedData,hConEnc]=CovCodebook()
Totalnumber=200*10000;
bits=round(rand(Totalnumber,1));
Orbits=bits;
hConEnc = comm.ConvolutionalEncoder;
encodedData = step(hConEnc, bits);
 hDec = comm.ViterbiDecoder('InputFormat','Hard');
save Orbits Orbits hDec
