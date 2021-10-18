% Plot function for SRD - 1D ordering and randomization test by János
% Abonyi, 10.10.2021
function [srdi, si] = plot_srd(u, g, varnames)
R = tiedrank(u);
[N,n]=size(R);
%max srd
    if rem(N,2)==1
        k=(N-1)/2;
        m=2*k*(k+1);
    else
        k=N/2;
        m=2*k^2;
    end
%the best "virtiual" method  / ideal objective / ideal ranking  
nrk=tiedrank(g, 'omitnan'); 
names= varnames;
% Calculate the SRD
srd=sum(abs(R-repmat(nrk,1,n)),1, 'omitnan')/m*100;
[srdi,si]=sort(srd);
nsrdi=names(si); 
srdi;
% Simulation of the probabolity distribution 
nSim=1e4;
S=[];
io=[1:N];
for i=1:nSim
       S(i)=sum(abs(io-randperm(N)))/m*100;
end
%yyaxis left
yyaxis left
[prob,srdc]= histcounts(S,unique(S),'Normalization','cdf');
plot([srdc],[0 prob] * 100)
xlabel('SRD')
ylabel('P(SRD) [%]')
hold on 
% Calculate the probabilities of the orderings (based on cum prob)
psrdi = interp1([0 srdc],[ 0 0 prob], srdi);
psrdi = psrdi +1;
yyaxis right
axv=axis;
ylabel('SRD')
%axis([0 2*max(srdi) 0 1.5*max(psrdi)])
for j=1:n 
an=text(srdi(j),srdi(j),nsrdi(j),'fontsize',16);
set(an,'Rotation',45);
line([srdi(j) srdi(j) ],[0 srdi(j)], 'LineWidth', 2.5);
hold on 
end
set(gca,'FontSize',18)
srdmed = median(S);
xx1 =srdc(abs(prob-0.05) == min(abs(prob-0.05)))
xx19 = srdc(abs(prob-0.95) == min(abs(prob-0.95)))
line([srdmed srdmed],[0 100], 'Color','black','LineStyle','--')
line([xx1, xx1],[0 100], 'Color','black','LineStyle','-.')
line([xx19, xx19],[0 100], 'Color','black','LineStyle','-.')


end