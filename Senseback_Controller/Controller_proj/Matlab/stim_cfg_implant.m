function stim_cfg_implant(handles,stim_cfg,stim_amp,phase_dur, stim_chan_a,stim_chan_b,asymm,interphase,period,ramp,reps)


invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(34)); %Tell TX how many bytes are in the packet

write_cfg(handles,stim_cfg,0,stim_amp);
write_cfg(handles,stim_cfg,1,phase_dur);
write_cfg(handles,stim_cfg,2,bitor(stim_chan_a, uint8(bitshift(asymm,6))));
write_cfg(handles,stim_cfg,3,stim_chan_b);
write_cfg(handles,stim_cfg,4,interphase);
write_cfg(handles,stim_cfg,5,period);
write_cfg(handles,stim_cfg,6,ramp);
write_cfg(handles,stim_cfg,7,reps);

invoke(handles.hrealterm, 'putchar', uint8(0));
invoke(handles.hrealterm, 'putchar', uint8(0));

end