%Initialize
% hrealterm=actxserver('realterm.realtermintf');
% hrealterm.baud=1000000;
% hrealterm.flowcontrol=0; %no handshaking currently
% hrealterm.Port='3';
% hrealterm.PortOpen=1; %open the comm port

% variables
% image = dir('C:\Users\songl\Documents\Senseback_implant\pca10040\blank\armgcc\_build\nrf52832_xxaa.bin');
image = dir('test_implant_image.bin');
%this works with absolute and relative paths
image_size = sum([image.bytes]); %find file size

packet_acknowledged = 0;
bytes_received = 0;
fsize = 0;
fsizenew = 0;
command = zeros(4);
data = zeros(248);

if exist('C:\temp\cap2.bin', 'file')
  readfile = fopen('C:\temp\cap2.bin','r'); %open capture file for read
  frewind(readfile);
else
  % File does not exist. Create file.
  fclose(fopen('C:\temp\cap2.bin', 'w'));
  readfile = fopen('C:\temp\cap2.bin','r'); %open capture file for read
end

if readfile < 3
    errordlg('Data capture file not opened. Check existence of file at C:\temp\cap.bin, permissions and whether the file is opneed in another program.',...
        'Invalid Input','modal')
    uicontrol(hObject)
    return
end

%Make sure realterm uses cap.bin as capture file
handles.hrealterm.CaptureFile='C:\temp\cap2.bin';
handles.hrealterm.CaptureAsHex = 0;
invoke(handles.hrealterm,'StartCapture'); %start capture on realterm

% Open implant Image File
fid = fopen('test_implant_image.bin','r');
x = fread(fid,'uint32');
checksum = uint32(mod(sum(x),2^32));
% checksum = uint64(0);
% for i=1:(floor(image_size/4)) %get checksum for whole image%
%    checksum = checksum + uint64(fread(fid,1,'uint32',0,'a'));
%     % read file (open file, read only one emelent, size of each row(precision), number of bytes to skip, 'ieee-le' little endian, 64 bit long data type);
% end

frewind(fid); %sets the file position indicator to the beginning of the file
%fclose(fid);
% b = mod(checksum, 4294967296) %modulus generates a checksum
% checksum = b;

%Create Progress Bar
h = waitbar(0,'Upload');

%Pause heartbeat monitor
invoke(handles.hrealterm, 'putchar', hex2dec('23'));

%sample uart feedback file size
% invoke(handles.hrealterm,'StartCapture'); %start capture on realterm
fsize = dir('C:\temp\cap2.bin'); %new filesize info

%Begin Upload Command Packet
packet_acknowledged = 0;
bytes_received = 0;
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 3);
invoke(handles.hrealterm, 'putchar', hex2dec('FB'));
invoke(handles.hrealterm, 'putchar', hex2dec('9A'));
invoke(handles.hrealterm, 'putchar', hex2dec('BB'));
pause(0.5);
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 1);
invoke(handles.hrealterm, 'putchar', hex2dec('61'));
pause(0.1);
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 1);
invoke(handles.hrealterm, 'putchar', hex2dec('61'));
pause(0.1);
%poll for new data after the command sequence
tic;
while ((toc < 1) && bytes_received == 0)
    fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
    pause(0.05);
    disp('wait for data')
    if (fsizenew.bytes > (fsize.bytes + 4))
       bytes_received = 1;
       disp('bytes received')
    end
end


if (bytes_received ==1)
  for j=1:fsizenew.bytes
    command = fread(readfile,1,'uint8')';

    if (command == 218)
      command = fread(readfile,1,'uint8')';

      if (command == 122)
        command = fread(readfile,1,'uint8')';

        if (command == 4)
          data = fread(readfile,4,'uint8')'; %read the next three
          disp('cmd return')
          if (data(4) == 1)   %validation payload from implant
              packet_acknowledged = 1;
              j = fsizenew.bytes;
          end
        end
      end
    end
  end
  fsize.bytes = fsizenew.bytes;
end
% if (bytes_received == 1)
%     command = fread(readfile,4,'uint8')';
%     if (command(1) == 218 && command(2) == 122 && command(3) == 4) %look for 0xDA 0x7A 0x04
%         data = fread(readfile,3,'uint8')'; %read the next three
%         disp('cmd return')
%         if (data(3) == 1)   %validation payload from implant
%             packet_acknowledged = 1;
%         end
%
%
%     else
%       disp(command(1))
%       disp(command(2))
%       disp(command(3))
%     end
%     fsize.bytes = fsizenew.bytes;
% end

if (packet_acknowledged == 0) %close for comms error
    disp('transmission error_0')
    invoke(handles.hrealterm,'stopcapture');
    close(h);
    fclose(fid);
    fclose(readfile);
    return
end


% invoke(handles.hrealterm,'stopcapture');

for j=1:floor(image_size/28)
    packet_acknowledged = 0;
    bytes_received = 0;
    fsize = dir('C:\temp\cap2.bin'); %new filesize info
    invoke(handles.hrealterm, 'putchar', hex2dec('85'));
    invoke(handles.hrealterm, 'putchar', 31);
    invoke(handles.hrealterm, 'putchar', hex2dec('FB'));
    invoke(handles.hrealterm, 'putchar', hex2dec('9A'));
    invoke(handles.hrealterm, 'putchar', 7);
    for i=1:28
        data = fread(fid,1, 'uint8');
        invoke(handles.hrealterm, 'putchar', data);
        % disp(data)
    end

    pause(0.5);
    % invoke(handles.hrealterm, 'putchar', hex2dec('85'));
    % invoke(handles.hrealterm, 'putchar', 1);
    % invoke(handles.hrealterm, 'putchar', hex2dec('61'));
    % pause(0.1);
    % invoke(handles.hrealterm, 'putchar', hex2dec('85'));
    % invoke(handles.hrealterm, 'putchar', 1);
    % invoke(handles.hrealterm, 'putchar', hex2dec('61'));
    % pause(0.1);
    tic
    while ((toc < 1) && bytes_received == 0)
        invoke(handles.hrealterm, 'putchar', hex2dec('85'));
        invoke(handles.hrealterm, 'putchar', 1);
        invoke(handles.hrealterm, 'putchar', hex2dec('61'));
        pause(0.1);

        fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
        if (fsizenew.bytes > (fsize.bytes + 4))
           bytes_received = 1;
        end
    end
    % if (bytes_received == 1)
    %     command = fread(readfile,4,'uint8')';
    %     if (command(1) == 218 && command(2) == 122 && command(3) == 4)
    %         data = fread(readfile,3,'uint8')';
    %         if (data(3) == 1)
    %             packet_acknowledged = 1;
    %         end
    %
    %     end
    %     fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
    %     fsize = fsizenew;
    % end
    if (bytes_received == 1)
      for j=1:fsizenew.bytes
        command = fread(readfile,1,'uint8')';

        if (command == 218)
          command = fread(readfile,1,'uint8')';

          if (command == 122)
            command = fread(readfile,1,'uint8')';

            if (command == 4)
              data = fread(readfile,4,'uint8')'; %read the next three
              disp('cmd return')
              disp(data(4))
              if (data(4) == 1)   %validation payload from implant
                  packet_acknowledged = 1;
                  j = fsizenew.bytes;
              end
            end
          end

        else
          disp(command)
        end
      end
      fsize.bytes = fsizenew.bytes;
    end
    if (packet_acknowledged == 1)
        waitbar(j/image_size,h);
    else
        disp('transmission error_1')
        invoke(handles.hrealterm,'stopcapture');
        close(h);
        fclose(fid);
        fclose(readfile);
        return
    end

end

%temp for testing -----------%
% disp('WOOP')
% invoke(handles.hrealterm,'stopcapture');
% close(h);
% fclose(fid);
% fclose(readfile);
% return
%variables for overflow packets to be sent outside of the 248 chunks
ex_packets = mod(image_size, 28);
ex_masks = mod(ex_packets, 4);
%--------------------------------%
%Last data packet
packet_acknowledged = 0;
bytes_received = 0;
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', ex_packets+ex_masks+3);
invoke(handles.hrealterm, 'putchar', hex2dec('FB'));
invoke(handles.hrealterm, 'putchar', hex2dec('9A'));
invoke(handles.hrealterm, 'putchar', (ex_masks+ex_packets)/4);
for i=1:ex_packets

    invoke(handles.hrealterm, 'putchar', fread(fid,1));

end

if (ex_masks ~= 0) %deal with the overflow for the case of image size not divisible by 4 so 32 bit arrays can be written on th implant end (this is accounted for in the checksum)
  for i=1:ex_masks

    invoke(handles.hrealterm, 'putchar', hex2dec('FF'));

  end
end
pause(0.2);
tic
while ((toc < 1) && bytes_received == 0)
    invoke(handles.hrealterm, 'putchar', hex2dec('85'));
    invoke(handles.hrealterm, 'putchar', 1);
    invoke(handles.hrealterm, 'putchar', hex2dec('61'));
    pause(0.1);
    fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
    if (fsizenew.bytes > (fsize.bytes + 4))
       bytes_received = 1;
    end
end
% if (bytes_received == 1)
%     command = fread(readfile,4,'uint8')';
%     if (command(1) == 218 && command(2) == 122 && command(3) == 4)
%         data = fread(readfile,3,'uint8')';
%         if (data(3) == 1)
%             packet_acknowledged = 1;
%         end
%
%     end
%     fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
%     fsize = fsizenew;
% end

if (bytes_received == 1)
  for j=1:fsizenew.bytes
    command = fread(readfile,1,'uint8')';

    if (command == 218)
      command = fread(readfile,1,'uint8')';

      if (command == 122)
        command = fread(readfile,1,'uint8')';

        if (command == 4)
          data = fread(readfile,4,'uint8')'; %read the next three
          disp('cmd return')
          disp(data(4))
          if (data(4) == 1)   %validation payload from implant
              packet_acknowledged = 1;
              j = fsizenew.bytes;
          end
        end
      end

    else
      disp(command)
    end
  end
  fsize.bytes = fsizenew.bytes;
end

if (packet_acknowledged == 1)
    waitbar(j/image_size,h);
else
    disp('transmission error_2')
    invoke(handles.hrealterm,'stopcapture');
    close(h);
    fclose(fid);
    fclose(readfile);
    return
end




%Validation command packet
packet_acknowledged = 0;
bytes_received = 0;
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 11);
invoke(handles.hrealterm, 'putchar', hex2dec('FB'));
invoke(handles.hrealterm, 'putchar', hex2dec('9A'));
invoke(handles.hrealterm, 'putchar', hex2dec('CC'));
msg = typecast(uint32(checksum),'uint8');
for i=1:4
    invoke(handles.hrealterm, 'putchar', msg(i));
end
msg = typecast(uint32(image_size),'uint8');
for i=1:4
    invoke(handles.hrealterm, 'putchar', msg(i));
end
pause(0.5);
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 1);
invoke(handles.hrealterm, 'putchar', hex2dec('61'));
pause(0.1);
invoke(handles.hrealterm, 'putchar', hex2dec('85'));
invoke(handles.hrealterm, 'putchar', 1);
invoke(handles.hrealterm, 'putchar', hex2dec('61'));
pause(0.1);
tic;
while ((toc < 1) && bytes_received == 0)
    fsizenew = dir('C:\temp\cap2.bin'); %new filesize info
    pause(0.05);
    if (fsizenew.bytes > (fsize.bytes + 4))
       bytes_received = 1;
    end
end
% if (bytes_received == 1)
%     command = fread(readfile,4,'uint8')';
%     if (command(1) == 218 && command(2) == 122 && command(3) == 4)
%         data = fread(readfile,3,'uint8')';
%         if (data(3) == 1)
%             packet_acknowledged = 1;
%         end
%
%     end
%     fsize.bytes = fsizenew.bytes;
% end

if (bytes_received == 1)
  for j=1:fsizenew.bytes
    command = fread(readfile,1,'uint8')';

    if (command == 218)
      command = fread(readfile,1,'uint8')';

      if (command == 122)
        command = fread(readfile,1,'uint8')';

        if (command == 4)
          data = fread(readfile,4,'uint8')'; %read the next three
          disp('cmd return')
          disp(data(4))
          if (data(4) == 1)   %validation payload from implant
              packet_acknowledged = 1;
              j = fsizenew.bytes;
          end
        end
      end

    else
      disp(command)
    end
  end
  fsize.bytes = fsizenew.bytes;
end

if (packet_acknowledged == 0)
    disp('transmission error_3')
    invoke(handles.hrealterm,'stopcapture');
    close(h);
    fclose(fid);
    fclose(readfile);
    return
end

invoke(handles.hrealterm,'stopcapture');
close(h);
fclose(fid);
fclose(readfile);

%Close
%invoke(handles.hrealterm,'close');
%delete(hrealterm);
