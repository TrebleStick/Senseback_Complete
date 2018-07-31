function write_cfg(handles, cfg_register,cfg_byte,data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if cfg_register>31 || cfg_register <0 || data <0 || data > 255 || cfg_byte <0 || cfg_byte >7
    fprintf('cfg_register 0-31, data 0-255, cfg_byte 0-7');
    return;
end
REG_WRITE_CMD = uint8(192);
data_h_nibble = bitor(bitshift(uint8(data),-4),uint8(16) );
data_l_nibble = bitand(uint8(15),uint8(data));

invoke(handles.hrealterm, 'putchar', bitor(REG_WRITE_CMD, uint8(cfg_register)) );
invoke(handles.hrealterm, 'putchar', bitor(bitshift(uint8(cfg_byte),5),data_h_nibble)   );

invoke(handles.hrealterm, 'putchar', bitor(REG_WRITE_CMD, uint8(cfg_register)) );
invoke(handles.hrealterm, 'putchar', bitor(bitshift(uint8(cfg_byte),5),data_l_nibble)   );


end

