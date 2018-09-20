%function to read registers in a range from reg_start to reg_end

function read_range_cmd(handles, reg_start, reg_end)

for i = reg_start:reg_end

%tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(133));
%Tell TX how many bytes are in the packet
invoke(handles.hrealterm, 'putchar', uint8(2));
    read_reg(handles, i,i);
    pause(0.5); %give time for response from communication loop
end
