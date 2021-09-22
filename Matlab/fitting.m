x = [1 2 3 4 5 6 7 8 9]
y = zeros(1,length(x));

for i = 1:length(x)
    y(i) = log10(i);
end 

f=fitlm (x,y)
plot(f)
hold