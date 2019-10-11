%Model name: model of Memristor based on Theoretical formulas
%           this model was written by Dmitry Fliter and Keren Talisveyberg 
%           Technion Israel institute of technology EE faculty December 2011


model = 0;   % define the model 0 - Linear Ion Drift ; 1 - Simmons Tunnel Barrier; 2 - Team model ; 3 - Nonlinear Ion Drift model
win   = 2;   % define the window type :  0 - No window; 1 - Jogelkar window ; 2 - Biolek window ; 3 - Prodromakis window ; 4- Kvatinsky window (Team model only) 
iv    = 0;   % IV_relation=0 means linear V=IR. IV_relation=1 means nonlinear V=I*exp{..}  

%Genaral parameters
num_of_cycles = 10e3;
amp = 0.75;
freq = 500;
w_init = 0.1; % the initial state condition [0:1] 
D = 3e-09;
V_t = 0.001;
P_coeff = 2;
J = 1;
Roff = 2e9;
Ron = 100;

%Linear Ion Drift parameters 
uV=1e-15;                                %%dopants mobility


%Simmons Tunnel Bariier % Team parameters
a_on = 2e-09;
a_off = 1.2e-09;
c_on = 40e-06;
c_off = 3.5e-06;
alpha_on = 3;
alpha_off = 3;
k_on = -8e-13;
k_off = 8e-13;
i_on = 8.9e-06;
i_off = 115e-06;
x_on = 3e-09;
x_off = 0;
x_c = 107e-12;
b = 500e-06;

%Nonlinear Ion Drift parametrs
beta = 9;
a = 4;
c = 0.01;
n = 14;
q = 13;
g = 4;
alpha = 7;
run_experiment(model, win, iv, num_of_cycles, amp, freq, w_init, D, V_t, P_coeff, J, Ron, Roff, uV, a_on, a_off, c_on, c_off, alpha_on, alpha_off, k_on, k_off, i_on, i_off, x_on, x_off, x_c, b, beta, a, c, n, q ,g, alpha);