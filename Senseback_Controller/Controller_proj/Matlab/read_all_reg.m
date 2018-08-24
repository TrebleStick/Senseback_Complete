function read_all_reg(handles)

num_regs = 10;

invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(num_regs*2+2)); %Tell TX how many bytes are in the packet

for i = 1:num_regs
    read_reg(handles, i,i);
end

invoke(handles.hrealterm, 'putchar', uint8(0));
invoke(handles.hrealterm, 'putchar', uint8(0));