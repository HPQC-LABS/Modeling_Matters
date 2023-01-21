#!/usr/bin/env python
# Author: Nike Dattani, nike@hpqc.org

import pyscf
from pyscf import gto, scf, ao2mo, cc

mol = gto.Mole()
mol.atom = ''' O
               H  1  0.9576257
               H  1  0.9576257  2 104.51 '''
mol.unit = 'angstrom'
mol.basis = 'STO-3G'
mol.charge = 0
mol.spin = 0
mol.verbose = 9
mol.symmetry = True
mol.symmetry_subgroup = 'C2v'
name = 'out'
#mol.output = name+'.txt' # only worked up to end of SCF (CC output went to stdout)
mol.build()

#####################
## Hartree-Fock:
#####################

mf = mol.RHF().set(chkfile = name + '.chk')
mf.kernel()

pyscf.tools.fcidump.from_chkfile(name+'.fcidump',name+'.chk', tol=1e-18, float_format=' %.16g', molpro_orbsym=False, orbsym=None)
mf = pyscf.tools.fcidump.to_scf(name+'.fcidump', molpro_orbsym=False, mf=None)
mf.run()

#####################
## post-Hartree-Fock:
#####################

mcc = cc.CCSD(mf).set(frozen=1,verbose=9)
e = mcc.kernel()
et = mcc.ccsd_t() # works only when not reading FCIDUMP file.

#####################
## END OF INPUT 
#####################
