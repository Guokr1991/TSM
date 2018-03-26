%Frequency Dependent Time Scale Modification Phase Vocoder
%This example uses a GUI to allow for easy end user setting of TSM ratios
%10 regions set with region widths as powers of 2.

close all
clear all
clc

pathOutput = 'AudioOut/';
%Call the GUI
gui_return = FDTSM_10_Band_GUI();
%Break open the return values from the GUI
region.TSM = gui_return.TSM_ratios;
audio_file = gui_return.filename;
audio_path = gui_return.path;

%Load audio file
[input, FS] = audioread([audio_path audio_file]);

%Sum to mono
num_chan = size(input,2);
if (num_chan == 2)
    input = sum(input,2);
    num_chan = size(input,2);
end

%Set window length
N = 2048;
%Calculate the region parameters
region.num_regions = length(region.TSM);
region.upper = 2.^(1:region.num_regions);

%Frequency Dependent Time Scale Modification
y = FDTSM( input, N, region );

%Create the output name
output_filename = [audio_file(1:end-4) '_' sprintf('%.2f_',region.TSM) 'FDTSM.wav'];
%Save audio file
audiowrite(['AudioOut/' output_filename], y, FS);

