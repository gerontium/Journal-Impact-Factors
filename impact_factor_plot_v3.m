clear
close all
clc

% read in impact factor list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\JCR_2015.xls');
% 1: Rank
% 2: Name
% 6: Impact Factor
% 7: 5-Year Impact Factor

raw = raw(4:end-1,[2,6,7]);
raw(find(strcmp(raw(:,2),'Not Available') | strcmp(raw(:,3),'Not Available')),:) = [];

journal_names = caseconvert(raw(:,1),'upper');
impact_factor = str2double(raw(:,2));
impact_factor5 = str2double(raw(:,3));

% read in 1st neuro journal list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\scimagojr.xlsx');
neuro_journals = raw(2:end,2);

% read in 2nd neuro journal list
[num,txt,raw] = xlsread('C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\neuro_journals.xlsx');
neuro_journals = [neuro_journals;raw];

% convert to upper case
neuro_journals = caseconvert(neuro_journals,'upper');
% add my journals if necessary
my_journals = {'CORTEX','NEUROREPORT','CURRENT BIOLOGY','SCIENTIFIC REPORTS','NEUROPSYCHOLOGIA','JOURNAL OF NEUROSCIENCE','PLOS BIOLOGY'}';
neuro_journals = [neuro_journals;my_journals];
% get unique journals
[neuro_journals,ia,ic] = unique(neuro_journals);
neuro_journal_IFs = NaN(length(neuro_journals),1);

% take out review journals?
review_journals = {'NATURE REVIEWS NEUROSCIENCE';'BEHAVIORAL AND BRAIN SCIENCES';'ANNUAL REVIEW OF NEUROSCIENCE'; ...
    'TRENDS IN NEUROSCIENCES';'PROGRESS IN NEUROBIOLOGY';'ANNALS OF NEUROLOGY';'CURRENT OPINION IN NEUROBIOLOGY'};

% match neuro journals to database
unlisted_neurojs={};
for i = 1:length(neuro_journals)
    jindx = find(strcmp(neuro_journals{i},journal_names));
    if jindx & isempty(find(strcmp(neuro_journals{i},review_journals)))
        jindx = jindx(1);
        neuro_journal_IFs(i) = impact_factor5(jindx);
    else
        unlisted_neurojs = [unlisted_neurojs;neuro_journals{i}];
    end
end

% get rid of nan breads
neuro_journals(find(isnan(neuro_journal_IFs))) = [];
neuro_journal_IFs(find(isnan(neuro_journal_IFs))) = [];

% sort if wanted
% [neuro_journal_IFs,indx] = sort(neuro_journal_IFs,'ascend');
% neuro_journals = neuro_journals(indx);

% randomise if wanted
% indx = randperm(length(neuro_journals));
% neuro_journal_IFs = neuro_journal_IFs(indx);
% neuro_journals = neuro_journals(indx);

% get my journal indices
[my_journal_names,~,mjindx] = intersect(my_journals,neuro_journals);
my_journal_IFs = neuro_journal_IFs(mjindx);
% reorder
% indx2 = [5,4,1,2,7,3,6];
indx2 = [5,4,1,7,2,3,6];
my_journal_IFs = my_journal_IFs(indx2);
% [my_journal_IFs,indx2] = sort(my_journal_IFs,'ascend');
my_journal_names = my_journal_names(indx2);

% plots
figure, plot(neuro_journal_IFs)
IF_med = median(neuro_journal_IFs);
IF_prc = prctile(neuro_journal_IFs,[10,25,50,75,90]);

%%
fonto = 'Trebuchet';
cmap = colormap(lines);
figure
h = bar([1:length(my_journal_IFs)],my_journal_IFs,'hist');
h.FaceColor = cmap(2,:);
% h.FaceColor = [0.5 0.5 0.5];
h.EdgeColor = cmap(1,:);
set(gca,'FontSize',16,'xlim',[0,8],'ylim',[0,12],'xtick',[],'Box','off')
% set(get(h,'Parent'),'ydir','r');
% xlabel('Strength'), ylabel('Count')
ylabel('Impact Factor','FontName',fonto)
hold on;
for i = 3:length(IF_prc)
    line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
end


%%
cmap = colormap(lines);
cmap1 = colormap(gray);
fonto = 'Trebuchet';
colour_backg1=[];
colour_backg1(:,1) = ones(9,1)*IF_prc(3);
colour_backg1(:,2) = ones(9,1)*IF_prc(4)-IF_prc(3);
colour_backg1(:,3) = ones(9,1)*IF_prc(5)-IF_prc(4);
figure

h = bar([1:length(my_journal_IFs)],my_journal_IFs,'hist');
h.FaceColor = cmap(2,:);
% h.FaceColor = [0.5 0.5 0.5];
% h.EdgeColor = cmap(1,:);
set(gca,'FontSize',16,'xlim',[0,8],'ylim',[0,12],'xtick',[],'Box','off')
% set(get(h,'Parent'),'ydir','r');
% xlabel('Strength'), ylabel('Count')
ylabel('Impact Factor','FontName',fonto)
hold on;

h1 = area([0:8],colour_backg1);
h1(1).FaceColor = [cmap1(10,:)]; h1(2).FaceColor = [cmap1(20,:)]; h1(3).FaceColor = [cmap1(30,:)];
h1(1).EdgeColor = 'none'; h1(2).EdgeColor = 'none'; h1(3).EdgeColor = 'none';
h1(1).FaceAlpha = 0.8; h1(2).FaceAlpha = 0.8; h1(3).FaceAlpha = 0.8;

% for i = 3:length(IF_prc)
%     line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
% end

%%
cmap = colormap(lines);
cmap1 = colormap(pink);

% cmap1 = cmap1.*repmat([0.8;0.1;0.1],1,size(cmap1,1))';

fonto = 'Trebuchet';
colour_backg1=[];
colour_backg1(:,1) = ones(9,1)*IF_prc(4);
colour_backg1(:,2) = ones(9,1)*IF_prc(5)-IF_prc(4);
colour_backg1(:,3) = ones(9,1)*12-IF_prc(5);
figure

h = bar([1:length(my_journal_IFs)],my_journal_IFs,'hist');
h.FaceColor = cmap(2,:);
% h.FaceColor = [0.5 0.5 0.5];
% h.EdgeColor = cmap(1,:);
set(gca,'FontSize',16,'xlim',[0,8],'ylim',[0,12],'xticklabels',my_journal_names,'Box','off')
ax = gca;
ax.XTickLabelRotation = -45; 
ax.FontSize = 8; ax.FontName = fonto; 
ylabel('Impact Factor','FontSize',16,'FontName',fonto)
hold on;

h1 = area([0:8],colour_backg1);
h1(1).FaceColor = [cmap1(15,:)]; h1(2).FaceColor = [cmap1(30,:)];  h1(3).FaceColor = [cmap1(50,:)];
h1(1).EdgeColor = 'none'; h1(2).EdgeColor = 'none'; h1(3).EdgeColor = 'none';
h1(1).FaceAlpha = 0.5; h1(2).FaceAlpha = 0.5; h1(3).FaceAlpha = 0.5;

legend(fliplr(h1), {'Top 10%','Top 25%','Rest of journals'},'Location','NorthWest')

% for i = 3:length(IF_prc)
%     line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
% end
return
%%
cmap = colormap(lines);
cmap1 = colormap(pink);

% cmap1 = cmap1.*repmat([0.8;0.1;0.1],1,size(cmap1,1))';

fonto = 'Trebuchet';
colour_backg1=[];
colour_backg1(:,1) = ones(129,1)*IF_prc(4);
colour_backg1(:,2) = ones(129,1)*IF_prc(5)-IF_prc(4);
colour_backg1(:,3) = ones(129,1)*12-IF_prc(5);
figure

h = scatter([1:length(neuro_journal_IFs)],neuro_journal_IFs,20,'filled'); hold on
h.MarkerFaceColor = cmap(9,:);
% h.MarkerFaceColor = 'b';
h.MarkerEdgeColor = 'k';
h2 = scatter(mjindx,my_journal_IFs,100,'filled');
h2.MarkerFaceColor = cmap(3,:);
% h2.MarkerFaceColor = 'r';
h2.MarkerEdgeColor = 'k';
set(gca,'FontSize',16,'xlim',[-5,123],'ylim',[0,12],'xtick',[],'Box','off')

% h = bar([1:length(my_journal_IFs)],my_journal_IFs,'hist');
% h.FaceColor = cmap(2,:);
% % h.FaceColor = [0.5 0.5 0.5];
% % h.EdgeColor = cmap(1,:);
% set(gca,'FontSize',16,'xlim',[0,8],'ylim',[0,12],'xticklabels',my_journal_names,'Box','off')
% ax = gca;
% ax.XTickLabelRotation = -45; 
% ax.FontSize = 8; ax.FontName = fonto; 

ylabel('Impact Factor','FontSize',16,'FontName',fonto)
hold on;

h1 = area([-5:123],colour_backg1);
h1(1).FaceColor = [cmap1(15,:)]; h1(2).FaceColor = [cmap1(30,:)];  h1(3).FaceColor = [cmap1(50,:)];
h1(1).EdgeColor = 'none'; h1(2).EdgeColor = 'none'; h1(3).EdgeColor = 'none';
h1(1).FaceAlpha = 0.5; h1(2).FaceAlpha = 0.5; h1(3).FaceAlpha = 0.5;

legend(fliplr(h1), {'Top 10%','Top 25%','Rest of journals'},'Location','NorthWest')

return

%%
cmap = colormap(gray);
figure
h = scatter([1:length(neuro_journal_IFs)],neuro_journal_IFs,20,'filled'); hold on
h.MarkerFaceColor = cmap(32,:);
h1 = scatter(mjindx,my_journal_IFs,40,'filled');
h1.MarkerFaceColor = 'r';
line([xlim],[IF_med,IF_med],'Color','k','LineWidth', 2);
% xlabel('Journal','FontName','Arial'); % or axis off
ylabel('Impact Factor','FontName','Arial')
title('My Research Impact')
set(gca,'FontSize',16,'xticklabel',{})


%%
fonto = 'Trebuchet';
cmap = colormap(lines);
% image version
backpic = imread(['C:\Users\loughnge\Dropbox\Maps\Journal Impact Factors\backpic5.jpg']);
% backpic = backpic(1:end-130,:,:);
% -5   123
xImg = linspace(-5, 123, size(backpic, 2));
yImg = linspace(0, 18, size(backpic, 1));
figure
im = image(xImg, yImg, flipud(backpic), 'CDataMapping', 'scaled');
im.AlphaData = 1;
set(gca,'YDir','normal')
hold on;
for i = 4%3:length(IF_prc)
    line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
end

h = scatter([1:length(neuro_journal_IFs)],neuro_journal_IFs,20,'filled'); hold on
h.MarkerFaceColor = cmap(9,:);
% h.MarkerFaceColor = 'b';
h.MarkerEdgeColor = 'k';
h1 = scatter(mjindx,my_journal_IFs,100,'filled');
h1.MarkerFaceColor = cmap(3,:);
% h1.MarkerFaceColor = 'r';
h1.MarkerEdgeColor = 'k';
% line([xlim],[IF_med,IF_med],'Color','k','LineWidth', 2);
% for i = 1:length(IF_prc)
%     line([xlim],[IF_prc(i),IF_prc(i)],'Color','k','LineWidth', 1);
% end
% xlabel('Journal','FontName',fonto); % or axis off
% ylabel('Lower Impact <<<->>> Higher Impact','FontName',fonto)
ylabel('Impact Factor','FontName',fonto)
% title('My Research Impact','FontName',fonto)
legend([h,h1], {'General Impact', 'My Impact'},'Location','NorthWest')
% set(gca,'position',[0.15 0.15 0.7 0.7],'FontSize',16,'xtick',[],'ylim',[0,18],'FontName',fonto)
set(gca,'FontSize',16,'xtick',[],'ylim',[0,18],'FontName',fonto)
box off