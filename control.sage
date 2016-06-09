class ControlSystem:
    def __init__(self,E,U,T,symbolic=True):
        self.cnt = 0
        self.E=E
        self.U=U
        self.T=T
        self.A=None
        self.B=None
        self.C=None
        self.OC=None
        self.prepare(symbolic)

    def edge_label(self):
        name = "e{}".format(self.cnt)
        self.cnt+=1
        return SR.symbol(name)
    
    def prepare(self,symbolic=True):
        E,U,T=self.E,self.U,self.T
        ts = lambda : self.edge_label() if symbolic else 1
        S0 = SR(0)

        n=max(E.keys()+sum(E.values(),[]))+1
        Vs= []
        for k in range(n):
            tmp = [ts() if k in E.keys() and j in E[k] else 0 for j in range(n)]
            Vs += [vector(tmp)]

        Us= []
        for k in U:
            tmp = [ts() if j in k else 0 for j in range(n)]
            Us += [vector(tmp)]
        Ts = []
        for k in (T):
            tmp = [1 if k==j else 0 for j in range(n)]
            Ts += [vector(tmp)]
        A=matrix(Vs).transpose()
        B=matrix(Us).transpose()
        C=matrix(Ts)

        Ms = [C*A^k*B for k in range(n)]
        OCs = []
        for M in Ms:
            for c in M.columns():
                OCs += [c]
        OC=matrix(OCs).transpose()
        self.A=A
        self.B=B
        self.C=C
        self.OC=OC


#The n vertices are labelled from 0,1,2, ... , n-1
#E={
#    0:[1,2],
#    2:[3],
#}
#
#U=[
#    [0],
#]
#
#T=[1,3]

