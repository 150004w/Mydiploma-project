clear all
close all
clc
open('BER_21_nobeamforming_coded5.fig')
h=findobj(gca,'Type','line')
x1=get(h,'Xdata');
y1=get(h,'Ydata');
open('BER_21_nobeamforming_coded4.fig')
h=findobj(gca,'Type','line')
x2=get(h,'Xdata');
y2=get(h,'Ydata');
open('BER_21_nobeamforming_coded3.fig')
h=findobj(gca,'Type','line')
x3=get(h,'Xdata');
y3=get(h,'Ydata');
open('BER_21_nobeamforming_coded2.fig')
h=findobj(gca,'Type','line')
x4=get(h,'Xdata');
y4=get(h,'Ydata');
open('BER_21_nobeamforming_coded1.fig')
h=findobj(gca,'Type','line')
x5=get(h,'Xdata');
y5=get(h,'Ydata');
BER1=(y1+y2+y3+y4+y5)./5;

save BER_21_nobeamforming_coded_all  BER1
figure(6)
semilogy(0:40,BER1)
grid on