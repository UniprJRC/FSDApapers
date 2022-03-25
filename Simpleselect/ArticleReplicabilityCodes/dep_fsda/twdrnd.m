function X=twdrnd(n,al,th,de)
X=zeros(n,1);

if al<0
    c=-(de*th^al)/al;
    for i=1:n
        N=poissrnd(c);
        if N>0
            X(i)=gamrnd(-N*al,1/th);
        end
    end
else
    m=max(1,round((de*th^al)/al));
    c=(de/(m*al))^(1/al);
    for i=1:n
        xi=0;
        for j=1:m
            stop=0;
            while stop==0
                ez=exprnd(1);
                uz=rand;
                Z=calculateZ(al,ez,uz);
                xi=c*Z;
                u=rand;
                if u<=exp(-th*xi); stop=1; end
            end
            X(i)=X(i)+xi;
        end
    end;
end
hist(X,round(n/20));
%hist(X,30)
end



function Z=calculateZ(al,e,u)
n1=sin((1-al)*pi*u);
d1=e*sin(al*pi*u);
c1=(n1/d1)^((1-al)/al);

n2=sin(al*pi*u);
d2=sin(pi*u);
c2=(n2/d2)^(1/al);

Z=c1*c2;

end