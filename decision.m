function [HR0,HR1] = decision(frames_FFT,threshold_up,threshold_down,ltse,noise_est,order,n,file_number,audio,fs)


ltsd = zeros(1,size(frames_FFT,1));
label = zeros(1,size(frames_FFT,1));
l = 1;
hangover_counter = 0;
while l <= size(frames_FFT,1)
    
    %-----------------------------LTDS-------------------------
    s = 0;
    for k = 1:size(ltse,2)
        s = ((ltse(l,k)^2) / (noise_est(k)^2)) + s;
    end
    ltsd(l) = 10*log10((1/256)*s);
    
    %----------------------------Labeling----------------------
    if l > order
        if label(l-1) == 1
            if ltsd(l) < threshold_down 
                label(l) = 0;
            else
                label(l) = 1;
            end
        else
            if ltsd(l) > threshold_up
                label(l) = 1;
            else
                label(l) = 0;
            end
        end
%----------------------------hangover-----------------------------------

        hangover = 5;

        if label(l-1) == 1 && label(l) == 0
            if l <= size(label,2) - hangover && hangover_counter == 0
                label(l:l+hangover) = 1;
                label(l+hangover+1) = 0;
                hangover_counter = hangover;
            end
        else
            hangover_counter = hangover_counter - 1;
            if hangover_counter == -1
                hangover_counter = 0;
            end
        end
    end    
    
%----------------------------noise updating-----------------------
sum = 0;
if label(l) == 0
    if l>3 && l<size(frames_FFT,1)-3
        for i= -3:3
            sum = frames_FFT(l+i,:);
        end
        noise_est = (noise_est*n + sum)/(n+7);
        n= n+7;
    end
end

l = l + 1;
end



figure(file_number)
plot(1:size(frames_FFT,1), ltsd)
hold on
plot(1:size(frames_FFT,1),label(1:size(frames_FFT,1))*max(ltsd))
axis([0 400 0 90])
grid on
hold off


t=1:size(audio,1);
k=1:size(ltsd,2);
figure(file_number+1)
plot(t/fs,audio)
hold on
plot(k/100,label)


label_supervised = zeros(size(label));
label_supervised(15:97)= 1;
label_supervised(137:246)= 1;


%% HR0
N0 = 0;
N1 = 0;
N00 = 0;
N11 = 0;

for i = 1: size(label,2)
    if label_supervised(1,i) == 0
        N0 = N0+1;
        if label(1,i) == label_supervised(1,i)
            N00 = N00 +1;
        end
    elseif label_supervised(1,i) == 1
        N1 = N1+1;
        if label(1,i) == label_supervised(1,i)
            N11 = N11 +1;
        end
    end
end

HR0 = N00/N0;
HR1 = N11/N1;
end

