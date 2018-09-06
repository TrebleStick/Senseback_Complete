function parse_reg(handles, filename)
startSaving_implant(handles, filename);

disp('Reading Registers.');
%read all reg commands twice to account for delay in return Data
read_all(handles);
read_all(handles);

stopSaving_implant(handles);

%create empty array to store register data
max_reg=10;
registers = zeros(max_reg,1);

if exist(filename, 'file')
  readfile = fopen(filename,'r'); %open capture file for read
  frewind(readfile);
  fsize = dir(filename);
  disp('File found & opened.');
else
  disp('Capture file %s not found.', filename);
end

disp('Parsing data.');

if (fsize.bytes == 0)
  disp('File is empty.');
  fclose(readfile);
else
  for i=1:fsize.bytes
    data = fread(readfile,1,'uint8');
    if (data == 218)
      data = fread(readfile,1,'uint8');
      i=i+1;
      if (data == 122)
        data = fread(readfile,1,'uint8');
        i=i+1;
        if (data == 7)
          i = i+7;
          throw = fread(readfile,3,'uint8');
          reg = fread(readfile,1,'uint8');
          data = fread(readfile,1, 'uint8');
          throw = fread(readfile,2,'uint8');
          if (reg > max_reg)
            %not a register value do nothing

          else
            %valid register value
            registers(reg) = data;
          end
        end
      end
    end
  end
  fclose(readfile);
end

for i=1:max_reg
  fprintf('Reg %d : %d \n', i, registers(i));
end
