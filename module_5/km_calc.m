filename="CONF_EX_ENER_EX.dat";
hollow_ex1=importdata(filename);
filename="CONF_STATE_ENER_EX.dat";
hollow_ct1=importdata(filename);
filename="../correction/config_CONF/CONF_STATE_corr.dat";
corr_ct1=importdata(filename);
filename="../correction/config_CONF/CONF_EX_corr.dat";
corr_ex1=importdata(filename);
filename="../correction/egas_dif_STATE_CONF.dat";
corr_egas=importdata(filename);
correction=corr_egas-(corr_ex1-corr_ct1)/23.061;
filename="../coupling_CONF.dat";
coupling=importdata(filename);
coupling=coupling(SNUM);
hollow_gap=hollow_ex1-hollow_ct1;

h=histogram(hollow_gap/23.061+correction,...
    'Normalization','pdf','DisplayStyle','stairs');
aa=(h.BinEdges(1:length(h.BinEdges)-1)+h.BinEdges(2:length(h.BinEdges)))/2;
bb=h.Values;
f=fittype(strcat('a1/sqrt(2*pi*s1^2)*exp(-(x-m1)^2/(2*s1^2))+',...
    'a2/sqrt(2*pi*s2^2)*exp(-(x-m2)^2/(2*s2^2))+',...
    'a3/sqrt(2*pi*s3^2)*exp(-(x-m3)^2/(2*s3^2))'),...
    'coefficients',{'a1','a2','a3','m1','m2','m3','s1','s2','s3'});
gauss1=fittype(strcat('a1/sqrt(2*pi*s1^2)*exp(-(x-m1)^2/(2*s1^2))'),...
    'coefficients',{'a1','m1','s1'});
gauss2=fittype(strcat('a1/sqrt(2*pi*s1^2)*exp(-(x-m1)^2/(2*s1^2))+',...
    'a2/sqrt(2*pi*s2^2)*exp(-(x-m2)^2/(2*s2^2))'),...
    'coefficients',{'a1','a2','m1','m2','s1','s2'});

meangap=mean(hollow_gap*.0434+correction);
[mydist3,gof3,stuff3]=fit(aa',bb',f,'StartPoint',[.25,.5,.25,meangap+.3,...
    meangap,meangap-.3,.1,.1,.1],'Lower',[0,0,0,min(aa),min(aa),min(aa)...
    ,0.01,0.01,0.01],'Upper',[1,1,1,max(aa),max(aa),max(aa),.3,.3,.3]);
[mydist2,gof2,stuff2]=fit(aa',bb',gauss2,'StartPoint',[.5,.5,meangap+.3,...
    meangap-.3,.1,.1],'Lower',[0,0,min(aa),...
    min(aa),0.01,0.01],'Upper',[1,1,max(aa),max(aa),.3,.3]);
[mydist1,gof1,stuff1]=fit(aa',bb',gauss1,'StartPoint',[1,meangap,std(hollow_gap*.0434)],...
    'Lower',[0,min(aa),0.01],'Upper',[2,max(aa),.3]);
mydist=mydist3;
distconf=confint(mydist);
distcoeff=coeffvalues(mydist);
count=3;
if min(min(min([distconf(:,7:9) distconf(:,1:3)]))) < 0
    mydist=mydist2;
    distconf=confint(mydist);
    distcoeff=coeffvalues(mydist);
    count=2;
    if min(min(min([distconf(:,5:6) distconf(:,1:2)]))) < 0
        mydist=mydist1;
        distconf=confint(mydist);
        distcoeff=coeffvalues(mydist);
        count=1;
    end
end

sigs=chi2rnd(((distconf(2,count*2+1:count*3)-distconf(1,count*2+1:count*3))/1.96/2).^-2.*...
(distcoeff(count*2+1:count*3)).^2*2.*ones(10^5,count)).*((distconf(2,...
count*2+1:count*3)-distconf(1,count*2+1:count*3))/1.96/2).^2./...
(distcoeff(count*2+1:count*3))/2;
means=(randn(10^5,count).*(distconf(2,count+1:count*2)-...
    distconf(1,count+1:count*2))/1.96/2)+distcoeff(count+1:count*2);
weights=(randn(10^5,count).*(distconf(2,1:count)-...
    distconf(1,1:count))/1.96/2)+distcoeff(1:count);
er=sigs.^2/.0257/2;
de=-er-means;
ae=.0257*means.^2/2./sigs.^2;
km=normpdf(0,means,sigs)/(6.5821*10^-16)*coupling^2*2*pi;

%mean(hollow_gap/23.061+correction)*1000
%std((hollow_gap/23.061+correction)*1000)
%feval(mydist,0)/(6.5821*10^-16)*coupling^2*2*pi
tkm=sum((weights.*km)')';
quantile(tkm,.1587)
quantile(tkm,.5)
quantile(tkm,.8413)

set(gcf,'units','inches','position',[4 4 3.25 3.25]);
ax = gca;
ax.FontSize = 8;
ax.FontName = 'Arial';
ax.TickLength=[.015,.015];
set(gca,'XMinorTick','on','YMinorTick','on')
xlabel('U (eV)','FontSize',10,'FontName','Arial')
ylabel('Probability Density','FontSize',10,'FontName','Arial')
title('Config CONF EX\rightarrowSTATE U Distribution','FontSize',10,'FontName','Arial')
print(gcf,'-dbmp','CONF_STATE_plot.bmp','-r500');
