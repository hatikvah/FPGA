clear;

Num_dat = 2^9;
Wid_dat = 32;

fmt_dat = 'HEX';
num_dat = 'DEC';

d = (0:Num_dat-1)'*pi*2/Num_dat;
sin_d = sin(d)./2;

fileID = fopen('sin_rom.mif','w');
fprintf(fileID,  'DEPTH = %d;\n',  Num_dat);
fprintf(fileID,  'WIDTH = %d;\n',  Wid_dat);
fprintf(fileID,  'ADDRESS_RADIX = %s;\n',  num_dat);
fprintf(fileID,  'DATA_RADIX    = %s;\n',  fmt_dat);
fprintf(fileID,  'CONTENT\n');
fprintf(fileID,  'BEGIN\n');

for i = 1 : Num_dat
    c=fi(sin_d(i),1, 32, 31);
    fprintf(fileID,'% 4d  :  %s;\n', (i-1),  c.hex);
end

fprintf(fileID,  'END;\n');
fclose(fileID);



d = (0:Num_dat-1)'*pi*2/Num_dat;
cos_d = cos(d)./2;

fileID = fopen('cos_rom.mif','w');
fprintf(fileID,  'DEPTH = %d;\n',  Num_dat);
fprintf(fileID,  'WIDTH = %d;\n',  Wid_dat);
fprintf(fileID,  'ADDRESS_RADIX = %s;\n',  num_dat);
fprintf(fileID,  'DATA_RADIX    = %s;\n',  fmt_dat);
fprintf(fileID,  'CONTENT\n');
fprintf(fileID,  'BEGIN\n');

for i = 1 : Num_dat
    c=fi(cos_d(i),1, 32, 31);
    fprintf(fileID,'% 4d  :  %s;\n', (i-1),  c.hex);
end

fprintf(fileID,  'END;\n');
fclose(fileID);
