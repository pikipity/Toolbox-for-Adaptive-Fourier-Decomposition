import numpy as np
import matplotlib.pyplot as plt

from AFDCal import AFDCal

# init AFD Calculation
afdcal = AFDCal(10)
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
fig.savefig('example_res_conventional_afd/searching_dictionary.jpg', 
            bbox_inches='tight', dpi=300)
plt.close(fig)
# generate evaluator
afdcal.genEva()

print("Time of generating evaluators: {:n} s".format(afdcal.time_genEva))
row_dic, col_dic = afdcal.dic_an.shape
fig, _ = afdcal.plot_base(np.random.randint(0,row_dic),np.random.randint(0,col_dic))
fig.savefig('example_res_conventional_afd/evaluator.jpg', 
            bbox_inches='tight', dpi=300)
plt.close(fig)
# Initilize decomposition
afdcal.init_decomp()

print("Time of decomposition at level={:n}: {:n} s".format(0,afdcal.run_time[0]))
fig, _ = afdcal.plot_decomp(0)
fig.savefig('example_res_conventional_afd/decomp_comp_level_{:n}.jpg'.format(0), 
            bbox_inches='tight', dpi=300)
plt.close(fig)
fig, _ = afdcal.plot_basis_comp(0)
fig.savefig('example_res_conventional_afd/basis_comp_level_{:n}.jpg'.format(0), 
            bbox_inches='tight', dpi=300)      
plt.close(fig)
# Decomposition 10 levels
for level in range(10):
    afdcal.nextDecomp()    

    print("Total running time of the decomposition from level 1 to level {:n}: {:n} s".format(afdcal.level,sum(afdcal.run_time)))
    fig, _ = afdcal.plot_decomp(afdcal.level)
    fig.savefig('example_res_conventional_afd/decomp_comp_level_{:n}.jpg'.format(afdcal.level), 
                bbox_inches='tight', dpi=300)
    plt.close(fig)
    fig, _ = afdcal.plot_basis_comp(afdcal.level)
    fig.savefig('example_res_conventional_afd/basis_comp_level_{:n}.jpg'.format(afdcal.level), 
                bbox_inches='tight', dpi=300)     
    plt.close(fig)
    fig, _ = afdcal.plot_re_sig(afdcal.level)
    fig.savefig('example_res_conventional_afd/reconstructed_signal_level_{:n}.jpg'.format(afdcal.level), 
                bbox_inches='tight', dpi=300)     
    plt.close(fig)
    fig, _ = afdcal.plot_energy_rate(afdcal.level)
    fig.savefig('example_res_conventional_afd/energy_convergence_rate_level_{:n}.jpg'.format(afdcal.level), 
                bbox_inches='tight', dpi=300)     
    plt.close(fig)
    fig, _ = afdcal.plot_searchRes(afdcal.level)
    fig.savefig('example_res_conventional_afd/searching_result_level_{:n}.jpg'.format(afdcal.level), 
                bbox_inches='tight', dpi=300)     
    plt.close(fig)