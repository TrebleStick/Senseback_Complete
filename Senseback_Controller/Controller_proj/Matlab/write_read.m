

invoke(handles.hrealterm, 'putchar', uint8(23)); %send 0x17 start heartbeat monitor

% disp('heartbeat monitor started')
% pause(2);
%
%
% invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
% invoke(handles.hrealterm, 'putchar', uint8(4)); %Tell TX how many bytes are in the packet
% write_reg(handles,1,23);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));
%
% disp('sent 0x17 to reg 1');
% pause(2);
%
%
% invoke(handles.hrealterm, 'putchar', uint8(133)); %tell TX that theres a packet to send
% invoke(handles.hrealterm, 'putchar', uint8(4)); %Tell TX how many bytes are in the packet
% write_reg(handles,2,24);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));
%
% disp('sent 0x18to reg 2');
% pause(2);
%
%
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
read_reg(handles,2,2);
% invoke(handles.hrealterm, 'putchar', uint8(0));
% invoke(handles.hrealterm, 'putchar', uint8(0));

disp('read reg 2');
