function read_cfg(handles, cfg_register,cfg_byte,req_id)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if cfg_register>31 || cfg_register <0 || req_id <0 || req_id > 31 || cfg_byte <0 || cfg_byte >7
    fprintf('cfg_register 0-31, req_id 0-31, cfg_byte 0-7');
    return;
end
REG_READ_CFG = uint8(64);
invoke(handles.hrealterm, 'putchar', bitor(REG_READ_CFG, uint8(cfg_register)) );
invoke(handles.hrealterm, 'putchar', bitor(bitshift(uint8(cfg_byte),5),uint8(req_id)));
end

