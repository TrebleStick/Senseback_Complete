function en_stim_implant(handles,stim_cfg,stim_amp,phase_dur, stim_chan_a,stim_chan_b,asymm,interphase,period,ramp,reps)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if stim_cfg >31 || stim_cfg<0 || ...
stim_amp > 255||  stim_amp <0 ||...
phase_dur > 255||  phase_dur <0 ||...
 stim_chan_a > 31||  stim_chan_a <0 ||...
stim_chan_b > 31||  stim_chan_b <0 ||...
asymm > 3||  asymm < 0||...
interphase > 255||  interphase <0 ||...
period > 255||  period < 0||...
ramp > 255||  ramp < 0||...
reps > 255||  reps < 0

    disp('error in vals all are 8 bit except asymm which is 2 bit and chan is 5 bit');
return;
end

stim_cfg_implant(handles,stim_cfg,stim_amp,phase_dur, stim_chan_a,stim_chan_b,asymm,interphase,period,ramp,reps)
% en_stim_cfg_implant(handles,stim_cfg);


end
