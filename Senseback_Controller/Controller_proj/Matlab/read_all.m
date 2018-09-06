function read_all(handles)

num_regs = 10;
for i = 1:num_regs

invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(2)); %Tell TX how many bytes are in the packet

    read_reg(handles, i,i);
    pause(0.5);
    %padding the commands
    % invoke(handles.hrealterm, 'putchar', uint8(0));
    % invoke(handles.hrealterm, 'putchar', uint8(0));
end

%read reg 10 agina dude to delay in output
invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(2)); %Tell TX how many bytes are in the packet
read_reg(handles,10,10);
