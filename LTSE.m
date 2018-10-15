function [ltse,order] = LTSE(frames_FFT,n)
ltse = zeros(size(frames_FFT));
order = 5;
for k= 1:size(frames_FFT,2)
    for l= n+1:size(frames_FFT,1)-n
    
        selected_coef = frames_FFT(l-order:l+order,k);
        ltse(l,k) = max(selected_coef);
        
    end
end