P=[0.9826 0.9651 0.9474 0.9296 0.9119];
q=0.5;
delta=0.997;
n=length(P)+1;
A=zeros(n,n);

for a=1:n
    A(a,n)=1;
end
    
    
for k=1:(n-1)
    counter1=n-k;
    h=1/(q+(1-q)*(delta^(counter1-1)));
    if (counter1==1)
        h=1;
    end
    tempcount=counter1;
    for j=1:(counter1)
        counter2=tempcount;
        if (counter1-1==0)
            p1=P(counter1);
            p2=1;
        else 
            p1=P(counter1);
            p2=P(counter1-1);
        end
        
        price=(p1/p2)*h*(delta^(counter1-counter2));
        A(counter2,counter1)=price;
        tempcount=counter2-1;
    end
end

A

% B contains the annually compunded interest rate for each node
B=zeros(n-1,n-1);

for i=1:(n-1)
    for j=1:(n-1)
        if (A(i,j)==0)
            B(i,j)=0;
        else
            B(i,j)=(1/A(i,j))-1;
        end
    end
end

B

% Rounds off the interest rates in B to show better in lattice
% format
D=zeros(n-1,n-1);
for i=1:(n-1)
    for j=1:(n-1)
        D(i,j)=round(B(i,j)*10000)/100;
    end
end
D
%print_lattice(D);

% Calculates the price of a cap with K=1.9%
K=0.019;
C=zeros(n-1,n-1);
for i=1:(n-1)
    for j=1:(n-1)
        cap=B(i,j)-K;
        if (cap<=0)
            C(i,j)=0;
        else
            C(i,j)=cap;
        end
    end
end

C

% Calculates the price of a cap at time 0 by backwards recursion
for i=1:(n-1)
    C(i,(n-1))=C(i,(n-1))/(1+B(i,(n-1)));
end


for i=1:(n-2)
    c1=n-1-i;
    tmpc1=c1;
    for j=1:(c1)
        c2=tmpc1;
        C(c2,c1)=(C(c2,c1)/(1+B(c2,c1)))+(1/(1+B(c2,c1)))*...
                (q*C(c2,c1+1)+(1-q)*C(c2+1,c1+1));
        tmpc1=c2-1;    
    end
end
C

% The price of the cap at time 0 is 0.0034. Thus for a nominal 
% value of 10000$, the price is 10000*0.0034=34$ for the cap.



%Results from running the code

A =

    0.9826    0.9807    0.9787    0.9768    0.9751    1.0000
         0    0.9837    0.9817    0.9797    0.9780    1.0000
         0         0    0.9846    0.9827    0.9809    1.0000
         0         0         0    0.9856    0.9839    1.0000
         0         0         0         0    0.9869    1.0000
         0         0         0         0         0    1.0000


B =

    0.0177    0.0197    0.0218    0.0238    0.0256
         0    0.0166    0.0187    0.0207    0.0225
         0         0    0.0156    0.0176    0.0194
         0         0         0    0.0146    0.0164
         0         0         0         0    0.0133


D =

    1.7700    1.9700    2.1800    2.3800    2.5600
         0    1.6600    1.8700    2.0700    2.2500
         0         0    1.5600    1.7600    1.9400
         0         0         0    1.4600    1.6400
         0         0         0         0    1.3300


C =

         0    0.0007    0.0028    0.0048    0.0066
         0         0         0    0.0017    0.0035
         0         0         0         0    0.0004
         0         0         0         0         0
         0         0         0         0         0


C =

    0.0034    0.0060    0.0090    0.0095    0.0064
         0    0.0010    0.0018    0.0035    0.0034
         0         0    0.0001    0.0002    0.0004
         0         0         0         0         0
         0         0         0         0         0
