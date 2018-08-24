function stim_cfg(fid,cfg,amp,hAmp,phDur,chA,chB,asymm,iphDur,period,ramp,reps)

byte =uint8(zeros(8,1));

byte(1) = uint8(bitor(amp,bitshift(hAmp,7)));
byte(2) = uint8(phDur);
byte(3) = uint8(bitor(chA,bitshift(asymm,6)));
byte(4) = uint8(chB);
byte(5) = uint8(iphDur);
byte(6) = uint8(period);
byte(7) = uint8(ramp);
byte(8) = uint8(reps);

for i=1:8
write_cfg_fx3(fid,cfg,i,byte(i));
end

end