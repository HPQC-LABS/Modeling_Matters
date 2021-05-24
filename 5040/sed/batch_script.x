cp template.inp B3LYP.inp; sed -i '6s/functional/B3LYP/' B3LYP.inp;
cp template.inp PBE.inp;   sed -i '6s/functional/PBE/'   PBE.inp;
cp template.inp HSE06.inp; sed -i '6s/functional/HSE06/' HSE06.inp;
