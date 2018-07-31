function write_reg(handles, register,data)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if register>15 || register <0 || data <0 || data > 255
    fprintf('register 0-15, data 0-255');
    return;
end
REG_WRITE_CMD = uint8(176);
invoke(handles.hrealterm, 'putchar', bitor(REG_WRITE_CMD, uint8(register)) );
invoke(handles.hrealterm, 'putchar', uint8(data));
end

