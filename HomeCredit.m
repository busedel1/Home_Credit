
%% 初期化
clear 

%% データの読み込み

train_name='application_train.csv';%
test_name='application_test.csv';
% bureau_name='bureau.csv';
% bureau_bal_name='bureau_balance.csv';
% POS_CAH_bal_name='POS_CASH_balance.csv';
% creditbal_name='credit_card_balance.csv';
% previous_app='previous_application.csv';
% Home_Credit='HomeCrefit_columns_description.csv';

train_df=readtable(train_name);
test_df=readtable(test_name);
% bureau_df=readtable(bureau_name);
% bureau_bal_df=readtable(bureau_bal_name);
% POS_CAH_df=readtable(POS_CAH_bal_name);
% creditbal_df=readtable(creditbal_name);
% previous_df=readtable(previous_app);
% credit_df=readtable(Home_Credit);

% train_df=readtable(train_name,'Format','%f%f%f%q%C%f%f%f%q%f%q%C');
% test_df=readtable(test_name,'Format','%f%f%q%C%f%f%f%q%f%q%C');

%% データの基礎情報の確認

disp(train_df(1:2,:));
disp(test_df(1:2,:));
disp(grpstats(train_df(:,{'TARGET','NAME_INCOME_TYPE'}), {'TARGET','NAME_INCOME_TYPE'}));
disp(grpstats(train_df(:,{'TARGET','AMT_INCOME_TOTAL'}),{'AMT_INCOME_TOTAL'}))

% train_dfの列が122もある⇒この中からお金の貸し出しに重要そうなものを選ぶ
% "TARGET"が出力値
%'FLAG_OWN_CAR', ''FLAG_OWN_REARTY', 'AMT_INCOME_TOTAL','AMT_CREDIT', 'AMT_ANNUITY'
%'AMT_GOODS_PRICE', 'NAME_INCOME_TYPE','NAME_EDUCATION_TYPE', 'NAME_FAMILY_STATUS'
%'DAYS_EMPLOYED', 'REGION_RATIONG_CLIENT_W_CITY'が大きく影響していそう（11個）

%% データの抜出

train_df = train_df(:,{'SK_ID_CURR','TARGET', 'FLAG_OWN_REALTY','AMT_INCOME_TOTAL','AMT_CREDIT'...
    ,'AMT_CREDIT','AMT_GOODS_PRICE','NAME_INCOME_TYPE', 'NAME_EDUCATION_TYPE'...
    ,'NAME_FAMILY_STATUS','DAYS_EMPLOYED'});
test_df = test_df(:,{'SK_ID_CURR','FLAG_OWN_REALTY','AMT_INCOME_TOTAL','AMT_CREDIT'...
    ,'AMT_CREDIT','AMT_GOODS_PRICE','NAME_INCOME_TYPE', 'NAME_EDUCATION_TYPE'...
    ,'NAME_FAMILY_STATUS','DAYS_EMPLOYED'});
disp(train_df(1:2,:));

%% 欠損値の確認
vars = train_df.Properties.VariableNames;  % tableの変数名を取得
%欠損値の図
clf;
figure(1) 
imagesc(ismissing(train_df))
ax = gca;
ax.XTick = 1:11;
ax.XTickLabel = vars;
ax.XTickLabelRotation = 90;
title('Missing Values')

%% データ型を数値へ
train_df.FLAG_OWN_REALTY=double(categorical(train_df.FLAG_OWN_REALTY));
train_df.NAME_INCOME_TYPE=double(categorical(train_df.NAME_INCOME_TYPE));
train_df.NAME_EDUCATION_TYPE=double(categorical(train_df.NAME_EDUCATION_TYPE));
train_df.NAME_FAMILY_STATUS=double(categorical(train_df.NAME_FAMILY_STATUS));

test_df.FLAG_OWN_REALTY=double(categorical(test_df.FLAG_OWN_REALTY));
test_df.NAME_INCOME_TYPE=double(categorical(test_df.NAME_INCOME_TYPE));
test_df.NAME_EDUCATION_TYPE=double(categorical(test_df.NAME_EDUCATION_TYPE));
test_df.NAME_FAMILY_STATUS=double(categorical(test_df.NAME_FAMILY_STATUS));


%% 分類学習器
X_test=test_df(:,2:end);


%% 提出用ファイルの作成
SK_ID_CURR= test_df.SK_ID_CURR;
TARGET=trainedModel1.predictFcn(X_test);
TARGET=abs(TARGET);
submission=table(SK_ID_CURR,TARGET);
writetable(submission,'submission.csv')  
















