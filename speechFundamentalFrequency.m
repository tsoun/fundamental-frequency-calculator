function [] = speechFundamentalFrequency()
    clc;
    clear;
    [rawSpeech, Fs] = audioread("myvoice.wav");
    
    rawSpeech = rawSpeech(:,1);
    
    timeSamplingWindow = 20*10^(-3);
    
    sample = rawSpeech(round(length(rawSpeech)/2-timeSamplingWindow*Fs:round(length(rawSpeech)/2+timeSamplingWindow*Fs)));
    
    %plotTime(sample, Fs, "Male Speech Sample (Time Domain)");
    plotSample(sample, "Male Speech Sample (Samples)", 1);
    
    pitch = [];
    pitch = findPitch(sample, Fs, pitch, "Time-domain plot method:" + "\n");
    autocorrelationSample = xcorr(sample, sample);
    plotSample(autocorrelationSample, "Autocorrelation of Sample Waveform", 2);
    pitch = findPitch(autocorrelationSample, Fs, pitch, "\n" + "Autocorrelation algorithm method:" + "\n");
    
    annotation('textbox', [0.08 0.05 0.83 0.3], 'interpreter','latex','String', pitch)
end

function reply = findPitch(signal, Fs, reply, status)
    [pks, ~] = sortrows(findpeaks(signal, Fs), 1, 'descend');
    if status == "Time-domain plot method:" + "\n"
        time = sprintf(status + "Distance between two peaks is equal to " + num2str((find(signal == pks(1))) - (find(signal == pks(2)))) + " samples.\nTime between these two peaks is equal to " + num2str(((find(signal == pks(1))) - (find(signal == pks(2))))*10^3/Fs) + " m$s$.\n");
        status = "";
    else
        time = [];
    end
    cross = sprintf(status + "Fundamental frequency ($f_0$) is equal to " + num2str(Fs/((find(signal == pks(1))) - (find(signal == pks(2))))) + " $Hz$.\n");    
    reply = sprintf("%s%s%s", reply, time, cross);
end

function [] = plotSample (data, ntitle, n)
    figure(1)
    subplot(3,1,n);
    stem(data, 'color', [0 0 0] +0.1, 'Marker', '.');
    xlim([0, length(data)]);
    grid on;
    xlabel('Samples');
    ylabel('Amplitude');
    title(ntitle);
end

function [] = plotTime (data, Fs, ntitle, n)
    figure(1)
    subplot(3,1,n);
    t = linspace(0, length(data)/Fs, length(data));
    stem(t, data, 'color', [0 0 0] +0.1, 'Marker', '.');
    xlim([0, length(t)/Fs]);
    grid on;
    xlabel('Time [sec]');
    ylabel('Amplitude');
    title(ntitle);
end