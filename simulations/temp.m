
time = 2000;

for i=1:time
    
    [trajEn(:,i),errFlag] = simSETARMA(2,[-0.3 0.2]',2,2,1,...
        [0.3 -0.2; -0.5 0.1; 0.15 0.6],[0.6; -0.2; 0.4],1,150);
    
end

[trajT,errFlag] = simSETARMA(2,[-0.3 0.2]',2,2,1,...
        [0.3 -0.2; -0.5 0.1; 0.15 0.6],[0.6; -0.2; 0.4],1,time);
    
    