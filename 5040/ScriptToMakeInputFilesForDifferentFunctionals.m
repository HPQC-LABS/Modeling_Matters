functionals={
    'B3LYP'
    'PBE'
    'HSE06'};

for i = 1:length(functionals)
    fid(i)=fopen(strcat(functionals{i},'.inp'),'w'); % When i=2, create PBE.inp with 'w' (permission to write to the file), and with file ID = 2.
    fprintf(fid,functionals{i});
end
