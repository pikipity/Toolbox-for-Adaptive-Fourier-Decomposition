import numpy as np

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
afdcal.genDic(0.1, 0.9)

print("Time of generating the searching dictionary: {:n} s".format(afdcal.time_genDic))
fig, _ = afdcal.plot_dict()
fig.savefig('example_res/searching_dictionary.jpg', 
            bbox_inches='tight', dpi=300)
# generate evaluator
afdcal.genEva()

print("Time of generating evaluators: {:n} s".format(afdcal.time_genEva))
row_dic, col_dic = afdcal.dic_an.shape
fig, _ = afdcal.plot_base(np.random.randint(0,row_dic),np.random.randint(0,col_dic))
fig.savefig('example_res/evaluator.jpg', 
            bbox_inches='tight', dpi=300)
# Initilize decomposition
afdcal.init_decomp()

print("Time of decomposition at level={:n}: {:n} s".format(0,afdcal.run_time[0]))
fig, _ = afdcal.plot_decomp(0)
fig.savefig('example_res/decomp_comp_level_{:n}.jpg'.format(0), 
            bbox_inches='tight', dpi=300)
fig, _ = afdcal.plot_basis_comp(0)
fig.savefig('example_res/basis_comp_level_{:n}.jpg'.format(0), 
            bbox_inches='tight', dpi=300)           