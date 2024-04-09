import numpy as np

from AFDCal import AFDCal
from AFDCal._io import savefig

# init AFD Calculation
afdcal = AFDCal()
# Load input signal
afdcal.loadInputSignal('multi_bump_signals.mat')
ch_num = afdcal.s.shape[0]
# set decomposition method: Single Channel Conventional AFD
afdcal.setDecompMethod(3)
# set dictionary generation method: square
afdcal.setDicGenMethod(1)
# generate dictionary
afdcal.genDic(1/50, 1)

print("Time of generating the searching dictionary: {:n} s".format(afdcal.time_genDic))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_dict(i_ch = i_ch)
    savefig(fig, 'example_res_multichannel_conv_AFD_square/searching_dictionary_ch_{:n}.jpg'.format(i_ch))
# generate evaluator
afdcal.genEva()

print("Time of generating evaluators: {:n} s".format(afdcal.time_genEva))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_base_random(i_ch = i_ch)
    savefig(fig, 'example_res_multichannel_conv_AFD_square/evaluator_ch_{:n}.jpg'.format(i_ch))
# Initilize decomposition
afdcal.init_decomp()

print("Time of decomposition at level={:n}: {:n} s".format(0,afdcal.run_time[0]))
for i_ch in range(ch_num):
    fig, _ = afdcal.plot_decomp(0, i_ch = i_ch)
    savefig(fig, 'example_res_multichannel_conv_AFD_square/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
    fig, _ = afdcal.plot_basis_comp(0, i_ch = i_ch)
    savefig(fig, 'example_res_multichannel_conv_AFD_square/basis_comp_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
    fig, _ = afdcal.plot_remainder(0, i_ch = i_ch)
    savefig(fig, 'example_res_multichannel_conv_AFD_square/remainder_level_{:n}_ch_{:n}.jpg'.format(0, i_ch))
# Decomposition 10 levels
for level in range(4):
    afdcal.nextDecomp()    

    print("Total running time of the decomposition from level 1 to level {:n}: {:n} s".format(afdcal.level,sum(afdcal.run_time)))
    for i_ch in range(ch_num):
        fig, _ = afdcal.plot_decomp(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/decomp_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_basis_comp(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/basis_comp_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_re_sig(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/reconstructed_signal_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_energy_rate(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/energy_convergence_rate_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_searchRes(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/searching_result_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_remainder(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/remainder_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))
        fig, _ = afdcal.plot_an(afdcal.level, i_ch = i_ch)
        savefig(fig, 'example_res_multichannel_conv_AFD_square/an_level_{:n}_ch_{:n}.jpg'.format(afdcal.level, i_ch))