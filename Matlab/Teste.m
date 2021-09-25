d_RSSI = (1:1:100);
h_sender = 0.077;
h_receiver = 0.069;
c = 299792.458;
lambda = c/433.000000;
pl = 1;

pl_2_ray=zeros(1,length(d_RSSI))
dc=4*h_sender*h_receiver/lambda;

for i=1:length(d_RSSI)
    if (d_RSSI(i)<h_sender)
        pl_2_ray (i) = -log10((((4*pi)^2)*pl*((d_RSSI(i))^2 + (h_sender/1000)^2))/(3*3*lambda^2));
    elseif (d_RSSI(i)<=dc)
        pl_2_ray (i) = -log10((((4*pi)^2)*pl*((d_RSSI(i))^2))/(3*3*lambda^2));
    else
        pl_2_ray (i) = -log10(((d_RSSI(i))^4)*pl/(3*3*lambda^2*(h_sender/1000)^2*(h_receiver/1000)^2));
    end
end
    

plot(d_RSSI,pl_2_ray);
    
    
    
    