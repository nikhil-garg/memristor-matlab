
function [] = run_experiment(model, win, iv, num_of_cycles, amp, freq, w_init, D, V_t, P_coeff, J, Ron, Roff, uV, a_on, a_off, c_on, c_off, alpha_on, alpha_off, k_on, k_off, i_on, i_off, x_on, x_off, x_c, b, beta, a, c, n, q ,g, alpha)



%% Linear Ion Drift model 

if (model==0)  

tspan=[0 num_of_cycles/freq];                       %%time length of the simulation
points=2e5;                              %%number of sampling points
W0=w_init*D;                            %define the initial value of W
tspan_vector = linspace(tspan(1),tspan(2),points);         % Create vector of initial values
I = amp*sin(freq*2*pi*tspan_vector);                   %%can also use square wave generated by : (square(tspan_vector));
W=zeros(size((tspan_vector)));
W_dot=zeros(size((tspan_vector)));
delta_t=tspan_vector(2)-tspan_vector(1);                        %%define the step size

W(1)=W0;                                                 %% initiliaze the first W vetor elemnt to W0 - the initial condition
for i=2:length(tspan_vector)
    % case this is an ideal window
    if (((win==0) || (win==4)) && ((abs (I(i))) >= (V_t/ (Ron*W(i-1)/D+Roff*(1-W(i-1)/D))))) 
        W_dot(i)=I(i)*(Ron*uV/D);
        W(i)=W(i-1)+W_dot(i)*delta_t;
    elseif ((win==0) && ((abs(I(i)))  < (V_t/ (Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W(i)=W(i-1);
        W_dot(i)=0;
        
    end
    
    % case this is Jogelkar window
    if ((win==1) && ((abs(I(i))) >= (V_t/(Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W_dot(i)=I(i)*(Ron*uV/D);
        W(i)=W(i-1)+W_dot(i)*delta_t*(1-(2*W(i-1)/D-1)^(2*P_coeff));%%+1e-18*sign(I(i));
    elseif ((win==1) && ((abs (I(i)) ) < (V_t/ (Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W(i)=W(i-1);
        W_dot(i)=0;

    end
    
        % case this is Biolek window
    if ((win==2) && ((abs(I(i))) >= (V_t/(Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W_dot(i)=I(i)*(Ron*uV/D);
        W(i)=W(i-1)+W_dot(i)*delta_t*(1-(W(i-1)/D-heaviside(-I(i)))^(2*P_coeff));
    elseif ((win==2) && ((abs(I(i))) < (V_t/(Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W(i)=W(i-1);
        W_dot(i)=0;
    end
 
        % case this is Prodromakis window
    if ((win==3) && ((abs(I(i))) >= (V_t/(Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W_dot(i)=I(i)*(Ron*uV/D);
        W(i)=W(i-1)+W_dot(i)*delta_t*(J*(1-((W(i-1)/D-0.5)^2+0.75)^P_coeff));
    elseif ((win==3) && ((abs(I(i))) < (V_t/(Ron*W(i-1)/D+Roff*(1-W(i-1)/D)))))
        W(i)=W(i-1);
        W_dot(i)=0;
    end
    
  % correct the w vector according to bounds [0 D]
    if W(i) < 0
        W(i) = 0;
        W_dot(i)=0;
    elseif W(i) > D
        W(i) = D;
        W_dot(i)=0;
    end
end

R=Ron*W/D+Roff*(1-W/D); %%this parameter might be useful for debug
V= R.*I; 
figure(1);
plot(V(20e3:end),I(20e3:end));
title('I-V curve');
xlabel('V[volt]');
ylabel('I[amp]');

figure(2);
plot(tspan_vector,W/D,'r');
title('W/D as func of time');
xlabel('time[sec]');
legend('W/D');


end

%%  Simmons Tunnel Barrier model
if (model==1)

points=2e5;
tspan=[0 num_of_cycles/freq];
t = linspace(tspan(1),tspan(2),points);
curr = amp*sin(freq*2*pi*t);
X=zeros(1,points);
X_dot=zeros(1,points);
delta_t=t(2)-t(1);

X(1)=w_init*D;
      
for i=2:(length(t))
          if curr(i)> 0
               X_dot(i)=c_off*sinh(curr(i)/i_off)*exp(-exp((X(i-1)-a_off)/x_c-abs(curr(i))/b)-X(i-1)/X_c);
          else
              X_dot(i)=c_on*sinh(curr(i)/i_on)*exp(-exp(-(X(i-1)-a_on)/X_c-abs(curr(i))/b)-X(i-1)/X_c);
          end
          
         X(i)=X(i-1)+delta_t*X_dot(i);
         
    if (X(i) < 0)
        X(i) = 0;
        X_dot(i)=0;
    elseif (X(i) > D)
        X(i) = D;
        X_dot(i)=0;
    end
end

R=Roff.*X./D+Ron.*(1-X./D);
V=R.*curr;

figure(1);
plot(V(20e3:end),curr(20e3:end));
title('I-V curve');
xlabel('V[volt]');
ylabel('I[amp]');

figure(2);
plot(t,X/D,'r');
title('X/D  as func of time');
xlabel('time[sec]');
legend('X/D');

end

%%  Team model 

if (model==2)
points=2e5;
tspan=[0 num_of_cycles/freq];
t = linspace(tspan(1),tspan(2),points);
curr = amp*sin(freq*2*pi*t);
X=zeros(1,points);
X_dot=zeros(1,points);
delta_t=t(2)-t(1);

X(1)=w_init*D;
     
for i=2:(length(t))
    % case this is an ideal window
    if (win == 0) 
          
          if (curr(i) > 0) && (curr(i) > i_off)
               X_dot(i)=k_off*(curr(i)/i_off-1)^alpha_off;
               X(i)=X(i-1)+delta_t*X_dot(i);
          elseif (curr(i) <= 0) && (curr(i) < i_on)
               X_dot(i)=k_on*(curr(i)/i_on-1)^alpha_on;
               X(i)=X(i-1)+delta_t*X_dot(i);
          else
               X(i)=X(i-1);
               X_dot(i)=0;
          end
    end
    
    % case this is Jogelkar window
    if (win == 1) 
          if (curr(i) > 0) && (curr(i) > i_off)
               X_dot(i)=k_off*(curr(i)/i_off-1)^alpha_off;
               X(i)=X(i-1)+delta_t*X_dot(i).*(1-(2*X(i-1)/D-1)^(2*P_coeff));
          elseif (curr(i) <= 0) && (curr(i) < i_on)
               X_dot(i)=k_on*(curr(i)/i_on-1)^alpha_on;
               X(i)=X(i-1)+delta_t*X_dot(i).*(1-(2*X(i-1)/D-1)^(2*P_coeff));
          else
               X(i)=X(i-1);
               X_dot(i)=0;
          end
    end
    
    % case this is Biolek window
    if (win == 2) 
          if (curr(i) > 0) && (curr(i) > i_off)
               X_dot(i)=k_off*(curr(i)/i_off-1)^alpha_off;
               X(i)=X(i-1)+delta_t*X_dot(i).*(1-(1-X(i-1)/D-heaviside(curr(i)))^(2*P_coeff));
          elseif (curr(i) <= 0) && (curr(i) < i_on)
               X_dot(i)=k_on*(curr(i)/i_on-1)^alpha_on;
               X(i)=X(i-1)+delta_t*X_dot(i).*(1-(1-X(i-1)/D-heaviside(curr(i)))^(2*P_coeff));
          else
               X(i)=X(i-1);
               X_dot(i)=0;
          end
    end
    
    % case this is Prodromakis window
    if (win == 3)
          if (curr(i) > 0) && (curr(i) > i_off)
               X_dot(i)=k_off*(curr(i)/i_off-1)^alpha_off;
               X(i)=X(i-1)+delta_t*X_dot(i).*(J*(1-((X(i-1)/D-0.5)^2+0.75)^P_coeff));
          elseif (curr(i) <= 0) && (curr(i) < i_on)
               X_dot(i)=k_on*(curr(i)/i_on-1)^alpha_on;
               X(i)=X(i-1)+delta_t*X_dot(i).*(J*(1-((X(i-1)/D-0.5)^2+0.75)^P_coeff));
          else
               X(i)=X(i-1);
               X_dot(i)=0;
          end
    end
    
    % case this is Kvatinsky window
    if (win == 4)
          if (curr(i) > 0) && (curr(i) > i_off)
               X_dot(i)=k_off*(curr(i)/i_off-1)^alpha_off*exp(-exp((X(i-1)-a_off)/X_c));
               X(i)=X(i-1)+delta_t*X_dot(i);
          elseif (curr(i) <= 0) && (curr(i) < i_on)
               X_dot(i)=k_on*(curr(i)/i_on-1)^alpha_on*exp(-exp(-(X(i-1)-a_on)/X_c));
               X(i)=X(i-1)+delta_t*X_dot(i);
          else
               X(i)=X(i-1);
               X_dot(i)=0;
          end
    end
     
    if (X(i) < 0)
        X(i) = 0;
        X_dot(i)=0;
    elseif (X(i) > D)
        X(i) = D;
        X_dot(i)=0;
    end


end

    if (iv == 0) %case I-V relation is linear
       R=Roff.*X./D+Ron.*(1-X./D);
       V=R.*curr;
    else %case the I-V relation is nonlinear
       lambda = log(Roff/Ron);
       V=Ron*curr.*exp(lambda*(X-x_on)/(x_off-x_on));
    end
    
figure(1);    
plot(V(20e3:end),curr(20e3:end));
title('I-V curve');
xlabel('V[volt]');
ylabel('I[amp]');

figure(2);
plot(t,X/D);
title('X/D as func of time');
xlabel('time[sec]');
legend('X/D');

end

%%  Nonlinear Ion Drift model 
if (model==3)
points=40000;
tspan=[0 num_of_cycles/freq];
t = linspace(tspan(1),tspan(2),points);
delta_t = t(2) - t(1);
V = amp*sin(freq*2*pi*t);
W=zeros(size((t)));
W_dot=zeros(size((t)));
curr=zeros(size((t)));
W(1) = w_init;

for i=2:points
    % case this is an ideal window
    if ((win==0) || (win==4))
        W_dot(i)=a*V(i)^q;
        W(i)=W(i-1)+W_dot(i)*delta_t;  
    end
    
    % case this is Jogelkar window
    if (win==1)
        W_dot(i)=a*V(i)^q;
        W(i)=W(i-1)+W_dot(i)*delta_t*(1-(2*W(i-1)-1)^(2*P_coeff));
    end
    
     % case this is Biolek window
    if (win==2)
        W_dot(i)=a*V(i)^q;
        W(i)=W(i-1)+W_dot(i)*delta_t*(1-(W(i-1)-heaviside(-V(i-1)))^(2*P_coeff));
   end
 
    % case this is Prodromakis window
    if (win==3)
        W_dot(i)=a*V(i)^q;
        W(i)=W(i-1)+W_dot(i)*delta_t*(J*(1-((W(i-1)-0.5)^2+0.75)^P_coeff));
    end
    
    % correct the w vector according to bounds [0 D]
    if W(i) < 0
        W(i) = 0;
        W_dot(i)=0;
    elseif W(i) > 1
        W(i) = 1;
        W_dot(i)=0;
    end
    
  curr(i)=W(i)^n*beta*sinh(alpha*V(i))+c*(exp(g*V(i))-1);
    
    
end
figure(1);
plot(V(20e3:end),curr(20e3:end));
title('I-V curve');
xlabel('V[volt]');
ylabel('I[amp]');

figure(2);
plot(t,W,'r');
title('W/D');
xlabel('time[sec]');
legend('W/D');

end
end