import numpy as np

from AFDCal import AFDCal
from AFDCal._io import savefig

# init AFD Calculation
afdcal = AFDCal()
# Load input signal
afdcal.loadInputSignal('multi_bump_signals.mat')
ch_num = afdcal.s.shape[0]
# set decomposition method: Single Channel POAFD
afdcal.setDecompMethod(5)
# set dictionary generation method: circle
afdcal.setDicGenMethod(2)
# generate dictionary
afdcal.genDic(1/20, 1)

print("Time of generating the searching dictionary: {:n} s".format(afdcal.time_genDic))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_dict(i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/searching_dictionary_ch_{:n}.jpg'.format(i_ch))
# generate evaluator
afdcal.genEva()

print("Time of generating evaluators: {:n} s".format(afdcal.time_genEva))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_base_random(i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/evaluator_ch_{:n}.jpg'.format(i_ch))
# Initilize decomposition
afdcal.init_decomp()

print("Total running time of the decomposition from level 0 to level {:n}: {:n} s".format(afdcal.level,sum(afdcal.run_time)))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_decomp(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_basis_comp(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/basis_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_re_sig(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/reconstructed_signal_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_energy_rate(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/energy_convergence_rate_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_searchRes(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/searching_result_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_remainder(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/remainder_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
    fig, _ = afdcal.plot_an(afdcal.level, i_ch = i_ch)
    savefig(fig, 'example_res_POAFD_circle/an_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
# Decomposition 10 levels
for level in range(4):
    afdcal.nextDecomp()    

    print("Total running time of the decomposition from level 0 to level {:n}: {:n} s".format(afdcal.level,sum(afdcal.run_time)))
    for i_ch in range(ch_num):
        fig, _ = afdcal.plot_decomp(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_basis_comp(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/basis_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_re_sig(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/reconstructed_signal_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_energy_rate(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/energy_convergence_rate_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_searchRes(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/searching_result_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_remainder(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/remainder_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_an(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_POAFD_circle/an_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))