clear all
close all
verbose=0;
num_particles=100;
percentage_divider = 0.8;
prediction_days = 14;
mean_manipulator = 0.001;
%%
indexName='SP500';
stocksNames={'AAPL';'JNJ';'MSFT';'XOM';'GE';'BRK-B';'JPM';'WFC';'AMZN'};
%Dates Jan2010-Dec2014

indexcell=import_AdjClose([indexName,'.csv']);
dates=datetime(indexcell{1,1});
index=zeros(length(indexcell),1);
index(1)=indexcell{1,2};
date_string_cell =  {}; 
date_string_cell(1) = {indexcell{1,1}};
for j=2:length(indexcell)
        dates=[dates,datetime(indexcell{j,1})];
        index(j)=indexcell{j,2};
        date_string_cell(j) = {indexcell{j,1}};
end
%% 
stocks=zeros(length(indexcell),length(stocksNames));
for i = 1:length(stocksNames);
    name=[stocksNames{i},'.csv'];
    stock=import_AdjClose(name);
    stock=stock(:,2);
    for j=1:length(indexcell)
        stocks(j,i)=(stock{j});
    end
end
%% DIVIDE DATA IN TRAINING AND VALIDATION SETS

time_selection = 50;
date_string_cell = date_string_cell(1:(end-time_selection));
dates=dates(1:(end-time_selection));
index=index(1:(end-time_selection),:);
stocks=stocks(1:(end-time_selection),:);

index_val=index((end-prediction_days):end,:);
stocks_val=stocks((end-prediction_days):end,:);
index=index(1:(end-prediction_days),:);
stocks=stocks(1:(end-prediction_days),:);


%%

plot(index);hold on;
plot(stocks)
legend('index','AAPL','JNJ','MSFT','XOM','GE','BRK-B','JPM','WFC','AMZN');

%%

% for i = 1:size(stocks,2)
%     p(:,i)= polyfit(index,stocks(:,i),1);
%     figure;
%     scatter(index,stocks(:,i));
%     hold on; grid on;
%     plot(index,p(1,i)*index+p(2,i));
%     
% end

for i = 1:size(stocks,2)
    p(:,i)= polyfit(index,stocks(:,i),1);
    figure;
    scatter(index,stocks(:,i));
    hold on; grid on;
    plot(index,p(1,i)*index+p(2,i));
    
end

%% Process model
process_noise_variance = var(index);
initial_state = index_val(1);

%% Measurement model (contributions of each stock)
figure;
weights = regress(index,stocks);
weightss = repmat(weights,1,size(stocks,1)); %wx=z x is stocks w is weight for each z is measuremnt(weighted sum of stocks)
meas=sum(weightss.*stocks',1)';
scatter(meas,index);hold on;
xlabel('meas');
ylabel('pred index');
coef=polyfit(meas,index,1);
coef(1)
coef(2)
% coef(2) = coef(2) + 40;
pred_index=coef(1)*meas+coef(2); %y=az+b=a*wx+b y is predicted index value
plot(meas,pred_index);
%% VALIDATION
weightss_val = repmat(weights,1,size(stocks_val,1)); %wx=z x is stocks w is weight for each z is measuremnt(weighted sum of stocks)
meas_val=sum(weightss_val.*stocks_val',1)';
figure;
scatter(meas_val,index_val);hold on;
pred_index=coef(1)*meas_val+coef(2); %y=az+b=a*wx+b y is predicted index value
plot(meas_val,pred_index);
xlabel('meas val');
ylabel('pred index');

%% Correlation

corrCoefs=corrcoef_matrix([stocks,index]);
corrCeofs=corrcoef_matrix([stocks_val,index_val]);


%% Error
figure;
err=pred_index-index_val;
plot(err);
mean(err)
measurement_noise_variance = var(err);

% Particle filter
% process_noise_variance = 500%[5,10, 50, 100, 500, 1000, 2000];
% measurement_noise_variance = 5%[5,10, 50, 100, 500, 1000, 2000];
% num_particles=[2000];
% rmse = zeros(length(process_noise_variance),length(measurement_noise_variance),length(num_particles));
% mean_manipulator=[0.001];
% for k=1:1:length(process_noise_variance)
%     for l=1:1:length(measurement_noise_variance)
%         for m=1:1:length(num_particles)
%             [estimate, particle_vector] = particle_filter(initial_state, meas_val, num_particles(m), coef, process_noise_variance(k), measurement_noise_variance(l),mean_manipulator(m),verbose);
%             rmse(k,l,m) = calculate_RMSE( index_val, estimate)
% 
%         end
%     end
% end

process_noise_variance = [ 150];
measurement_noise_variance = [ 200];
num_particles=[2000];
mean_manipulator=[-0.015];
rmse = zeros(length(process_noise_variance),length(measurement_noise_variance),length(mean_manipulator));
bias = zeros(length(process_noise_variance),length(measurement_noise_variance),length(mean_manipulator));
for k=1:1:length(process_noise_variance)
    for l=1:1:length(measurement_noise_variance)
        for m=1:1:length(mean_manipulator)
            [estimate, particle_vector] = particle_filter(initial_state, meas_val, num_particles, coef, process_noise_variance(k), measurement_noise_variance(l),mean_manipulator(m),verbose);
            rmse(k,l,m) = calculate_RMSE( index_val, estimate)
            bias(k,l,m) = calculate_BIAS( index_val, estimate)
            
            figure;hold;
time_scale = 1:length(estimate);
plot(time_scale,estimate);
plot(time_scale,pred_index);
plot(time_scale,index_val);
% plot(dates((end-prediction_days):end),estimate);
% plot(dates((end-prediction_days):end), pred_index);
% plot(dates((end-prediction_days):end), index_val);
ax=gca;
ax.XTick=time_scale;
ax.XTickLabel = date_string_cell((end-prediction_days):end);
% plot(filter([1/4 1/4 1/4 1/4], 1, estimate))
legend('est','meas','index');
rotateXLabels( gca(), 90 );
xlim([1 14]);
            
            

        end
    end
end

% process_noise_variance = [500];
% measurement_noise_variance = [5];
% num_particles=[2000];
% mean_manipulator=[0.001];
% rmse = zeros(length(process_noise_variance),length(measurement_noise_variance),length(mean_manipulator));
% for k=1:1:length(process_noise_variance)
%     for l=1:1:length(measurement_noise_variance)
%         for m=1:1:length(mean_manipulator)
%             [estimate, particle_vector] = particle_filter(initial_state, meas_val, num_particles, coef, process_noise_variance(k), measurement_noise_variance(l),mean_manipulator(m),verbose);
%             rmse(k,l,m) = calculate_RMSE( index_val, estimate)
% 
%         end
%     end
% end

%% plot estimate
figure;hold;
time_scale = 1:length(estimate);
plot(time_scale,estimate);
plot(time_scale,pred_index);
plot(time_scale,index_val);
% plot(dates((end-prediction_days):end),estimate);
% plot(dates((end-prediction_days):end), pred_index);
% plot(dates((end-prediction_days):end), index_val);
ax=gca;
ax.XTick=time_scale;
ax.XTickLabel = date_string_cell((end-prediction_days):end);
% plot(filter([1/4 1/4 1/4 1/4], 1, estimate))
legend('est','meas','index');
rotateXLabels( gca(), 90 );
xlim([1 14]);


% %% calculate returns
% index_daily_ret=index(2:end,:)./index(1:end-1,:)-1;
% figure
% %plot(index_daily_ret)
% plot(hist(index_daily_ret, 100))
% figure
% index_val_daily_ret=index_val(2:end,:)./index_val(1:end-1,:)-1;
% plot(hist(index_val_daily_ret, 2))
% plot(index_val_daily_ret)
% mean(index_val_daily_ret);


