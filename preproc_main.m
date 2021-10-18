%% Appliction of the Generalized SRD on greenhouse gas emissions and economic indicators. Written by János Abonyi and Ádám Ipkovich, 10.10.2021
clear all
close all
clc

%% Reading the Data
climate_data = readtable('climate_data.xlsx');

%% Total as golden standard
num = [table2array(climate_data(:, 2:36))./climate_data.Pop *1000^2,
    table2array(climate_data(:, 38))./climate_data.Pop, 
    table2array(climate_data(:, 39:end))]; % Transformation to Emissions/capita & removal of population
u = [num(:, 1:26), num(:, 28:end)]; % Removal of the Golden
[N,n] = size(u);
golden = climate_data.TOTeAllGHG./climate_data.Pop*1000^2; % Golden as the total emissions
names= [string(climate_data.Properties.VariableNames(2:36)), string(climate_data.Properties.VariableNames(38:end))];
names(27) = []; % Align the variable names names to the remaining indicators 

figure(1)
[srdi, si] = plot_srd(u, golden, names) % Draw the randomization test

% Ranking of 147 nations based on their tons/capita
natrank = []
nat = tiedrank(golden)
[natsrdi, nnatsrdi] = sort(nat);
natval = golden(nnatsrdi); % numerical data in order
natrank = [natrank, climate_data.CountryName(nnatsrdi(1:end))]; % Names of the nations in order


%% Percentile
% Remove world data
num = [num(1:144, :); num(146:end, :)] 
nationnames = [climate_data.CountryName(1:144); climate_data.CountryName(146:end)]

%Determine percentiles
[N,n] = size(num);
p = []
for i = 1:n
    [v_f,v_x, ia,ic] = a_ecdf(num(:, i)')
    p = [p, v_f(ic)']; 
end

% Removing population from variables
names= [string(climate_data.Properties.VariableNames(2:end))];
names(36)= [];
% Percentile based SRD - mean
figure(2)
[srdpmni, spmni] = plot_srd(p, mean(p, 2), names) 

natsud = mean(p, 2);
[natsudi, nnatsudi] = sort(natsud);
natval = [natval, p(nnatsudi)];
natrank = [natrank,nationnames(nnatsudi(1:end))];

% Percentile based SRD - max
figure(3)
[srdpmxi, spmxi] = plot_srd(p, max(p, 2), names)

natsud = max(p, 2);
[natsudi, nnatsudi] = sort(natsud);
natval = [natvalm, p(nnatsudi)];
natrank = [natrank,nationnames(nnatsudi(1:end))];
%% Derringer

% Draw the cumulative distributions and derringer desirability to subplots
u = []
figure(4)
subplot(2, 1, 1)
[val, ind] = sort(num(:, 27))
plot(val, p(ind, 27), '-')
xlim([0 30])
ylim([0 1])
ylabel("Percentile")
xlabel("Emission per capita [t/cap]")
set(gca,'FontSize',18)
subplot(2, 1, 2)
lwl = val(round(N*0.5), 1);
upl = val(round(N*0.8), 1);
u = derringer(val, upl,  lwl, 1);
plot(val, u, '-')
xlim([0 30])
ylim([0 1])
ylabel("Percentile")
xlabel("Emission per capita [t/cap]")
set(gca,'FontSize',18)

% %% Derringer desirability for all indicators

% Calulation of weights
refemission = sum(num(:, 1:35), 1, 'omitnan')./sum(num(:, 27), 1, 'omitnan');
refemission(12) = [];
w = [refemission, ones(1, 4)];

% Transformation of the indicators with derringer desirability
u = [];
A = 0.8; % 80% mark
B = 0.5; % 50% mark
s = 1;

for i=1:11
[sortedperCap, sortindex] = sort(num(:, i));
l = derringer(num(:, i), sortedperCap(round(N*A), 1), sortedperCap(round(N*B), 1), s);
u =[u l]; 
end
% An indicator is left out as much of its values are 0.
for i=13:35
[sortedperCap, sortindex] = sort(num(:, i));
l = derringer(num(:, i), sortedperCap(round(N*A), 1), sortedperCap(round(N*B), 1), s);
u =[u l]; 
end

% Derringer for economic indicators
[sortedperCap, sortindex] = sort(1-normalize(num(:, 36), 'range')); % GDP is reversed
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u =[u l(sortindex)]; 
[sortedperCap, sortindex] = sort(num(:, 37)); % Rural pop
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u =[u l(sortindex)]; 
[sortedperCap, sortindex] = sort(num(:, 38)); % GDP growth
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u =[u l(sortindex)]; 
[sortedperCap, sortindex] = sort(num(:, 39)); % Urban growth
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u =[u l(sortindex)]; 


names = [string(climate_data.Properties.VariableNames(2:12)), string(climate_data.Properties.VariableNames(14:36)), string(climate_data.Properties.VariableNames(38:end))];

g = sum(u.*w, 2, 'omitnan'); % Generate Gold Standard, additive aggregation
figure(5)
[srdderi, sderi] = plot_srd(u, g, names) % Plot Derringer based SRD 

%% Ranking of nations based on Derringer

[sortedperCap, sortindex] = sort(1-normalize(num(:, 35), 'range'));
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u(:, end-3) = l(sortindex); 
[sortedperCap, sortindex] = sort(num(:, 36));
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u(:, end-2) = l(sortindex); 
[sortedperCap, sortindex] = sort(1-normalize(num(:, 37), 'range'));
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u(:, end-1) = l(sortindex); 
[sortedperCap, sortindex] = sort(1-normalize(num(:, 38), 'range'));
l = derringer(sortedperCap, sortedperCap(round(N*A), 1),  sortedperCap(round(N*B), 1), s);
u(:, end) = l(sortindex); 

gmax = sum(u.*w, 2, 'omitnan');
[sSUD, sSUDi] = sort(gmax);
natval = [natval, sSUD];
natrank = [natrank, nationnames(sSUDi)];