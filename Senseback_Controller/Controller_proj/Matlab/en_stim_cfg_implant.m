function en_stim_cfg_implant(handles,stim_cfg)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if stim_cfg >31 || stim_cfg<0 
    disp('stim_cfg should be an integer between 0 and 31');
end

register =9 + floor(stim_cfg/8);
val = bitset(0,mod(stim_cfg,8)+1,'uint8');

invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(4)); %Tell TX how many bytes are in the packet

write_reg(handles,register,val);

invoke(handles.hrealterm, 'putchar', uint8(0));
invoke(handles.hrealterm, 'putchar', uint8(0));






end

