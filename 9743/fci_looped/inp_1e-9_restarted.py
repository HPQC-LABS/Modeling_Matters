#!/usr/bin/env python
# Author: Nike Dattani, nike@hpqc.org

'''
LiH+ in aug-cc-pV2Z
'''

import numpy as np
import pyscf
from pyscf.gto.basis import parse_gaussian
from pyscf import gto, scf, ao2mo, fci

mol = pyscf.M(
    atom = 'Li 0 0 0; H 0 0 4.143',
    unit = 'bohr',
    basis = 'aug-cc-pvDz',
    charge = 1,
    spin = 1,
    verbose = 9,
    symmetry = True,
    output = 'out_1e-9_restarted.txt',
    symmetry_subgroup = 'C2v',
    max_memory =4000,
)

#####################
## Hartree-Fock:
#####################
mf = mol.RHF().set(conv_tol=1e-10,max_cycle=999,direct_scf_tol=1e-14,chkfile = 'out_1e-9_restarted.chk').run()

#####################
## post-Hartree-Fock:
#####################

for sym in ['A1','A2','B1','B2']:
    mci = fci.FCI(mol, mf.mo_coeff, singlet=False).set(conv_tol=1e-9,max_cycle=999,wfnsym = sym)
#   e, civec = mci.kernel(nroots=2)
    e, civec = mci.kernel(nroots=2,ci0=np.load('civec'+sym+'.npy'))
    np.save('civec'+sym+'.npy', civec)
    print('{}: {}'.format(sym,e))

#####################
## END OF INPUT 
#####################
