import numpy as np

from AFDCal import AFDCal
from AFDCal._io import savefig

# init AFD Calculation
afdcal = AFDCal()
# Load input signal
afdcal.loadInputSignal('bump_signal.mat')
# set decomposition method: Single Channel Conventional AFD
afdcal.setDecompMethod(1)
# set dictionary generation method: circle
afdcal.setDicGenMethod(2)
# generate dictionary
afdcal.genDic(1/50, 1)

print("Time of generating the searching dictionary: {:n} s".format(afdcal.time_genDic))
fig, _ = afdcal.plot_dict()
savefig(fig, 'example_res_conv_AFD_circle/searching_dictionary.jpg')
# generate evaluator
afdcal.genEva()

print("Time of generating evaluators: {:n} s".format(afdcal.time_genEva))
fig, _ = afdcal.plot_base_random()
savefig(fig, 'example_res_conv_AFD_circle/evaluator.jpg')
# Initilize decomposition
afdcal.init_decomp()

print("Time of decomposition at level={:n}: {:n} s".format(0,afdcal.run_time[0]))
fig, _ = afdcal.plot_decomp(0)
savefig(fig, 'example_res_conv_AFD_circle/decomp_comp_level_{:n}.jpg'.format(0))
fig, _ = afdcal.plot_basis_comp(0)
savefig(fig, 'example_res_conv_AFD_circle/basis_comp_level_{:n}.jpg'.format(0))
# Decomposition 10 levels
for level in range(10):
    afdcal.nextDecomp()    

    print("Total running time of the decomposition from level 1 to level {:n}: {:n} s".format(afdcal.level,sum(afdcal.run_time)))
    fig, _ = afdcal.plot_decomp(afdcal.level)
    savefig(fig, 'example_res_conv_AFD_circle/decomp_comp_level_{:n}.jpg'.format(afdcal.level))
    fig, _ = afdcal.plot_basis_comp(afdcal.level)
    savefig(fig, 'example_res_conv_AFD_circle/basis_comp_level_{:n}.jpg'.format(afdcal.level))
    fig, _ = afdcal.plot_re_sig(afdcal.level)
    savefig(fig, 'example_res_conv_AFD_circle/reconstructed_signal_level_{:n}.jpg'.format(afdcal.level))
    fig, _ = afdcal.plot_energy_rate(afdcal.level)
    savefig(fig, 'example_res_conv_AFD_circle/energy_convergence_rate_level_{:n}.jpg'.format(afdcal.level))
    fig, _ = afdcal.plot_searchRes(afdcal.level)
    savefig(fig, 'example_res_conv_AFD_circle/searching_result_level_{:n}.jpg'.format(afdcal.level))