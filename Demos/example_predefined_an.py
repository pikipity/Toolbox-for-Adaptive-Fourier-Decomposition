import numpy as np

from AFDCal import AFDCal
from AFDCal._io import savefig

#########################################################
# Prepare predefined an array
# The an array is predefined as the an array obtained from the fast AFD
#########################################################
# init AFD Calculation
afdcal = AFDCal()
# Load input signal
afdcal.loadInputSignal('bump_signal.mat')
# set decomposition method: Single Channel fast AFD
afdcal.setDecompMethod(2)
# set dictionary generation method: circle
afdcal.setDicGenMethod(2)
# generate dictionary
afdcal.genDic(1/50, 1)
# generate evaluator
afdcal.genEva()
# Initilize decomposition
afdcal.init_decomp()
# Decomposition 10 levels
for level in range(10):
    afdcal.nextDecomp()
# Get predefined an array
an_predefined = afdcal.an[0].copy()

#########################################################
# Decompose using the predefined an array
#########################################################
# init AFD Calculation
afdcal_new = AFDCal()
# Load input signal
afdcal_new.loadInputSignal('multi_bump_signals.mat')
ch_num = afdcal_new.s.shape[0]
# Set predefined an array
afdcal_new.set_an_array(an_predefined)
# Initilize decomposition
afdcal_new.init_decomp(searching_an = False)

print("Time of decomposition at level={:n}: {:n} s".format(0,afdcal_new.run_time[0]))
for i_ch in range(ch_num):
    fig, _ = afdcal_new.plot_decomp(0, i_ch = i_ch)
    savefig(fig, 'example_predefined_an/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
    fig, _ = afdcal_new.plot_basis_comp(0, i_ch = i_ch)
    savefig(fig, 'example_predefined_an/basis_comp_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
    fig, _ = afdcal_new.plot_remainder(0, i_ch = i_ch)
    savefig(fig, 'example_predefined_an/remainder_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
# Decomposition 4 levels
for level in range(4):
    afdcal_new.nextDecomp(searching_an = False)

    print("Total running time of the decomposition from level 1 to level {:n}: {:n} s".format(afdcal_new.level,sum(afdcal_new.run_time)))
    for i_ch in range(ch_num):
        fig, _ = afdcal_new.plot_decomp(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))
        fig, _ = afdcal_new.plot_basis_comp(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/basis_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))
        fig, _ = afdcal_new.plot_re_sig(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/reconstructed_signal_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))
        fig, _ = afdcal_new.plot_energy_rate(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/energy_convergence_rate_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))
        fig, _ = afdcal_new.plot_remainder(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/remainder_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))
        fig, _ = afdcal_new.plot_an(afdcal_new.level, i_ch = i_ch)
        savefig(fig, 'example_predefined_an/an_level_{:n}_ch_{:n}.jpg'.format(afdcal_new.level, i_ch))