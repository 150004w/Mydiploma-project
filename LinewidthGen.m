function y = LinewidthGen(LineWidth,Fs,NumberoOfSamples)
%FMMOD Frequency modulation.
%   Y = FMMOD(X,Fc,Fs,FREQDEV) uses the message signal X to modulate the
%   carrier frequency Fc (Hz) and sample frequency Fs (Hz),  where Fs >
%   2*Fc. FREQDEV (Hz) is the frequency deviation of the modulated signal.
%
%   Y = FMMOD(X,Fc,Fs,FREQDEV,INI_PHASE) specifies the initial phase of
%   the modulation.
%
%   See also FMDEMOD, PMMOD, PMDEMOD.

%    Copyright 1996-2007 The MathWorks, Inc. 
%   $Revision: 1.1.6.3 $  $Date: 2007/08/03 21:17:32 $

error(nargchk(1,5,nargin,'struct'));

imagconst=sqrt(-1);
x= 2*pi*LineWidth*randn(1,NumberoOfSamples);
 
% --- Assure that X, if one dimensional, has the correct orientation --- %
len = size(x,1);

if(len == 1)
    x = x(:);
end

int_x = cumsum(x)/Fs;
y = exp(imagconst*int_x);   

% --- restore the output signal to the original orientation --- %
if(len == 1)
    y = y';
end
    
% EOF