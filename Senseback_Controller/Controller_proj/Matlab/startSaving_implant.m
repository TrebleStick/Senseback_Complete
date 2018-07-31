function startSaving_implant(handles,filename)

handles.hrealterm.CaptureFile=strcat(filename);
handles.hrealterm.CaptureAsHex = 0; %Make sure we don't save incoming data as hex but rather as 8-bit binary.
invoke(handles.hrealterm,'startcapture');

invoke(handles.hrealterm, 'putchar', uint8(23));

end