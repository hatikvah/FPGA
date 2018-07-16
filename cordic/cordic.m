clear all;
clc;

N = 31;
tantable=2.^(-1.*(0:N-1));
atantable = atan(tantable);
costable = 1./sqrt(1+tantable.^2);
ktable  = ones(1,N);
ktable(1)=costable(1);
for i = 2:N
    ktable(i) = costable(i)*ktable(i-1);
end
ktable = ktable;
%===========================
fixatan = fi(atantable./pi,1,32,31)
a = sqrt(3)/4;
b = 1/4;
x = fi(a,1,32,31);
y = fi(b,1,32,31);
res = atan(b/a)*180/pi;
xx = fi(0,1,32,31);
yy = fi(0,1,32,31);
ang = fi(0,1,32,31);

for k = 1:N
    
    if(y>0)
        dir = 0;
        xx = fi(x + bitshift(y,1-k),1,32,31);
        yy = fi(y - bitshift(x,1-k),1,32,31);
        x = fi(xx,1,32,31);
        y = fi(yy,1,32,31);
        ang = fi(ang + fixatan(k),1,32,31);
    else
        dir = 1;
        xx = fi(x - bitshift(y,1-k),1,32,31);
        yy = fi(y + bitshift(x,1-k),1,32,31);
        x = fi(xx,1,32,31);
        y = fi(yy,1,32,31);
        ang = fi(ang - fixatan(k),1,32,31);
    end
    s_x = hex(x);
    s_y = hex(y);
    s_a = hex(ang);
end
ang = ang*180

hex(fixatan);
