function stopSaving_implant(handles)
invoke(handles.hrealterm, 'putchar', uint8(35));

invoke(handles.hrealterm,'stopcapture');

end