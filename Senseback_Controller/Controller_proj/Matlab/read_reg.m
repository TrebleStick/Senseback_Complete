function read_reg(handles, register,req_id)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if register>15 || register <0 || req_id <0 || req_id > 31
    fprintf('register 0 - 15, req_id 0 - 31');
    return;
end
REG_READ_CMD = uint8(48);
invoke(handles.hrealterm, 'putchar', bitor(REG_READ_CMD, uint8(register)) );
invoke(handles.hrealterm, 'putchar', uint8(req_id));
end

