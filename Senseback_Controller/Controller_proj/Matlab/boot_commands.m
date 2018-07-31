 % script to initiate new app update OTA with communication with the controller


%en_rec_implant(handles,0,0,0,0,0,15,15,0,0);
invoke(handles.hrealterm, 'putstring', ' '); %reset sequence
pause(10); %wait for connection to establish


invoke(handles.hrealterm, 'putstring', 'B'); %Initialise boot
pause(1);


% image = dir('implant_image.bin');    %this also works with absolute paths
image = dir('C:\Users\songl\Documents\Senseback_implant\pca10040\blank\armgcc\_build\nrf52832_xxaa.bin');
image_size = sum([image.bytes]); %find file size
image_size = image_size + (4 - mod(image_size, 4)); %make the size a multiple of 4 for flashwriting masks
image_size_string = num2str(image_size);
image_size_length = size(image_size_string);
  %size returns 1 and length of the string in a 2 element array (index at 1)
% pack up the file size into a string depending on it's length
size_cmd = 'B';

for j=1:(6-image_size_length(2))
  size_cmd = strcat(size_cmd,'0');
end
size_cmd = strcat(size_cmd, image_size_string);

invoke(handles.hrealterm, 'putstring', size_cmd); %send file size
pause(1);


firmware_flash_upload;

pause(10);

invoke(handles.hrealterm, 'putstring', 'B'); %check size is valid
pause(1);
invoke(handles.hrealterm, 'putstring', 'B'); %Boot form new application address
