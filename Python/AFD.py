# -*- coding: utf-8 -*-
def e_a(a,t):
    """
    evaluator function
    """
    y=((1-absolute(a)**2)**0.5)/(1-conjugate(a)*(e**(1j*t)))
    return y
        
        
def weight(n,order):
    """
    weight function of the numerical integration
    """
    y=zeros((n,1),'complex')
    Newton=array([[41.0/840],[9.0/35],[9.0/280],[34.0/105],[9.0/280],[9.0/35],[41.0/840]])
    k=floor((n*1.0-1)/order)
    if k>0:
        for iter in arange(1,k+1):
            y[(iter*order-order):(iter*order+1)]=y[(iter*order-order):(iter*order+1)]+Newton
            
    y=y*order*1.0/(n-1)
    nleft=n-k*order-1;
    if nleft==1:
        Newton=array([[1.0/2],[1.0/2]])
    elif nleft==2:
        Newton=array([[1.0/6],[4.0/6],[1.0/6]])
    elif nleft==3:
        Newton=array([[1.0/8],[3.0/8],[3.0/8],[1.0/8]])
    elif nleft==4:
        Newton=array([[7.0/90],[16.0/45],[2.0/15],[16.0/45],[7.0/90]])
    elif nleft==5:
        Newton=array([[19.0/288],[25.0/96],[25.0/144],[25.0/144],[25.0/96],[19.0/288]])
        
    if nleft>0:
        y[(n-nleft-1):(n+1)]=y[(n-nleft-1):(n+1)]+Newton*nleft/(n-1)
        
    return y
    
    
def intg(f,g,W):
    if ndim(g)==1:
        g=array([g])
    y=f.dot(g.T*W)
    if ndim(y)!=1:
        y=y[0,0]
    return y
        

def conv_AFD(s,max_level=50,M=20,L=2000):
    """
    AFD based on the conventional exhaustive basis searching
    Inputs:
        s: 1*K pocessed discrete signal
        max_level: maximum decomposition level
        M: if it is a integer number, it is the maximum number of the magnitude
           values of a_n in the searching dictionary, and the dictionary of the
           magnitude values is unique distributed in [0,1).
           if it is an array, it is the dictionary of the magnitude values.
        L: if it is a integer number, it is the maximum number of the phase
           values of a_n in the searching dictionary, and the dictionary of the
           phase values is unique distributed in [0,2*pi).
    Outputs:
        state: -1-> Error, 1->No Error
        an: values of a_n for n=0,2,...,N
        coef: values of coef_n for n=0,2,...,N
    """
    if ndim(s)==1:
        s=array([s])
    # Convert the signal s to its discrete time format
    K=shape(s)[1]
    t=array([arange(0,2*pi,2*pi/K)])
    # Convert the signal s to its analytic representation
    if isreal(s).all():
        G=hilbert(s)
    else:
        G=s.copy()
            
    # Generate a_n dictionary
    if size(M)==1:
        abs_a=array([arange(0,1,1.0/M)])
    else:
        if ndim(M)==1:
            M=array([M])
            abs_a=M.copy()
        elif shape(M)[0]==1:
            abs_a=M.copy()
        elif shape(M)[1]==1:
            abs_a=M.T.copy()
        else:
            return -1,array([]),array([])

    if size(L)==1:
        phase_a=array([arange(0,2*pi,2*pi/L)])
    else:
        if ndim(L)==1:
            L=array([L])
            phase_a=L.copy()
        elif shape(L)[0]==1:
            phase_a=L.copy()
        elif shape(L)[1]==1:
            phase_a=L.T.copy()
        else:
            return -1,array([]),arry([])
             
    dic_an=zeros((size(abs_a),size(phase_a)),'complex')
    for m in arange(0,size(abs_a)):
        for l in arange(0,size(phase_a)):
            dic_an[m,l]=abs_a[0,m]*(e**(1j*phase_a[0,l]))            
         
    dic_an=dic_an.reshape(1,size(abs_a)*size(phase_a)).copy()
    # Generate evaluators
    Base=zeros((size(abs_a)*size(phase_a),K),'complex')
    for k in arange(0,shape(Base)[0]):
        Base[k,:]=e_a(dic_an[0,k],t)
        
    # Generate weight for the numerical integration
    Weight=weight(K,6)
    # Initialization
    an=zeros((1,max_level+1),'complex')
    coef=zeros((1,max_level+1),'complex')
    coef[0,0]=intg(G,ones((1,size(t))),Weight)
    for n in arange(1,size(an)):
        e_an=e_a(an[0,n-1],t)
        G=(G-coef[0,n-1]*e_an)*(1-conjugate(an[0,n-1])*(e**(1j*t)))/(e**(1j*t)-an[0,n-1])
        S1=conjugate(Base.dot(G.conj().T*Weight))
        I=nonzero(absolute(S1)==absolute(S1).max())[0][0]
        coef[0,n]=S1[I,0]
        an[0,n]=dic_an[0,I]
        
    return 1,an,coef,t
    

def inverse_AFD(an,coef,t,standard='level',standard_value=float("inf")):
    """
    Inverse AFD
    Inputs:
        1. a_n array for n=0,1,2,...,N
        2. coef: coefficient array for n=0,1,2,...,N
        3. t: time sample points of the discrete time signal
        4. standard: 
            (1) 'level': reconstruction based on the decomposition level from n=0 to n=min((size(an),standard_value))
            (2) 'energy': reconstruction based on the energy. The energy of the reconstructed signal is smaller or equal to standard_value
    Output:
        1. G_recovery: reconstructed signal
        2. n: reconstructed_level
    """
    if ndim(an)==1:
        an=array([an])
    if ndim(coef)==1:
        coef=array([coef])
    if ndim(t)==1:
        t=array([t])
    Weight=weight(size(t),6)
    tem_B=(sqrt(1-absolute(an[0,0])**2)/(1-conjugate(an[0,0])*e**(t*1j)))
    G_recovery=coef[0,0]*tem_B
    n=0;
    if standard.lower()=='level':
        current_value=0
        target_value=min((size(an)-1,standard_value))
    elif standard.lower()=='energy':
        current_value=intg(real(G_recovery),real(G_recovery),Weight)
        target_value=standard_value
    while n<size(an)-1 and current_value<target_value:
        n=n+1
        tem_B=(sqrt(1-absolute(an[0,n])**2)/(1-conj(an[0,n])*e**(t*1j)))*((e**(1j*t)-an[0,n-1])/(sqrt(1-absolute(an[0,n-1])**2)))*tem_B
        G_recovery=G_recovery+coef[0,n]*tem_B
        if standard.lower()=='level':
            current_value=n
        elif standard.lower()=='energy':
            current_value=intg(real(G_recovery),real(G_recovery),Weight)
    return G_recovery,n
    
    
def FFT_AFD(s,max_level=50,M=20):
    """
    AFD based on the FFT (phase searching length is equal to the signal length)
    Inputs:
        s: 1*K pocessed discrete signal
        max_level: maximum decomposition level
        M: if it is a integer number, it is the maximum number of the magnitude
           values of a_n in the searching dictionary, and the dictionary of the
           magnitude values is unique distributed in [0,1).
           if it is an array, it is the dictionary of the magnitude values.
    Outputs:
        state: -1-> Error, 1->No Error
        an: values of a_n for n=0,2,...,N
        coef: values of coef_n for n=0,2,...,N
    """
    if ndim(s)==1:
        s=array([s])
    # Convert the signal s to its discrete time format
    K=shape(s)[1]
    t=array([arange(0,2*pi,2*pi/K)])
    # Convert the signal s to its analytic representation
    if isreal(s).all():
        G=hilbert(s)
    else:
        G=s.copy()
            
    # Generate a_n dictionary
    if size(M)==1:
        abs_a=array([arange(0,1,1.0/M)])
    else:
        if ndim(M)==1:
            M=array([M])
            abs_a=M.copy()
        elif shape(M)[0]==1:
            abs_a=M.copy()
        elif shape(M)[1]==1:
            abs_a=M.T.copy()
        else:
            return -1,array([]),array([])
    temp=zeros((1,size(abs_a)),'complex')
    for k in arange(0,size(abs_a)):
        temp[0,k]=complex(abs_a[0,k])
    abs_a=temp.copy()
    del temp
    # Generate evaluators
    Base=zeros((size(abs_a),size(t)),'complex')
    for k in arange(0,shape(Base)[0]):
        Base[k,:]=fft(e_a(abs_a[0,k],t),size(t))
        
    # Generate weight for the numerical integration
    Weight=weight(K,6)
    # Initialization
    an=zeros((1,max_level+1),'complex')
    coef=zeros((1,max_level+1),'complex')
    coef[0,0]=intg(G,ones((1,size(t))),Weight)
    for n in arange(1,size(an)):
        e_an=e_a(an[0,n-1],t)
        G=(G-coef[0,n-1]*e_an)*(1-conjugate(an[0,n-1])*(e**(1j*t)))/(e**(1j*t)-an[0,n-1])
        S1=ifft(repmat(fft(G*Weight.conj().T,size(t)),shape(Base)[0],1)*Base,size(t),1)        
        max_loc=nonzero(absolute(S1)==absolute(S1).max())
        an[0,n]=abs_a[0,max_loc[0][0]]*e**(1j*t[0,max_loc[1][0]])
        coef[0,n]=conjugate(e_a(an[0,n],t).dot(G.conj().T*Weight))[0,0]
        
    return 1,an,coef,t    
    
    
if __name__ == "__main__":
    from numpy import *
    from numpy.matlib import repmat
    from numpy.fft import fft, ifft
    from scipy.signal import hilbert
    print("--------------------------------------------------------")
    t=array([arange(0,2*pi,2*pi/2000)])
    print("Test e_a")
    print(e_a(0.5+0.5j,t))
    print("Test weight")
    print(weight(2000,6))
    print("Test intg")
    print(intg(array([arange(0,12)]),array([arange(1,13)]),weight(12,6)))
    print("---------------------------------------------------------")
    from scipy.io import loadmat
    s=loadmat('.\\Example\\bump_signal.mat')
    s=s['G'].copy()
    print(hilbert(s))
    state,an,coef,t=conv_AFD(s,50,50,size(s))
    print('state:')
    print(state)
    print('an:')
    print(an)
    print('coef:')
    print(coef)
    s_re,n=inverse_AFD(an,coef,t)
    print('s_re:')
    print(s_re)
    print('n:')
    print(n)
    print("---------------------------------------------------------")
    from scipy.io import loadmat
    s=loadmat('.\\Example\\bump_signal.mat')
    s=s['G'].copy()
    print(hilbert(s))
    state_FFT,an_FFT,coef_FFT,t_FFT=FFT_AFD(s,50,50)
    print('state_FFT:')
    print(state_FFT)
    print('an_FFT:')
    print(an_FFT)
    print('coef_FFT:')
    print(coef_FFT)
    s_re_FFT,n_FFT=inverse_AFD(an_FFT,coef_FFT,t_FFT)
    print('s_re_FFT:')
    print(s_re_FFT)
    print('n_FFT:')
    print(n_FFT)
    print("---------------------------------------------------------")
    from matplotlib import pyplot
    pyplot.figure(1)
    pyplot.plot(real(an),imag(an),'rx',real(an_FFT),imag(an_FFT),'go')
    pyplot.xlabel('Real')
    pyplot.ylabel('Imag')
    pyplot.show()
    pyplot.figure(2)
    pyplot.plot(t,real(s),'ro-',t,real(s_re),'go-',t,real(s_re_FFT),'ko-')
    pyplot.xlabel('Phase')
    pyplot.show()