clc
clear
close all

dispnum = 1;

%%%%

load BW_data.mat


y = y1(1:150,:);


[~, sd, vd] = svd(y);

sd = sd.^2;
nd = 1;
chkd = sum(diag(sd));
rd = 0;
while rd < 0.95
    rd = sum(diag(sd(1:nd,1:nd)))/chkd;
    nd = nd+1;
end
nd = nd-1;
fprintf('\n\n%d\n\n',nd);

dr = y*vd(:,1:nd);

%%%%

[~, ~, vf] = svd(force(1:150,:));

fr = force(1:150,:)*vf(:,1:nd);

%%%%

for i = 1:nd
    fprintf('%d\n',i)
    mdl = fitrgp(fr, dr(:,i));
    string = ['mdl_nd_',num2str(i),'_disp_',num2str(dispnum),'.mat'];
    save(string, 'mdl', 'nd')
end



%% PREDICTION

clc
dispnum = 1;

%%%%

load BW_data.mat


y = y1(1:150,:);
[~, sd, vd] = svd(y);

sd = sd.^2;
nd = 1;
chkd = sum(diag(sd));
rd = 0;
while rd < 0.95
    rd = sum(diag(sd(1:nd,1:nd)))/chkd;
    nd = nd+1;
end
nd = nd-1;
fprintf('\n\n%d\n',nd);
fprintf('%.5f\n\n',sum(diag(sd(1:nd,1:nd)))/sum(diag(sd)));

%%%%

[~, sf, vf] = svd(force(1:150,:));

%%%%

    load BW_SDOF_testing_data_FT_20.mat
% %     load BW_SDOF_testing_data_FT_25.mat
% %     load BW_SDOF_testing_data_FT_50.mat
% %     load BW_SDOF_testing_data_FT_75.mat
% % load BW_SDOF_testing_data_FT_100.mat


y = y1';

pfr = force'*vf(:,1:nd);
for i = 1:nd
    fprintf('%d\n',i)
    string = ['mdl_nd_',num2str(i),'_disp_',num2str(dispnum),'.mat'];
    load(string)
    pr = predict(mdl, pfr);
    pdr(:,i) = pr;
end

%%%%

pdod = pdr*vd(:,1:nd)';

num = 100;
figure;
plot(pdod(num,:),'r'); hold on
plot(y(num,:),'b--')

displacement(dispnum,:,:) = pdod;

%%%%

i = 1;
y = y1;

figure;
plot(squeeze(mean(displacement(i,:,:),2)),'r'); hold on
plot(mean(y,2),'b--')
plot(std(squeeze(displacement(i,:,:)),[],1),'r'); hold on
plot(std(y,[],2),'b--')





