clc
clear
close all

for dispnum = 1:5

    %%%%

    load data_5DOF_duffing_1500_samples.mat

    if dispnum == 1
        y = y1;
    elseif dispnum == 2
        y = y2;
    elseif dispnum == 3
        y = y3;
    elseif dispnum == 4
        y = y4;
    else
        y = y5;
    end

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

    [~, sf, vf] = svd(f);

    % sf = sf.^2;
    % nf = 1;
    % chkf = sum(diag(sf));
    % rf = 0;
    % while rf < 0.99
    %     rf = sum(diag(sf(1:nf,1:nf)))/chkf;
    %     nf = nf+1;
    % end
    % disp(nf);
    %
    % fr = f*vf(:,1:nf);

    fr = f*vf(:,1:nd);

    %%%%

    for i = 1:nd
        fprintf('%d\n',i)
        mdl = fitrgp(fr, dr(:,i));
        string = ['mdl_nd_',num2str(i),'_disp_',num2str(dispnum),'.mat'];
        save(string, 'mdl', 'nd')
    end
end


%% PREDICTION

clc
for dispnum = 1:5

    %%%%

    load data_5DOF_duffing_1500_samples.mat

    if dispnum == 1
        y = y1;
    elseif dispnum == 2
        y = y2;
    elseif dispnum == 3
        y = y3;
    elseif dispnum == 4
        y = y4;
    else
        y = y5;
    end

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

    [~, sf, vf] = svd(f);

    %%%%

    load 5DOF_DO_testing_data_FT_20.mat
% %     load 5DOF_DO_testing_data_FT_25.mat
% %     load 5DOF_DO_testing_data_FT_50.mat
% %     load 5DOF_DO_testing_data_FT_75.mat
% %     load 5DOF_DO_testing_data_FT_100.mat    

    if dispnum == 1
        y = y1;
    elseif dispnum == 2
        y = y2;
    elseif dispnum == 3
        y = y3;
    elseif dispnum == 4
        y = y4;
    else
        y = y5;
    end

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
    plot(y(:,num),'b--')

    displacement(dispnum,:,:) = pdod;

    %%%%

end

%%%%

for i = 1:5
    if i == 1
        y = y1;
    elseif i == 2
        y = y2;
    elseif i == 3
        y = y3;
    elseif i == 4
        y = y4;
    else
        y = y5;
    end

    num = 100;

    figure;
    plot(squeeze(mean(displacement(i,:,:),2)),'r'); hold on
    plot(mean(y,2),'b--')
    plot(std(squeeze(displacement(i,:,:)),[],1),'r'); hold on
    plot(std(y,[],2),'b--')
end




