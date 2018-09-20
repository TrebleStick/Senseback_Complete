

invoke(handles.hrealterm, 'putchar', uint8(23)); %send 0x17 start heartbeat monitor

disp('heartbeat monitor started')
% pause(2);
%
%
invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(2)); %Tell TX how many bytes are in the packet
write_reg(handles,10,1);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));

disp('sent 0x02 to reg 3');
% pause(2);
%
%
% invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
% invoke(handles.hrealterm, 'putchar', uint8(4)); %Tell TX how many bytes are in the packet
% write_reg(handles,9,1);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));
%
% disp('sent 0x01 to reg 9');
% pause(2);


% invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
% invoke(handles.hrealterm, 'putchar', uint8(4)); %Tell TX how many bytes are in the packet
% read_reg(handles,1,1);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));
%
% disp('read reg 1');
% pause(2);

invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
invoke(handles.hrealterm, 'putchar', uint8(2)); %Tell TX how many bytes are in the packet
read_reg(handles,10,10);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));

disp('read reg 2');
